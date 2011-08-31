package org.yellcorp.lib.net.batchloader
{
import org.yellcorp.lib.core.MapUtil;
import org.yellcorp.lib.core.Set;
import org.yellcorp.lib.error.AssertError;
import org.yellcorp.lib.net.batchloader.adapters.BatchLoaderAdapter;
import org.yellcorp.lib.net.batchloader.events.BatchItemErrorEvent;
import org.yellcorp.lib.net.batchloader.events.BatchItemEvent;
import org.yellcorp.lib.net.batchloader.events.BatchLoaderEvent;
import org.yellcorp.lib.net.batchloader.events.BatchLoaderProgressEvent;
import org.yellcorp.lib.net.batchloader.priv.LoaderChannel;
import org.yellcorp.lib.net.batchloader.priv.LoaderMetadata;
import org.yellcorp.lib.net.batchloader.priv.LoaderState;
import org.yellcorp.lib.net.batchloader.priv.bl_internal;

import flash.events.EventDispatcher;
import flash.utils.Dictionary;


[Event(name="batchProgress", type="org.yellcorp.lib.net.batchloader.events.BatchLoaderProgressEvent")]
[Event(name="itemError",     type="org.yellcorp.lib.net.batchloader.events.BatchItemErrorEvent")]
[Event(name="itemComplete",  type="org.yellcorp.lib.net.batchloader.events.BatchItemEvent")]
[Event(name="itemLoadStart", type="org.yellcorp.lib.net.batchloader.events.BatchItemEvent")]
[Event(name="queueStart",    type="org.yellcorp.lib.net.batchloader.events.BatchLoaderEvent")]
[Event(name="queueEmpty",    type="org.yellcorp.lib.net.batchloader.events.BatchLoaderEvent")]
public class BatchLoader extends EventDispatcher
{
    private var _order:String;
    private var _concurrent:uint = 1;

    private var queue:Array;

    private var idToLoaderLookup:Object;
    private var loaderToIdLookup:Dictionary;
    private var loaderToMetadataLookup:Dictionary;

    private var openLoaders:Set;
    private var completedLoaders:Set;
    private var errorLoaders:Set;
    private var reservations:Object = [ ];

    private var zeroPoint:Number = 0;
    private var zeroOnNextProgressEvent:Boolean;

    private var _running:Boolean;
    private var queueEmptyDispatched:Boolean = true;


    public function BatchLoader(order:String = null)
    {
        super();

        this.order = order;

        idToLoaderLookup = { };
        loaderToIdLookup = new Dictionary(true);
        loaderToMetadataLookup = new Dictionary(true);

        openLoaders = new Set();
        completedLoaders = new Set();
        errorLoaders = new Set();

        queue = [ ];
    }


    public function dispose():void
    {
        // TODO: BatchLoader.dispose()
    }


    public function get order():String
    {
        return _order;
    }

    public function set order(new_order:String):void
    {
        if (!new_order)
        {
            new_order = BatchLoaderOrder.FIFO;
        }
        else if (new_order != BatchLoaderOrder.FIFO && new_order != BatchLoaderOrder.LIFO)
        {
            throw new ArgumentError("Invalid value for order: " + new_order);
        }

        if (_order !== new_order)
        {
            _order = new_order;
            shift();
        }
    }


    public function get concurrent():uint
    {
        return _concurrent;
    }

    public function set concurrent(concurrent:uint):void
    {
        _concurrent = concurrent;
        shift();
    }


    /**
     * The number of items waiting in the load queue.
     */
    public function get queueCount():uint
    {
        return queue.length;
    }


    /**
     * The number of items currently loading.
     */
    public function get openCount():uint
    {
        return openLoaders.length;
    }


    /**
     * The number of reserved ids.
     */
    public function get reserveCount():uint
    {
        return MapUtil.count(reservations);
    }


    /**
     * The number of unresolved loads. This is equal to
     * queueCount + openCount + reserveCount.
     */
    public function get unresolvedCount():uint
    {
        return queueCount + openCount + reserveCount;
    }


    /**
     * The number of items that have successfully completed loading.
     */
    public function get completeCount():uint
    {
        return completedLoaders.length;
    }


    /**
     * The number of items which have resulted in errors.
     */
    public function get errorCount():uint
    {
        return errorLoaders.length;
    }


    /**
     * The total number of bytes loaded since the BatchLoader was
     * instantiated.
     */
    public function get bytesLoaded():Number
    {
        var loaded:Number = 0;
        for each (var metadata:LoaderMetadata in loaderToMetadataLookup)
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
        for each (var metadata:LoaderMetadata in loaderToMetadataLookup)
        {
            if (metadata.bytesTotal > 0)
            {
                total += metadata.bytesTotal;
            }
            else
            {
                return Number.NaN;
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

        for each (var metadata:LoaderMetadata in loaderToMetadataLookup)
        {
            loaded += metadata.weightedBytesLoaded;
            total += metadata.weightedBytesTotal;
        }

        for each (var reserveSize:uint in reservations)
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
            return (loaded - zeroPoint) / (total - zeroPoint);
        }
    }


    /**
     * Whether the BatchLoader is processing its load queue.
     */
    public function get running():Boolean
    {
        return _running;
    }


    /**
     * Start processing the load queue.
     */
    public function run():void
    {
        _running = true;
        shift();
    }


    /**
     * Stop processing the load queue. This does not cancel current loads,
     * but does prevent subsequent ones from starting.
     */
    public function pause():void
    {
        _running = false;
    }


    /**
     * Determines whether the BatchLoader is managing a LoaderAdapter with
     * a given id.
     *
     * @param id The id to test.
     * @return <code>true</code> if there is an item with the specified id,
     *         <code>false</code> if not.
     */
    public function hasId(id:String):Boolean
    {
        return idToLoaderLookup.hasOwnProperty(id);
    }


    /**
     * Determines whether the BatchLoader is managing an instance of a
     * LoaderAdapter.
     *
     * @param item The instance to test.
     * @return <code>true</code> if the MultiLoader is managing
     *      <code>item</code>. <code>false</code> if not, or if
     *      <code>item</code> is <code>null</code> or
     *      <code>undefined</code>.
     */
    public function hasItem(loader:BatchLoaderAdapter):Boolean
    {
        if (loader)
        {
            return Boolean(loaderToIdLookup[loader]);
        }
        else
        {
            return false;
        }
    }


    /**
     * Returns a LoaderAdapter associated with a given id, if it exists.
     *
     * @param id The id of the item to return.
     * @return The item with the specified id, or <code>null</code> if there
     *      is no such item.
     */
    public function getItemById(id:String):BatchLoaderAdapter
    {
        return hasId(id) ? idToLoaderLookup[id] : null;
    }


    /**
     * Returns the id associated with a managed LoaderAdapter instance.
     *
     * @param item The item to identify.
     * @return The id by which the item is known, or <code>null</code> if
     *      the item is not present in the MultiLoader.
     */
    public function getLoaderId(loader:BatchLoaderAdapter):String
    {
        return hasItem(loader) ? loaderToIdLookup[loader] : null;
    }


    /**
     * Adds an item to the BatchLoader queue, and associates it with an id
     * for later retrieval.
     *
     * @param id A string id by which to associate the item.
     * @param loader The LoaderAdapter to add.
     * @throws ArgumentError if the specified id is already used.
     */
    public function addLoader(id:String, loader:BatchLoaderAdapter, estimatedBytesTotal:uint = 0):void
    {
        if (idToLoaderLookup.hasOwnProperty(id))
        {
            throw new ArgumentError("id already exists: " + id);
        }

        if (reservations.hasOwnProperty(id))
        {
            estimatedBytesTotal = reservations[id];
            delete reservations[id];
        }

        var metadata:LoaderMetadata = new LoaderMetadata();
        metadata.estimatedBytesTotal = estimatedBytesTotal;
        metadata.state = LoaderState.WAITING;

        idToLoaderLookup[id] = loader;
        loaderToIdLookup[loader] = id;
        loaderToMetadataLookup[loader] = metadata;

        queue.push(loader);
        shift();
    }


    /**
     * Creates an advance reservation, which records that the given id will
     * load in future with the specified estimated size.  This is intended
     * to facilitate a progress UI when the caller knows a load will be
     * required but isn't ready to add a LoaderAdapter.
     *
     * @param id A string id by which to associate the item.
     * @param loader The LoaderAdapter to add.
     * @throws ArgumentError if the specified id is already used.
     */
    public function reserve(id:String, estimatedBytes:uint):void
    {
        reservations[id] = estimatedBytes;
        shift();
    }


    public function zero():void
    {
        var loaded:Number = 0;

        for each (var metadata:LoaderMetadata in loaderToMetadataLookup)
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


    private function shift():void
    {
        if (!_running)
        {
            return;
        }

        if (!queueEmptyDispatched && unresolvedCount == 0)
        {
            queueEmptyDispatched = true;
            dispatchEvent(new BatchLoaderEvent(BatchLoaderEvent.QUEUE_EMPTY));
        }

        while (queue.length > 0 && openLoaders.length < _concurrent)
        {
            if (queueEmptyDispatched)
            {
                queueEmptyDispatched = false;
                dispatchEvent(new BatchLoaderEvent(BatchLoaderEvent.QUEUE_START));
            }
            startLoader(getNextItem());
        }
    }


    private function startLoader(loader:BatchLoaderAdapter):void
    {
        try {
            loader.start(new LoaderChannel(this, loader));
        }
        catch (e:Error)
        {
            getMetadata(loader).state = LoaderState.ERROR;
            errorLoaders.add(loader);
            dispatchEvent(new BatchItemErrorEvent(BatchItemErrorEvent.ITEM_ERROR, getLoaderId(loader), e));
            return;
        }

        getMetadata(loader).state = LoaderState.OPEN;
        openLoaders.add(loader);

        dispatchEvent(new BatchItemEvent(BatchItemEvent.ITEM_LOAD_START, getLoaderId(loader)));
    }


    private function dispatchProgress():void
    {
        if (zeroOnNextProgressEvent)
        {
            zero();
            zeroOnNextProgressEvent = false;
        }

        dispatchEvent(new BatchLoaderProgressEvent(
                BatchLoaderProgressEvent.BATCH_PROGRESS,
                bytesLoaded, bytesTotal, progress));
    }


    private function getMetadata(loader:BatchLoaderAdapter):LoaderMetadata
    {
        var meta:LoaderMetadata = loaderToMetadataLookup[loader];
        AssertError.assert(meta != null, "No metadata for loader " + loader);
        return meta;
    }


    private function getNextItem():BatchLoaderAdapter
    {
        return _order == BatchLoaderOrder.LIFO ? queue.pop() : queue.shift();
    }


    /**
     * @private
     */
    bl_internal function loaderComplete(loader:BatchLoaderAdapter):void
    {
        getMetadata(loader).state == LoaderState.COMPLETE;
        openLoaders.remove(loader);
        completedLoaders.add(loader);

        dispatchEvent(new BatchItemEvent(BatchItemEvent.ITEM_COMPLETE, getLoaderId(loader)));
        dispatchProgress();

        shift();
    }

    /**
     * @private
     */
    bl_internal function loaderStatus(loader:BatchLoaderAdapter, statusCode:int):void
    {
        getMetadata(loader).httpStatusHistory.push(statusCode);
    }


    /**
     * @private
     */
    bl_internal function loaderProgress(loader:BatchLoaderAdapter, bytesLoaded:uint, bytesTotal:uint):void
    {
        getMetadata(loader).bytesLoaded = bytesLoaded;
        getMetadata(loader).bytesTotal = bytesTotal;
        dispatchProgress();
    }


    /**
     * @private
     */
    bl_internal function loaderError(loader:BatchLoaderAdapter, error:*):void
    {
        getMetadata(loader).state == LoaderState.ERROR;
        openLoaders.remove(loader);
        errorLoaders.add(loader);

        dispatchEvent(new BatchItemErrorEvent(BatchItemErrorEvent.ITEM_ERROR, getLoaderId(loader), error));

        shift();
    }
}
}
