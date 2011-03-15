package org.yellcorp.lib.net.multiloader.items
{
import org.yellcorp.lib.net.multiloader.core.MultiLoaderItem;

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;


public class DisplayLoaderItem extends MultiLoaderItem
{
    private var _loader:Loader;
    public var context:LoaderContext;

    public function DisplayLoaderItem(request:URLRequest, context:LoaderContext = null)
    {
        super(request);
        this.context = context;
    }

    public override function get bytesLoaded():uint
    {
        return (_loader && _loader.contentLoaderInfo) ? _loader.contentLoaderInfo.bytesLoaded : 0;
    }

    public override function get bytesTotal():uint
    {
        return (_loader && _loader.contentLoaderInfo) ? _loader.contentLoaderInfo.bytesTotal : 0;
    }

    public override function get bytesTotalKnown():Boolean
    {
        return (_loader && _loader.contentLoaderInfo) ? _loader.contentLoaderInfo.bytesTotal > 0 : false;
    }

    public override function dispose():void
    {
        super.dispose();
        try {
            _loader.close();
        }
        catch (err:Error)
        { }
        _loader.unload();
        var cli:LoaderInfo = _loader.contentLoaderInfo;
        cli.removeEventListener(Event.OPEN, onOpen);
        cli.removeEventListener(Event.COMPLETE, onComplete);
        cli.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        cli.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        cli.removeEventListener(IOErrorEvent.IO_ERROR, onAsyncError);
        _loader = null;
    }

    protected override function startLoad():void
    {
        _loader = new Loader();
        var cli:LoaderInfo = _loader.contentLoaderInfo;
        cli.addEventListener(Event.OPEN, onOpen);
        cli.addEventListener(Event.COMPLETE, onComplete);
        cli.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        cli.addEventListener(ProgressEvent.PROGRESS, onProgress);
        cli.addEventListener(IOErrorEvent.IO_ERROR, onAsyncError);
        _loader.load(request, context);
    }

    public function get loader():Loader
    {
        return _loader;
    }
}
}
