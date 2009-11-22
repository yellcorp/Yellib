package org.yellcorp.bmpcache
{
import org.yellcorp.map.MapUtil;
import org.yellcorp.map.MultiMap;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.utils.Dictionary;
import flash.utils.getTimer;


public class BitmapCache
{
    public var errorMaxSeconds:int;
    public var contentMaxSeconds:int;
    public var maxBitmapBytes:int;

    private var stateExpiry:Dictionary;
    private var waiting:MultiMap;
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

        stateExpiry = new Dictionary();
        waiting = new MultiMap();
        errorCache = new Dictionary();
        bitmapCache = new BitmapDictionary();
        accessTime = new Dictionary();

        infoToLoaderLookup = new Dictionary();
    }

    public function getToken(url:URLRequest):BitmapCacheToken
    {
        var id:String = CacheUtil.hashRequest(url);
        return new BitmapCacheToken(this, url, id, new Internal_ctor());
    }

    internal function startToken(token:BitmapCacheToken):void
    {
        var now:int;
        var expiry:int;
        var id:String = token.id;

        //trace("BitmapCache.startToken(token)");
        //trace('token.id: ' + (token.id));

        // if waiting (display) loader, add token to wait list
        if (waiting.hasList(id))
        {
            //trace('waiting');
            waiting.push(id, token);
            //trace('------------- return due to waiting');
            return;
        }

        now = getTimer();
        expiry = stateExpiry[id];
        //trace(Template.format('expiry set: now is {0}, expiry is {1}', [now, expiry]));

        if (now < expiry)
        {
            // check error entry
            if (errorCache[id] is ErrorEvent)
            {
                // if so, dispatch error on loader
                //trace(Template.format('cached error: {0}', [errorCache[id]]));
                //trace('dispatching error');
                token.dispatchEvent(ErrorEvent(errorCache[id]).clone());
                //trace('------------- return due to errorCache');
                return;
            }
            else if (bitmapCache.hasBitmap(id))
            {
                // set bitmap on token
                //trace('cached bitmap');
                //token.bitmapData = bitmapCache.getBitmap(id);
                touch(id);
                token.setBitmapData(bitmapCache.getBitmap(id));
                //trace('dispatching complete');
                token.dispatchEvent(new Event(Event.COMPLETE));
                //trace('------------- return due to bitmapCache');
                return;
            }

            // if we fall through to here, continue below, it means we
            // have an expiry time for an unknown state.
            //trace("BitmapCache.startToken: Expiry set for "+id+" but no error or cached bitmap");
            delete stateExpiry[id];
        }

        bitmapCache.deleteBitmap(id);
        delete errorCache[id];

        createLoader(token);
        //trace('------------- return due to creation of new request');
    }

    protected function postProcess(loader:Loader):BitmapData {
        return null;
    }

    protected final function defaultPostProcess(loader:Loader):BitmapData {
        var bitmap:BitmapData;

        bitmap = new BitmapData(loader.contentLoaderInfo.width, loader.contentLoaderInfo.height, true, 0x00000000);
        bitmap.draw(loader);

        return bitmap;
    }

    private function createLoader(token:BitmapCacheToken):void
    {
        //trace("BitmapCache.createLoader(token)");

        var newLoader:AnnotatedLoader = new AnnotatedLoader(token.id);
        //var context:LoaderContext = new LoaderContext(true, null, SecurityDomain.currentDomain);

        waiting.push(token.id, token);
        pushLoaderInfo(newLoader);
        listenLoader(newLoader);
        newLoader.load(token.url);
    }

    private function onLoaderComplete(event:Event):void
    {
        //trace("BitmapCache.onLoaderComplete(event)");

        var loader:AnnotatedLoader = popLoaderInfo(LoaderInfo(event.target));
        var id:String = loader.id;
        var now:int = getTimer();
        var token:BitmapCacheToken;
        var bitmap:BitmapData;

        unlistenLoader(loader);

        //trace('id: ' + (id));

        bitmap = postProcess(loader);
        if (!bitmap) bitmap = defaultPostProcess(loader);

        allocate(bitmap);

        touch(id);
        bitmapCache.setBitmap(id, bitmap);
        delete errorCache[id];
        stateExpiry[id] = now + contentMaxSeconds * 1000;

        for each (token in waiting.getList(id))
        {
            //trace('notifying waiting complete');
            //token.bitmapData = bitmap;
            token.setBitmapData(bitmap);
            token.dispatchEvent(event.clone());
        }

        //trace('deleting waiting');
        waiting.deleteList(id);
        //trace('waiting has id: '+waiting.hasList(id));
        //trace('------------- exit complete handler');
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
            // shift most recent to beginning of list
            // (descending order)
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
        //trace("BitmapCache.onLoaderError(event)");

        var loader:AnnotatedLoader = popLoaderInfo(LoaderInfo(event.target));
        var id:String = loader.id;
        var now:int = getTimer();
        var token:BitmapCacheToken;

        unlistenLoader(loader);

        //trace('id: ' + (id));

        bitmapCache.deleteBitmap(id);
        errorCache[id] = ErrorEvent(event);
        stateExpiry[id] = now + errorMaxSeconds * 1000;

        for each (token in waiting.getList(id))
        {
            //trace('notifying waiting error');
            token.dispatchEvent(event.clone());
        }

        waiting.deleteList(id);
        //trace('------------- exit error handler');
    }

    private function touch(id:String):void
    {
        accessTime[id] = getTimer();
    }

    // more stupid flash:
    // the simple getEventSource function commented out below won't work if
    // the Loader isn't successful.  instead the .loader getter
    // throws an error claiming that it's not sufficiently loaded
    // even though the .loader -> Loader relationship is fixed
    private function pushLoaderInfo(loader:AnnotatedLoader):void
    {
        infoToLoaderLookup[loader.contentLoaderInfo] = loader;
    }

    private function popLoaderInfo(loaderInfo:LoaderInfo):AnnotatedLoader
    {
        var result:AnnotatedLoader;

        result = infoToLoaderLookup[loaderInfo];
        delete infoToLoaderLookup[loaderInfo];

        return result;
    }

    /*
    private function getEventSource(info:LoaderInfo):AnnotatedLoader
    {
        // this throws a sandbox fit when being debugged, but that's
        // only because the debugger tries to evaluate getters which
        // the loaded object doesn't have appDomain/security access to

        // this can be ignored because we're only here to
        // get the .loader property

        return AnnotatedLoader(info.loader);
    }
*/

        private function listenLoader(a:AnnotatedLoader):void
        {
            a.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
            a.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
        }

        private function unlistenLoader(a:AnnotatedLoader):void
        {
            a.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);
            a.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
        }
    }
}
