package org.yellcorp.lib.net
{
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;


[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
[Event(name="ioError", type="flash.events.IOErrorEvent")]
[Event(name="progress", type="flash.events.ProgressEvent")]
[Event(name="complete", type="flash.events.Event")]
[Event(name="open", type="flash.events.Event")]
public class BitmapLoader extends EventDispatcher
{
    private var displayLoader:DisplayLoader;

    private var image:BitmapData;
    private var _width:int;
    private var _height:int;

    public function BitmapLoader(request:URLRequest = null, loaderContextFactory:LoaderContextFactory = null)
    {
        super();
        displayLoader = new DisplayLoader(null, loaderContextFactory);
        addListeners(displayLoader);
        if (request)
        {
            load(request);
        }
    }

    public function dispose():void
    {
        clear();
        removeListeners(displayLoader);
        displayLoader.dispose();
        displayLoader = null;
    }

    public function get loaderContextFactory():LoaderContextFactory
    {
        return displayLoader.loaderContextFactory;
    }

    public function get bytesLoaded():uint
    {
        return displayLoader.bytesLoaded;
    }

    public function get bytesTotal():uint
    {
        return displayLoader.bytesTotal;
    }

    public function get httpStatusHistory():Array
    {
        return displayLoader.httpStatusHistory;
    }

    public function get lastHttpStatus():int
    {
        return displayLoader.lastHttpStatus;
    }

    public function get width():int
    {
        return _width;
    }

    public function get height():int
    {
        return _height;
    }

    public function load(request:URLRequest):void
    {
        clear();
        displayLoader.load(request);
    }

    public function clear():void
    {
        close();
        setImage(null);
        _width = _height = -1;
    }

    public function close():void
    {
        displayLoader.close();
    }

    public function copyBitmapData():BitmapData
    {
        return image ? image.clone() : null;
    }

    private function onDisplayLoadComplete(event:Event):void
    {
        var renderedImage:BitmapData;

        var loader:Loader = displayLoader.removeDisplay();

        _width = loader.contentLoaderInfo.width;
        _height = loader.contentLoaderInfo.height;
        renderedImage = new BitmapData(_width, _height, true, 0);
        renderedImage.draw(loader);
        setImage(renderedImage);
        dispatchEvent(event);

        displayLoader.unload();
    }

    private function setImage(newImage:BitmapData):void
    {
        if (image) image.dispose();
        image = newImage;
    }

    private function addListeners(target:DisplayLoader):void
    {
        target.addEventListener(Event.OPEN, dispatchEvent);
        target.addEventListener(Event.COMPLETE, onDisplayLoadComplete);
        target.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
        target.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
        target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
        target.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
    }

    private function removeListeners(target:DisplayLoader):void
    {
        target.removeEventListener(Event.OPEN, dispatchEvent);
        target.removeEventListener(Event.COMPLETE, onDisplayLoadComplete);
        target.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent);
        target.removeEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
        target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
        target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
    }
}
}
