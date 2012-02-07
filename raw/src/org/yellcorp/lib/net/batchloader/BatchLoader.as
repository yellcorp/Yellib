package org.yellcorp.lib.net.batchloader
{
import org.yellcorp.lib.core.MapUtil;
import org.yellcorp.lib.error.assert;
import org.yellcorp.lib.net.batchloader.adapters.BatchLoaderItem;
import org.yellcorp.lib.net.batchloader.events.BatchItemErrorEvent;
import org.yellcorp.lib.net.batchloader.events.BatchItemEvent;
import org.yellcorp.lib.net.batchloader.events.BatchLoaderEvent;
import org.yellcorp.lib.net.batchloader.events.BatchLoaderProgressEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.utils.Dictionary;


[Event(name="batchProgress", type="org.yellcorp.lib.net.batchloader.events.BatchLoaderProgressEvent")]
[Event(name="itemComplete",  type="org.yellcorp.lib.net.batchloader.events.BatchItemEvent")]
[Event(name="itemError",     type="org.yellcorp.lib.net.batchloader.events.BatchItemErrorEvent")]
[Event(name="itemLoadStart", type="org.yellcorp.lib.net.batchloader.events.BatchItemEvent")]
[Event(name="queueComplete", type="org.yellcorp.lib.net.batchloader.events.BatchLoaderEvent")]
[Event(name="queueStart",    type="org.yellcorp.lib.net.batchloader.events.BatchLoaderEvent")]
// TODO: critical items

public class BatchLoader extends EventDispatcher
{
    public var loaderItemFactory:BatchLoaderItemFactory;

    private var _order:String;
    private var _concurrent:uint = 1;

    private var idToItemLookup:Object;
    private var itemToIdLookup:Dictionary;
    private var itemToMetadataLookup:Dictionary;
    private var idToEstimation:Object;

    private var waitingQueue:Array;

    private var _active:Boolean;

    private var zeroPoint:int;
    private var _zeroWhenTotalKnown:Boolean;

    private var _wasComplete:Boolean = true;

    public function BatchLoader(concurrent:uint = 1,
        order:String = BatchLoaderOrder.FIFO,
        loaderItemFactory:BatchLoaderItemFactory = null)
    {
        super();

        idToItemLookup = { };
        itemToIdLookup = new Dictionary(true);
        itemToMetadataLookup = new Dictionary(true);
        idToEstimation = { };

        waitingQueue = [ ];

        this.loaderItemFactory = loaderItemFactory;
        this.order = order;
        this.concurrent = concurrent;
    }

    public function dispose():void
    {
        active = false;
        for each (var item:BatchLoaderItem in idToItemLookup)
        {
            unlistenItem(item);
            item.dispose();
        }
        idToItemLookup = null;
        itemToIdLookup = null;
        itemToMetadataLookup = null;
        idToEstimation = null;
        waitingQueue = null;
    }

    // LOADER COUNTS

    /**
     * The number of queued items waiting to be loaded.
     */
    public function get queueCount():uint
    {
        return waitingQueue.length;
    }


    /**
     * The number of items currently loading.
     */
    public function get openCount():uint
    {
        return countItemsByState(ItemState.OPEN);
    }


    /**
     * The number of successfully loaded items.
     */
    public function get completeCount():uint
    {
        return countItemsByState(ItemState.COMPLETE);
    }

    /**
     * The number of unsuccessfully loaded items.
     */
    public function get errorCount():uint
    {
        return countItemsByState(ItemState.ERROR);
    }

    /**
     * The number of future size estimations made.
     */
    public function get estimationCount():uint
    {
        return MapUtil.count(idToEstimation);
    }

    /**
     * The number of items waiting to complete loading. This is equal to
     * queueCount + openCount.
     */
    public function get waitingCount():uint
    {
        return queueCount + openCount;
    }


    /**
     * The number of ids waiting to be resolved into a loaded item. This is
     * equal to queueCount + openCount + estimationCount.
     */
    public function get unresolvedCount():uint
    {
        return waitingCount + estimationCount;
    }


    /**
     * Whether all ids have been resolved without errors.
     */
    public function get isComplete():Boolean
    {
        return unresolvedCount == 0 && errorCount == 0;
    }


    /**
     * The total number of bytes loaded since the BatchLoader was
     * instantiated.
     */
    public function get bytesLoaded():Number
    {
        var loaded:Number = 0;
        for each (var metadata:ItemMetadata in itemToMetadataLookup)
        {
            loaded += metadata.bytesLoaded;
        }
        return loaded;
    }

    /**
     * The total number of bytes requested since the BatchLoader was
     * instantiated. If the bytesTotal of any individual item is unknown,
     * NaN is returned.
     */
    public function get bytesTotal():Number
    {
        var total:Number = 0;
        for each (var metadata:ItemMetadata in itemToMetadataLookup)
        {
            if (metadata.bytesTotal > 0)
            {
                total += metadata.bytesTotal;
            }
            else
            {
                return NaN;
            }
        }
        return total;
    }


    /**
     * A weighted progress factor between 0 and 1. UI that reflects a
     * percentage, progress bar, or similar indicator should use this value
     * instead of bytesLoaded/bytesTotal. It accounts for reservations,
     * size estimations, and the zero point.
     */
    public function get progress():Number
    {
        var loaded:Number = 0;
        var total:Number = 0;

        for each (var metadata:ItemMetadata in itemToMetadataLookup)
        {
            loaded += metadata.weightedBytesLoaded;
            total += metadata.weightedBytesTotal;
        }

        for each (var reserveSize:uint in idToEstimation)
        {
            total += reserveSize;
        }

        if (loaded == 0)
        {
            return 0;
        }
        else if (loaded >= total)
        {
            return 1;
        }
        else
        {
            var p:Number = (loaded - zeroPoint) / (total - zeroPoint);
            if (p > 1) return 1;
            else if (p < 0) return 0;
            else return p;
        }
    }


    public function get order():String
    {
        return _order;
    }

    public function set order(new_order:String):void
    {
        if (new_order != BatchLoaderOrder.FIFO && new_order != BatchLoaderOrder.LIFO)
        {
            throw new ArgumentError("Invalid value for order: " + new_order);
        }
        if (_order !== new_order)
        {
            _order = new_order;
            fillQueue();
        }
    }

    public function get concurrent():uint
    {
        return _concurrent;
    }

    public function set concurrent(concurrent:uint):void
    {
        _concurrent = concurrent;
        fillQueue();
    }


    /**
     * Determines whether the BatchLoader is managing a BatchLoaderItem with
     * a given id.
     *
     * @param id The id to test.
     * @return <code>true</code> if there is an item with the specified id,
     *         <code>false</code> if not.
     */
    public function hasId(id:String):Boolean
    {
        return idToItemLookup.hasOwnProperty(id);
    }


    /**
     * Determines whether the BatchLoader is managing an instance of a
     * BatchLoaderItem.
     *
     * @param item The instance to test.
     * @return <code>true</code> if the BatchLoader is managing
     *      <code>item</code>. <code>false</code> if not, or if
     *      <code>item</code> is <code>null</code> or
     *      <code>undefined</code>.
     */
    public function hasItem(item:BatchLoaderItem):Boolean
    {
        return item && itemToIdLookup[item];
    }


    /**
     * Returns a BatchLoaderItem associated with a given id, if it exists.
     *
     * @param id The id of the item to return.
     * @return The item with the specified id, or <code>null</code> if there
     *      is no such item.
     */
    public function getItemById(id:String):BatchLoaderItem
    {
        return hasId(id) ? idToItemLookup[id] : null;
    }


    /**
     * Returns the id associated with a managed BatchLoaderItem instance.
     *
     * @param item The item to identify.
     * @return The id by which the item is known, or <code>null</code> if
     *      the item is not present in the BatchLoader.
     */
    public function getItemId(item:BatchLoaderItem):String
    {
        return hasItem(item) ? itemToIdLookup[item] : null;
    }


    /**
     * Adds an item to the BatchLoader queue, and associates it with an id
     * for later retrieval.
     *
     * @param id A string id by which to associate the item.
     * @param loader The BatchLoaderItem to add.
     * @throws ArgumentError if the specified id is already used.
     */
    public function addItem(id:String, item:BatchLoaderItem, estimatedBytesTotal:uint = 0):void
    {
        if (idToItemLookup.hasOwnProperty(id))
        {
            throw new ArgumentError("id already exists: " + id);
        }

        if (idToEstimation.hasOwnProperty(id))
        {
            if (estimatedBytesTotal == 0)
            {
                estimatedBytesTotal = idToEstimation[id];
            }
            delete idToEstimation[id];
        }

        var metadata:ItemMetadata = new ItemMetadata();
        metadata.estimatedBytesTotal = estimatedBytesTotal;

        idToItemLookup[id] = item;
        itemToIdLookup[item] = id;
        itemToMetadataLookup[item] = metadata;

        waitingQueue.push(item);
        listenItem(item);

        fillQueue();
    }


    public function addRequest(id:String, request:URLRequest, estimatedBytesTotal:uint = 0):void
    {
        addItem(id, getLoaderItemFactory().createItem(request), estimatedBytesTotal);
    }


    public function get active():Boolean
    {
        return _active;
    }

    public function set active(new_active:Boolean):void
    {
        if (_active !== new_active)
        {
            _active = new_active;
            if (_active) fillQueue();
        }
    }

    public function stop():void
    {
        active = false;
        // TODO: stop open loads and move them back into queue
    }

    /**
     * Returns items in an error state to the queue.
     */
    public function retryErrors():void
    {
        for each (var item:BatchLoaderItem in getItemsByState(ItemState.ERROR))
        {
            getMetadata(item).reset();
            requeueItem(item);
        }
        fillQueue();
    }

    /**
     * Creates an advance estimation, which records that the given id will
     * load in future with the specified estimated size.  This is intended
     * to facilitate a progress UI when the caller knows a load will be
     * required but isn't ready to add a BatchLoaderItem.
     */
    public function estimate(id:String, estimatedBytes:uint):void
    {
        idToEstimation[id] = estimatedBytes;
        fillQueue();
    }

    /**
     * Remove all advance estimations.
     */
    public function clearEstimations():void
    {
        idToEstimation = { };
        fillQueue();
    }

    /**
     * Sets the current loading progress as the zero point.
     */
    public function zero():void
    {
        var loaded:Number = 0;

        for each (var metadata:ItemMetadata in itemToMetadataLookup)
        {
            loaded += metadata.weightedBytesLoaded;
        }

        if (isNaN(loaded))
        {
            zeroPoint = 0;
        }
        else
        {
            zeroPoint = loaded;
        }
    }

    /**
     * Once the queue's total size is known, set the loading progress as the
     * zero point. This can be used to ensure UI elements that report progress
     * start from 0.
     */
    public function zeroWhenTotalKnown():void
    {
        _zeroWhenTotalKnown = true;
    }

    private function fillQueue():void
    {
        if (!_active) return;

        if (canFillQueue())
        {
            while (canFillQueue())
            {
                startItem(getNextItem());
            }
        }
        checkDispatchCompleteState();
    }

    private function checkDispatchCompleteState():void
    {
        if (isComplete && !_wasComplete)
        {
            dispatchEvent(new BatchLoaderEvent(BatchLoaderEvent.QUEUE_COMPLETE));
        }
        else if (!isComplete && _wasComplete)
        {
            dispatchEvent(new BatchLoaderEvent(BatchLoaderEvent.QUEUE_START));
        }
        _wasComplete = isComplete;
    }

    private function canFillQueue():Boolean
    {
        return waitingQueue.length > 0  &&  openCount < _concurrent;
    }


    private function startItem(item:BatchLoaderItem):void
    {
        try {
            getMetadata(item).state = ItemState.OPEN;
            listenItem(item);
            item.start();
        }
        catch (e:Error)
        {
            handleItemError(item, e);
        }
    }

    private function handleItemStart(item:BatchLoaderItem):void
    {
        dispatchItemEvent(BatchItemEvent.ITEM_LOAD_START, item);
        getMetadata(item).startHandled = true;
    }

    private function onItemProgress(event:ProgressEvent):void
    {
        var item:BatchLoaderItem = BatchLoaderItem(event.target);

        if (!getMetadata(item).startHandled)
        {
            handleItemStart(item);
        }
        getMetadata(item).bytesLoaded = event.bytesLoaded;
        getMetadata(item).bytesTotal = event.bytesTotal;
        dispatchProgress();
    }

    private function handleItemComplete(item:BatchLoaderItem):void
    {
        if (!getMetadata(item).startHandled)
        {
            handleItemStart(item);
        }
        getMetadata(item).state = ItemState.COMPLETE;
        dispatchItemEvent(BatchItemEvent.ITEM_COMPLETE, item);
        dispatchProgress();
        fillQueue();
    }

    private function handleItemError(item:BatchLoaderItem, error:*):void
    {
        // TODO: check if it was critical
        getMetadata(item).state = ItemState.ERROR;
        dispatchItemErrorEvent(error, item);
        fillQueue();
    }

    private function dispatchItemEvent(type:String, item:BatchLoaderItem):void
    {
        dispatchEvent(new BatchItemEvent(type, getItemId(item), item));
    }

    private function dispatchItemErrorEvent(error:*, item:BatchLoaderItem):void
    {
        dispatchEvent(new BatchItemErrorEvent(BatchItemErrorEvent.ITEM_ERROR, error, getItemId(item), item));
    }

    private function onItemHttpStatus(event:HTTPStatusEvent):void
    {
        var item:BatchLoaderItem = BatchLoaderItem(event.target);
        var m:ItemMetadata = getMetadata(item);
        m.httpStatusHistory.push(event.status);
    }

    private function onItemOpen(event:Event):void
    {
        handleItemStart(BatchLoaderItem(event.target));
    }

    private function onItemComplete(event:Event):void
    {
        handleItemComplete(BatchLoaderItem(event.target));
    }

    private function onItemError(event:BatchItemErrorEvent):void
    {
        handleItemError(BatchLoaderItem(event.target), event.error);
    }

    private function dispatchProgress():void
    {
        if (_zeroWhenTotalKnown && isFinite(bytesTotal))
        {
            zero();
            _zeroWhenTotalKnown = false;
        }
        dispatchEvent(new BatchLoaderProgressEvent(
                BatchLoaderProgressEvent.BATCH_PROGRESS,
                bytesLoaded, bytesTotal, progress));
    }

    private function listenItem(item:BatchLoaderItem):void
    {
        item.addEventListener(ProgressEvent.PROGRESS, onItemProgress);
        item.addEventListener(HTTPStatusEvent.HTTP_STATUS, onItemHttpStatus);
        item.addEventListener(Event.COMPLETE, onItemComplete);
        item.addEventListener(Event.OPEN, onItemOpen);
        item.addEventListener(BatchItemErrorEvent.ITEM_ERROR, onItemError);
    }

    private function unlistenItem(item:BatchLoaderItem):void
    {
        item.removeEventListener(ProgressEvent.PROGRESS, onItemProgress);
        item.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onItemHttpStatus);
        item.removeEventListener(Event.COMPLETE, onItemComplete);
        item.removeEventListener(Event.OPEN, onItemOpen);
    }


    private function getMetadata(item:BatchLoaderItem):ItemMetadata
    {
        var meta:ItemMetadata = itemToMetadataLookup[item];
        assert(meta != null, "No metadata for item " + item);
        return meta;
    }


    private function getNextItem():BatchLoaderItem
    {
        return _order == BatchLoaderOrder.LIFO ? waitingQueue.pop() : waitingQueue.shift();
    }


    private function requeueItem(item:BatchLoaderItem):void
    {
        if (_order == BatchLoaderOrder.LIFO)
        {
            waitingQueue.push(item);
        }
        else
        {
            waitingQueue.unshift(item);
        }
    }


    private function countItemsByState(state:String):uint
    {
        var c:uint = 0;
        for each (var metadata:ItemMetadata in itemToMetadataLookup)
        {
            if (metadata.state == state) c++;
        }
        return c;
    }


    private function getItemsByState(state:String):Array
    {
        var items:Array = [ ];
        for each (var item:BatchLoaderItem in idToItemLookup)
        {
            if (getMetadata(item).state == state)
            {
                items.push(item);
            }
        }
        return items;
    }


    private function getLoaderItemFactory():BatchLoaderItemFactory
    {
        return loaderItemFactory || defaultLoaderItemFactory;
    }


    private static var _defaultLoaderItemFactory:BatchLoaderItemFactory;
    private static function get defaultLoaderItemFactory():BatchLoaderItemFactory
    {
        if (!_defaultLoaderItemFactory)
        {
            _defaultLoaderItemFactory = new DefaultItemFactory();
        }
        return _defaultLoaderItemFactory;
    }
}
}


