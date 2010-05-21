package org.yellcorp.net.multiloader
{
import org.yellcorp.mem.Destructor;
import org.yellcorp.net.multiloader.core.MultiLoaderItem;
import org.yellcorp.net.multiloader.core.ml_internal;
import org.yellcorp.net.multiloader.events.MultiLoaderErrorEvent;
import org.yellcorp.net.multiloader.events.MultiLoaderItemEvent;
import org.yellcorp.sequence.Set;

import flash.events.AsyncErrorEvent;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;
import flash.utils.Dictionary;


[Event(name="multiloaderError", type="org.yellcorp.net.multiloader.events.MultiLoaderErrorEvent")]
[Event(name="complete", type="flash.events.Event")]
[Event(name="progress", type="flash.events.ProgressEvent")]
public class MultiLoader extends EventDispatcher implements Destructor
{
    public var order:String;
    public var dispatchUnknownProgress:Boolean;

    private var _concurrent:int;
    private var _started:Boolean;

    private var idToItem:Object;
    private var itemToId:Dictionary;

    private var queue:Array;
    private var openItems:Set;
    private var completedItems:Set;
    private var errorItems:Set;

    public function MultiLoader(order:String = "fifo")
    {
        this.order = order;
        _concurrent = 1;
        queue = [ ];
        idToItem = { };
        itemToId = new Dictionary();
        openItems = new Set();
        completedItems = new Set();
        errorItems = new Set();
        super();
    }

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

    public function hasId(id:String):Boolean
    {
        return idToItem.hasOwnProperty(id);
    }

    public function hasItem(item:MultiLoaderItem):Boolean
    {
        return Boolean(itemToId[item]);
    }

    public function getItemById(id:String):MultiLoaderItem
    {
        return hasId(id) ? idToItem[id] : null;
    }

    public function getItemId(item:MultiLoaderItem):String
    {
        return hasItem(item) ? itemToId[item] : null;
    }

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
        queue.push(item);
        if (_started) fillQueue();
    }

    public function start():void
    {
        _started = true;
        fillQueue();
    }

    public function get started():Boolean
    {
        return _started;
    }

    public function get concurrent():uint
    {
        return _concurrent;
    }

    public function set concurrent(concurrent:uint):void
    {
        _concurrent = concurrent;
        if (_started) fillQueue();
    }

    public function get bytesLoaded():uint
    {
        var loaded:uint = 0;
        for each (var item:MultiLoaderItem in idToItem)
        {
            loaded += item.bytesLoaded;
        }
        return loaded;
    }

    public function get bytesTotal():uint
    {
        var total:uint = 0;
        if (queueCount > 0) return 0;
        for each (var item:MultiLoaderItem in idToItem)
        {
            if (item.bytesTotal == 0)
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

    public function get queueCount():int
    {
        return queue.length;
    }

    public function get openCount():int
    {
        return openItems.length;
    }

    public function get errorCount():int
    {
        return errorItems.length;
    }

    public function get complete():Boolean
    {
        return queueCount == 0 && openCount == 0 && errorCount == 0 && _started;
    }

    ml_internal function onComplete(item:MultiLoaderItem):void
    {
        openItems.remove(item);
        completedItems.add(item);
        dispatchEvent(new MultiLoaderItemEvent(MultiLoaderItemEvent.ITEM_COMPLETE, getItemId(item), item, false, false));
        fillQueue();
        if (complete)
        {
            dispatchComplete();
        }
        else
        {
            dispatchProgress();
        }
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
        dispatchEvent(new MultiLoaderErrorEvent(MultiLoaderErrorEvent.MULTILOADER_ERROR, getItemId(item), item, event));
        fillQueue();
    }

    private function dispatchComplete():void
    {
        dispatchEvent(new Event(Event.COMPLETE, false, false));
    }

    private function dispatchProgress():void
    {
        if (dispatchUnknownProgress || bytesTotalKnown)
        {
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
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
}
}