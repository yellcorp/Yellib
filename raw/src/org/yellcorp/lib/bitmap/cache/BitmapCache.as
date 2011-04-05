package org.yellcorp.lib.bitmap.cache
{
import org.yellcorp.lib.core.MapUtil;
import org.yellcorp.lib.core.MultiMap;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.utils.Dictionary;
import flash.utils.getTimer;


public class BitmapCache
{
    public var errorMaxSeconds:int;
    public var contentMaxSeconds:int;
    public var maxBitmapBytes:int;

    private var loaderIds:Dictionary;
    private var idExpiryTime:Dictionary;
    private var waitingIds:MultiMap;
    private var errorCache:Dictionary;
    private var bitmapCache:BitmapDictionary;
    private var accessTime:Dictionary;

    private var infoToLoaderLookup:Dictionary;

    public function BitmapCache(errorMaxSeconds:int = 60,    // 1 min
                                contentMaxSeconds:int = 10800, // 3 hours
                                maxBitmapBytes:int = 0x300000) // 3 MB
    {
        this.errorMaxSeconds = errorMaxSeconds;
        this.contentMaxSeconds = contentMaxSeconds;
        this.maxBitmapBytes = maxBitmapBytes;

        loaderIds = new Dictionary();
        idExpiryTime = new Dictionary();
        waitingIds = new MultiMap();

        errorCache = new Dictionary();
        bitmapCache = new BitmapDictionary();

        accessTime = new Dictionary();

        infoToLoaderLookup = new Dictionary();
    }

    public function getHandle(url:URLRequest, context:LoaderContext = null):BitmapLoaderHandle
    {
        var id:String = CacheUtil.hashRequest(url);
        return new BitmapLoaderHandle(this, url, context, id, new Internal_ctor());
    }

    internal function startHandle(handle:BitmapLoaderHandle):void
    {
        var now:int;
        var expiry:int;
        var id:String = handle.id;

        // if waiting (display) loader, add handle to wait list
        if (waitingIds.hasList(id))
        {
            waitingIds.push(id, handle);
            return;
        }

        now = getTimer();
        expiry = idExpiryTime[id];

        if (now < expiry)
        {
            // check error entry
            if (errorCache[id] is ErrorEvent)
            {
                // if so, dispatch error on loader
                handle.dispatchEvent(ErrorEvent(errorCache[id]));
                return;
            }
            else if (bitmapCache.hasBitmap(id))
            {
                // set bitmap on handle
                touch(id);
                handle.setBitmapData(bitmapCache.getBitmap(id));
                handle.dispatchEvent(new Event(Event.COMPLETE));
                return;
            }

            // if we fall through to here, continue below, it means we
            // have an expiry time for an unknown state.
            //trace("BitmapCache.startHandle: Expiry set for "+id+" but no error or cached bitmap");
            delete idExpiryTime[id];
        }

        bitmapCache.deleteBitmap(id);
        delete errorCache[id];

        createLoader(handle);
    }

    protected function postProcess(loader:Loader):BitmapData
    {
        return null;
    }

    protected final function defaultPostProcess(loader:Loader):BitmapData
    {
        var bitmap:BitmapData;

        bitmap = new BitmapData(loader.contentLoaderInfo.width, loader.contentLoaderInfo.height, true, 0x00000000);
        bitmap.draw(loader);

        return bitmap;
    }

    private function createLoader(handle:BitmapLoaderHandle):void
    {
        var newLoader:Loader = new Loader(handle.id);
        setLoaderId(newLoader, handle.id);
        //var context:LoaderContext = new LoaderContext(true, null, SecurityDomain.currentDomain);

        waitingIds.push(handle.id, handle);
        pushLoaderInfo(newLoader);
        listenLoader(newLoader);
        newLoader.load(handle.url, handle.context);
    }

    private function onLoaderComplete(event:Event):void
    {
        //trace("BitmapCache.onLoaderComplete(event)");

        var loader:Loader = popLoaderInfo(LoaderInfo(event.target));
        var id:String = getLoaderId(loader);
        var now:int = getTimer();
        var handle:BitmapLoaderHandle;
        var bitmap:BitmapData;

        unlistenLoader(loader);

        //trace('id: ' + (id));

        bitmap = postProcess(loader);
        if (!bitmap) bitmap = defaultPostProcess(loader);

        allocate(bitmap);
        touch(id);

        bitmapCache.setBitmap(id, bitmap);
        delete errorCache[id];
        idExpiryTime[id] = now + contentMaxSeconds * 1000;

        for each (handle in waitingIds.getList(id))
        {
            //trace('notifying waiting complete');
            handle.setBitmapData(bitmap);
            handle.dispatchEvent(event.clone());
        }
        waitingIds.deleteList(id);
        clearLoaderId(loader);
    }

    private function allocate(bitmap:BitmapData):void
    {
        // not perfect: without some manual reference counting
        // or something there's no way to tell if any Bitmap
        // objects are using the cached BitmapData objects that
        // are being deleted here.

        var orderedTimes:Array;
        var maxCacheSize:int = maxBitmapBytes - CacheUtil.bitmapSize(bitmap);
        var i:int;

        if (bitmapCache.size > maxCacheSize)
        {
            i = 0;
            orderedTimes = MapUtil.mapToArray(accessTime);
            orderedTimes.sort(cmpNumberValue);
            while (bitmapCache.size > maxCacheSize && i < orderedTimes.length)
            {
                bitmapCache.deleteBitmap(orderedTimes[i++][0]);
            }
        }
    }

    private function cmpNumberValue(a:Array, b:Array):int
    {
        if (a[1] > b[1])
        {
            return -1;
        }
        else if (a[1] < b[1])
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }

    private function onLoaderError(event:ErrorEvent):void
    {
        var loader:Loader = popLoaderInfo(LoaderInfo(event.target));
        var id:String = getLoaderId(loader);
        var now:int = getTimer();
        var handle:BitmapLoaderHandle;

        unlistenLoader(loader);

        bitmapCache.deleteBitmap(id);
        errorCache[id] = ErrorEvent(event);
        idExpiryTime[id] = now + errorMaxSeconds * 1000;

        for each (handle in waitingIds.getList(id))
        {
            handle.dispatchEvent(event.clone());
        }

        waitingIds.deleteList(id);
        clearLoaderId(loader);
    }

    private function touch(id:String):void
    {
        accessTime[id] = getTimer();
    }

    // a lookup is necessary because LoaderInfo.get loader() sometimes throws
    // and error
    private function pushLoaderInfo(loader:Loader):void
    {
        infoToLoaderLookup[loader.contentLoaderInfo] = loader;
    }

    private function popLoaderInfo(loaderInfo:LoaderInfo):Loader
    {
        var result:Loader;

        result = infoToLoaderLookup[loaderInfo];
        delete infoToLoaderLookup[loaderInfo];

        return result;
    }

    private function listenLoader(loader:Loader):void
    {
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
    }

    private function unlistenLoader(loader:Loader):void
    {
        loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);
        loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
    }

    private function setLoaderId(loader:Loader, id:String):void
    {
        loaderIds[loader] = id;
    }

    private function getLoaderId(loader:Loader):String
    {
        return loaderIds[loader];
    }

    private function clearLoaderId(loader:Loader):Boolean
    {
        return delete loaderIds[loader];
    }
}
}
