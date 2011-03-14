package org.yellcorp.lib.net.multiloader
{
import org.yellcorp.lib.core.Destructor;
import org.yellcorp.lib.core.Set;
import org.yellcorp.lib.net.multiloader.core.MultiLoaderItem;
import org.yellcorp.lib.net.multiloader.core.ml_internal;
import org.yellcorp.lib.net.multiloader.events.MultiLoaderErrorEvent;
import org.yellcorp.lib.net.multiloader.events.MultiLoaderItemEvent;

import flash.events.AsyncErrorEvent;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;
import flash.utils.Dictionary;


/**
 * A MultiLoader manages a set of resources to be loaded asynchronously. It
 * manages concurrent loading, and <code>PROGRESS</code> and
 * <code>COMPLETE</code> events for the set as a whole.
 *
 * Resources are queued by calling <code>addItem</code> with a unique string
 * id, and an instance of <code>MultiLoaderItem</code>.
 * <code>MultiLoaderItem</code> is an abstract base class for adapting the
 * various interfaces and events involved in loading resources through Flash
 * Player.  There are MultiLoaderItem subclasses for the native Loader and
 * URLLoader, as well as custom ones for loading BitmapData and XML.
 *
 * Instances of <code>MultiLoaderItem</code> remain associated with a
 * <code>MultiLoader</code> after they have completed, and can be retrieved
 * using the id they originally were associated with.  Subclasses of
 * <code>MultiLoaderItem</code> provide getters of an appropriate type to
 * access the loaded data, and should be cast to their original type when
 * retrieved.
 */

[Event(name="multiloaderError", type="org.yellcorp.lib.net.multiloader.events.MultiLoaderErrorEvent")]
[Event(name="itemComplete", type="org.yellcorp.lib.net.multiloader.events.MultiLoaderItemEvent")]
[Event(name="itemStart", type="org.yellcorp.lib.net.multiloader.events.MultiLoaderItemEvent")]
[Event(name="complete", type="flash.events.Event")]
[Event(name="progress", type="flash.events.ProgressEvent")]
public class MultiLoader extends EventDispatcher implements Destructor
{
    /**
     * The order in which waiting loaders are started.
     * <code>MultilLoaderOrder.FIFO</code> takes items from the front of the
     * queue, which are the earliest added items.
     * <code>MultilLoaderOrder.LIFO</code> takes items from the back of the
     * queue, which are the most recently added items.
     */
    public var order:String;

    private var _errorPolicy:String;
    private var _dispatchUnknownProgress:Boolean;

    private var _concurrent:int;
    private var _started:Boolean;

    private var idToItem:Object;
    private var itemToId:Dictionary;

    private var queue:Array;
    private var openItems:Set;
    private var completedItems:Set;
    private var errorItems:Set;
    private var _totalCount:uint;

    /**
     * Creates a new, empty MultiLoader.
     *
     * @param order        The order in which waiting loaders are started.
     *
     * @param errorPolicy  How the MultiLoader should behave when an
     *         attempted load results in an error.
     *         <code>MultiLoaderErrorPolicy.ABORT</code> cancels all pending
     *         loads when an attempt to load an item results in an error.
     *         <code>MultiLoaderErrorPolicy.ALWAYS_COMPLETE</code> will ignore
     *         errors and dispatch Event.COMPLETE when the queue is empty.
     *         <code>MultiLoaderErrorPolicy.COMPLETE_IF_NO_ERRORS</code> will
     *         attempt to load every item in the queue, but only dispatch
     *         Event.COMPLETE if all items loaded successfully.
     *
     * @param dispatchUnknownProgress If true, the MultiLoader will dispatch
     *         <code>Event.PROGRESS</code> even if the value for
     *         <code>totalBytes</code> is not known.  This can occur when there
     *         are items still waiting in the queue, or if an HTTP response is
     *         sent without a <code>Content-Length</code> header.
     */
    public function MultiLoader(order:String = "fifo", errorPolicy:String = "abort", dispatchUnknownProgress:Boolean = false)
    {
        this.order = order;

        switch (errorPolicy)
        {
            case MultiLoaderErrorPolicy.ABORT :
            case MultiLoaderErrorPolicy.COMPLETE_ALWAYS :
            case MultiLoaderErrorPolicy.COMPLETE_IF_NO_ERRORS :
                _errorPolicy = errorPolicy;
                break;
            default :
                _errorPolicy = MultiLoaderErrorPolicy.ABORT;
                break;
        }

        _dispatchUnknownProgress = dispatchUnknownProgress;

        _concurrent = 1;
        queue = [ ];
        idToItem = { };
        itemToId = new Dictionary();
        openItems = new Set();
        completedItems = new Set();
        errorItems = new Set();
        super();
    }

    /**
     * Retrieve the current error policy for this MultiLoader. This value
     * can only be set in the constructor.
     */
    public function get errorPolicy():String
    {
        return _errorPolicy;
    }

    /**
     * Retrieve whether to dispatch <code>Event.PROGRESS</code> when
     * <code>totalBytes</code> is not known. This value can only be set in
     * the constructor.
     */
    public function get dispatchUnknownProgress():Boolean
    {
        return _dispatchUnknownProgress;
    }

    /**
     * Frees memory associated with this MultiLoader and each loader it
     * manages. This should always be called when the MultiLoader instance
     * is no longer required.
     */
    public function destroy():void
    {
        queue = null;
        itemToId = null;
        openItems = null;
        completedItems = null;
        errorItems = null;
        for each (var item:MultiLoaderItem in idToItem)
        {
            item.destroy();
        }
        idToItem = null;
    }

    /**
     * Determines whether the MultiLoader is managing a MultiLoaderItem with
     * a given id.
     *
     * @param id The id to test.
     * @return true if there is an item with the specified id, false if not.
     */
    public function hasId(id:String):Boolean
    {
        return idToItem.hasOwnProperty(id);
    }

    /**
     * Determines whether the MultiLoader is managing an instance of a
     * MultiLoaderItem.
     *
     * @param item The instance to test.
     * @return true if the MultiLoader is managing <code>item</code>. false
     *         if not, or if <code>item</code> is null or undefined.
     */
    public function hasItem(item:MultiLoaderItem):Boolean
    {
        if (item)
        {
            return Boolean(itemToId[item]);
        }
        else
        {
            return false;
        }
    }

    /**
     * Returns a MultiLoaderItem associated with a given id, if it exists.
     *
     * @param id The id of the item to return.
     * @return The item with the specified id, or null if there is no such
     *         item.
     */
    public function getItemById(id:String):MultiLoaderItem
    {
        return hasId(id) ? idToItem[id] : null;
    }

    /**
     * Returns the id associated with a managed MultiLoaderItem instance.
     *
     * @param item The item to identify.
     * @return The id by which the item is known, or null if the item is
     *         not present in the MultiLoader.
     */
    public function getItemId(item:MultiLoaderItem):String
    {
        return hasItem(item) ? itemToId[item] : null;
    }

    /**
     * Adds an item to the MultiLoader queue, and associates it with an id
     * for later retrieval.
     *
     * @param id A string id by which to associate the item.
     * @param item The item to add.
     * @throws ArgumentError if the specified id is already used, or if the
     *         item is already under control of a MultiLoader
     */
    public function addItem(id:String, item:MultiLoaderItem):void
    {
        if (hasId(id))
        {
            throw new ArgumentError("An item already exists with id '"+id+"'");
        }
        if (item.ml_internal::callback)
        {
            throw new ArgumentError("Item is already managed by a MultiLoader instance");
        }
        item.ml_internal::callback = this;
        idToItem[id] = item;
        itemToId[item] = id;
        _totalCount++;
        queue.push(item);
        advance();
    }

    /**
     * Starts loading queued items.
     */
    public function start():void
    {
        _started = true;
        advance();
    }

    /**
     * Whether queue processing is underway.
     * @return true if <code>start()</code> has been called and queue
     *         processing is underway
     */
    public function get started():Boolean
    {
        return _started;
    }

    /**
     * The maximum number of simultaneous loads allowed.
     */
    public function get concurrent():uint
    {
        return _concurrent;
    }

    public function set concurrent(concurrent:uint):void
    {
        _concurrent = concurrent;
        advance();
    }

    /**
     * The number of bytes loaded by the MultiLoader.
     */
    public function get bytesLoaded():uint
    {
        var loaded:uint = 0;
        for each (var item:MultiLoaderItem in idToItem)
        {
            loaded += item.bytesLoaded;
        }
        return loaded;
    }

    /**
     * The total number of bytes to be loaded by all items in the
     * MultiLoader. If this number is not known, it is set to 0.
     */
    public function get bytesTotal():uint
    {
        var total:uint = 0;
        if (queueCount > 0) return 0;
        for each (var item:MultiLoaderItem in idToItem)
        {
            if (!item.bytesTotalKnown || item.bytesTotal == 0)
            {
                return 0;
            }
            else
            {
                total += item.bytesTotal;
            }
        }
        return total;
    }

    /**
     * Whether the total number of bytes is known. If this is
     * <code>false</code>, querying <code>bytesTotal</code> will return 0.
     */
    public function get bytesTotalKnown():Boolean
    {
        if (queueCount > 0) return false;
        for each (var item:MultiLoaderItem in idToItem)
        {
            if (!item.bytesTotalKnown)
            {
                return false;
            }
        }
        return true;
    }

    /**
     * The number of items waiting to begin loading.
     */
    public function get queueCount():uint
    {
        return queue.length;
    }

    /**
     * The number of items in progress.
     */
    public function get openCount():uint
    {
        return openItems.length;
    }

    /**
     * The number of items that have successfully completed loading.
     */
    public function get completeCount():uint
    {
        return completedItems.length;
    }

    /**
     * The number of items which have resulted in errors.
     */
    public function get errorCount():uint
    {
        return errorItems.length;
    }

    /**
     * The total number of items.  Equal to <code>queueCount +
     * openCount + completeCount + errorCount</code>
     */
    public function get totalCount():uint
    {
        return _totalCount;
    }

    /**
     * Whether all loading is complete. Note that this is affected by the
     * value of <code>errorPolicy</code>. In short, this property reflects
     * if <code>Event.COMPLETE</code> has been dispatched. If all items have
     * loaded successfully, this property is <code>true</code>. If there are
     * no more items in the queue, and some have resulted in errors, this
     * property is <code>true</code> if <code>errorPolicy</code> is
     * <code>COMPLETE_ALWAYS</code> and <code>false</code> otherwise.
     */
    public function get isComplete():Boolean
    {
        return _started && queueCount == 0 && openCount == 0 &&
               (_errorPolicy == MultiLoaderErrorPolicy.COMPLETE_ALWAYS || errorCount == 0);
    }

    ml_internal function onComplete(item:MultiLoaderItem):void
    {
        openItems.remove(item);
        completedItems.add(item);
        dispatchEvent(new MultiLoaderItemEvent(
                MultiLoaderItemEvent.ITEM_COMPLETE,
                getItemId(item), item, false, false));

        advance();
        itemFinished();
    }

    ml_internal function onOpen(item:MultiLoaderItem):void
    {
    }

    ml_internal function onStatus(item:MultiLoaderItem, status:int):void
    {
    }

    ml_internal function onProgress(item:MultiLoaderItem, bytesLoaded:uint, bytesTotal:uint):void
    {
        dispatchProgress();
    }

    ml_internal function onAsyncError(item:MultiLoaderItem, event:ErrorEvent):void
    {
        openItems.remove(item);
        errorItems.add(item);
        dispatchEvent(new MultiLoaderErrorEvent(
                MultiLoaderErrorEvent.MULTILOADER_ERROR,
                getItemId(item), item, event));

        advance();
        itemFinished();
    }

    private function advance():void
    {
        if (_started && shouldContinue())
        {
            fillQueue();
        }
    }

    private function shouldContinue():Boolean
    {
        if (_errorPolicy == MultiLoaderErrorPolicy.ABORT)
        {
            return errorCount == 0;
        }
        else
        {
            return true;
        }
    }

    private function fillQueue():void
    {
        while (queue.length > 0 && openItems.length < _concurrent)
        {
            startItem(getNextItem());
        }
    }

    private function startItem(item:MultiLoaderItem):void
    {
        openItems.add(item);
        try
        {
            item.ml_internal::load();

            dispatchEvent(new MultiLoaderItemEvent(
                    MultiLoaderItemEvent.ITEM_START,
                    getItemId(item), item, false, false));
        }
        catch (err:Error)
        {
            ml_internal::onAsyncError(item,
                new AsyncErrorEvent(AsyncErrorEvent.ASYNC_ERROR, false, false, err.message, err));
        }
    }

    private function getNextItem():MultiLoaderItem
    {
        return order == MultiLoaderOrder.LIFO ? queue.pop() : queue.shift();
    }

    private function itemFinished() : void
    {
        if (isComplete)
        {
            dispatchComplete();
        }
        else
        {
            dispatchProgress();
        }
    }

    private function dispatchComplete():void
    {
        dispatchEvent(new Event(Event.COMPLETE, false, false));
    }

    private function dispatchProgress():void
    {
        if (_dispatchUnknownProgress || bytesTotalKnown)
        {
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
        }
    }
}
}