class ItemState
{
    public static const WAITING:String = "waiting";
    public static const OPEN:String = "open";
    public static const COMPLETE:String = "complete";
    public static const ERROR:String = "error";
}


class ItemMetadata
{
    public var state:String;
    public var estimatedBytesTotal:uint;
    public var httpStatusHistory:Array;
    public var bytesLoaded:uint;
    public var bytesTotal:uint;

    public var startHandled:Boolean;

    public function ItemMetadata()
    {
        reset();
    }

    public function reset():void
    {
        state = ItemState.WAITING;
        httpStatusHistory = [ ];
    }

    public function get weightedBytesLoaded():Number
    {
        switch (state)
        {
        case ItemState.WAITING:
        case ItemState.ERROR:
            return 0;

        case ItemState.COMPLETE:
            return weightedBytesTotal;

        default:
            if (bytesLoaded == 0)
            {
                return 0;
            }
            else
            {
                return (bytesLoaded * weightedBytesTotal) / bytesTotal;
            }
        }
    }

    public function get weightedBytesTotal():Number
    {
        if (estimatedBytesTotal > 0)
        {
            return estimatedBytesTotal;
        }
        else if (bytesTotal > 0)
        {
            return bytesTotal;
        }
        else
        {
            return Number.NaN;
        }
    }
}
