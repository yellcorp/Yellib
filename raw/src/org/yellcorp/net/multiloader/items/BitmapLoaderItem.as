package org.yellcorp.net.multiloader.items
{
import org.yellcorp.bitmap.BitmapLoader;
import org.yellcorp.net.multiloader.core.MultiLoaderItem;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;


public class BitmapLoaderItem extends MultiLoaderItem
{
    private var _loader:BitmapLoader;
    public var context:LoaderContext;
    public var transparent:Boolean;
    public var fillColor:uint;
    public var fitMethod:String;

    public function BitmapLoaderItem(
        request:URLRequest,
        context:LoaderContext = null,
        transparent:Boolean = true,
        fillColor:uint = 0xFFFFFFFF,
        fitMethod:String = "crop")
    {
        super(request);
        this.context = context;
        this.transparent = transparent;
        this.fillColor = fillColor;
        this.fitMethod = fitMethod;
    }

    public override function destroy():void
    {
        super.destroy();
        _loader.removeEventListener(Event.OPEN, onOpen);
        _loader.removeEventListener(Event.COMPLETE, onComplete);
        _loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        _loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        _loader.removeEventListener(IOErrorEvent.IO_ERROR, onAsyncError);
        _loader.destroy();
        _loader = null;
    }

    public override function get bytesLoaded():uint
    {
        return _loader ? _loader.bytesLoaded : 0;
    }

    public override function get bytesTotal():uint
    {
        return _loader ? _loader.bytesTotal : 0;
    }

    public override function get bytesTotalKnown():Boolean
    {
        return _loader ? _loader.bytesTotal > 0 : false;
    }

    protected override function startLoad():void
    {
        _loader = new BitmapLoader(transparent, fillColor, fitMethod);
        _loader.addEventListener(Event.OPEN, onOpen);
        _loader.addEventListener(Event.COMPLETE, onComplete);
        _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        _loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, onAsyncError);
        _loader.load(request, context);
    }

    public function get loader():BitmapLoader
    {
        return _loader;
    }

    public function getBitmapData():BitmapData
    {
        return _loader.getBitmapData();
    }
}
}
