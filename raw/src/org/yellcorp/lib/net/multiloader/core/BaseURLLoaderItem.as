package org.yellcorp.lib.net.multiloader.core
{
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;


public class BaseURLLoaderItem extends MultiLoaderItem
{
    protected var dataFormat:String;
    protected var urlLoader:URLLoader;

    public function BaseURLLoaderItem(request:URLRequest, newDataFormat:String)
    {
        super(request);
        dataFormat = newDataFormat;
    }

    public override function get bytesLoaded():uint
    {
        return urlLoader ? urlLoader.bytesLoaded : 0;
    }

    public override function get bytesTotal():uint
    {
        return urlLoader ? urlLoader.bytesTotal : 0;
    }

    public override function get bytesTotalKnown():Boolean
    {
        return urlLoader ? urlLoader.bytesTotal > 0 : false;
    }

    public override function dispose():void
    {
        removeListeners(urlLoader);
        urlLoader.close();
        urlLoader = null;
        super.dispose();
    }

    protected override function startLoad():void
    {
        urlLoader = createLoader();
        addListeners(urlLoader);
        urlLoader.dataFormat = dataFormat;
        urlLoader.load(request);
    }

    protected function addListeners(urlLoader:URLLoader):void
    {
        urlLoader.addEventListener(Event.OPEN, onOpen);
        urlLoader.addEventListener(Event.COMPLETE, onComplete);
        urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
        urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onAsyncError);
        urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onAsyncError);
    }

    protected function removeListeners(urlLoader:URLLoader):void
    {
        urlLoader.removeEventListener(Event.OPEN, onOpen);
        urlLoader.removeEventListener(Event.COMPLETE, onComplete);
        urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onAsyncError);
        urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onAsyncError);
    }

    protected function createLoader():URLLoader
    {
        return new URLLoader();
    }
}
}
