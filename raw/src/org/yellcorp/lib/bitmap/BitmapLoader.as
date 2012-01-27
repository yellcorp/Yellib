package org.yellcorp.lib.bitmap
{
import org.yellcorp.lib.net.LoaderContextFactory;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.LoaderContext;


[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
[Event(name="ioError", type="flash.events.IOErrorEvent")]
[Event(name="progress", type="flash.events.ProgressEvent")]
[Event(name="complete", type="flash.events.Event")]
[Event(name="open", type="flash.events.Event")]
public class BitmapLoader extends EventDispatcher
{
    public var loaderContextFactory:LoaderContextFactory;

    private var byteLoader:URLLoader;

    private var _currentRequest:URLRequest;
    private var _connectionOpen:Boolean;
    private var _httpStatusHistory:Array;
    private var imageDecoder:Loader;

    private var image:BitmapData;
    private var _width:int;
    private var _height:int;

    public function BitmapLoader(request:URLRequest = null, loaderContextFactory:LoaderContextFactory = null)
    {
        super();
        this.loaderContextFactory = loaderContextFactory;
        byteLoader = new URLLoader();
        byteLoader.dataFormat = URLLoaderDataFormat.BINARY;
        addByteLoadListeners(byteLoader);
        if (request)
        {
            load(request);
        }
    }

    public function get bytesLoaded():uint
    {
        return byteLoader.bytesLoaded;
    }

    public function get bytesTotal():uint
    {
        return byteLoader.bytesTotal;
    }

    public function get httpStatusHistory():Array
    {
        return _httpStatusHistory;
    }

    public function get lastHttpStatus():int
    {
        return _httpStatusHistory[_httpStatusHistory.length - 1];
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
        _currentRequest = request;
        _connectionOpen = true;

        byteLoader.load(request);
    }

    public function dispose():void
    {
        clear();
        removeByteLoadListeners(byteLoader);
        byteLoader = null;
    }

    public function clear():void
    {
        close();
        _currentRequest = null;
        setImage(null);
        _httpStatusHistory = [ ];
        _width = _height = -1;
    }

    public function close():void
    {
        if (_connectionOpen)
        {
            byteLoader.close();
        }
        _connectionOpen = false;
    }

    public function copyBitmapData():BitmapData
    {
        return image ? image.clone() : null;
    }

    private function onByteLoadStatus(event:HTTPStatusEvent):void
    {
        _httpStatusHistory.push(event.status);
        dispatchEvent(event);
    }

    private function onByteLoadComplete(event:Event):void
    {
        _connectionOpen = false;

        imageDecoder = new Loader();
        var loaderContext:LoaderContext = createContext(_currentRequest);
        addImageDecodeListeners(imageDecoder);

        imageDecoder.loadBytes(byteLoader.data, loaderContext);
    }

    private function onByteLoadError(event:ErrorEvent):void
    {
        _connectionOpen = false;
        dispatchEvent(event);
    }

    private function onImageDecodeComplete(event:Event):void
    {
        var target:Loader = LoaderInfo(event.target).loader;
        var renderedImage:BitmapData;

        removeImageDecodeListeners(target);
        if (target === imageDecoder)
        {
            _width = target.contentLoaderInfo.width;
            _height = target.contentLoaderInfo.height;
            renderedImage = new BitmapData(_width, _height, true, 0);
            renderedImage.draw(target);
            setImage(renderedImage);
            dispatchEvent(event);
        }

        try {
            target['unloadAndStop']();
        }
        catch (re:ReferenceError)
        {
            target.unload();
        }
    }

    private function onImageDecodeError(event:IOErrorEvent):void
    {
        var target:Loader = LoaderInfo(event.target).loader;
        removeImageDecodeListeners(target);
        if (target === imageDecoder)
        {
            dispatchEvent(event);
        }
    }

    private function setImage(newImage:BitmapData):void
    {
        if (image) image.dispose();
        image = newImage;
    }

    private function createContext(forRequest:URLRequest):LoaderContext
    {
        return loaderContextFactory ? loaderContextFactory.createContext(forRequest) : null;
    }

    private function addByteLoadListeners(target:URLLoader):void
    {
        target.addEventListener(Event.OPEN, dispatchEvent);
        target.addEventListener(Event.COMPLETE, onByteLoadComplete);
        target.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
        target.addEventListener(IOErrorEvent.IO_ERROR, onByteLoadError);
        target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onByteLoadError);
        target.addEventListener(HTTPStatusEvent.HTTP_STATUS, onByteLoadStatus);
    }

    private function removeByteLoadListeners(target:URLLoader):void
    {
        target.removeEventListener(Event.OPEN, dispatchEvent);
        target.removeEventListener(Event.COMPLETE, onByteLoadComplete);
        target.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent);
        target.removeEventListener(IOErrorEvent.IO_ERROR, onByteLoadError);
        target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onByteLoadError);
        target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onByteLoadStatus);
    }

    private function addImageDecodeListeners(target:Loader):void
    {
        var cli:LoaderInfo = target.contentLoaderInfo;
        cli.addEventListener(Event.COMPLETE, onImageDecodeComplete);
        cli.addEventListener(IOErrorEvent.IO_ERROR, onImageDecodeError);
    }

    private function removeImageDecodeListeners(target:Loader):void
    {
        var cli:LoaderInfo = target.contentLoaderInfo;
        cli.addEventListener(Event.COMPLETE, onImageDecodeComplete);
        cli.addEventListener(IOErrorEvent.IO_ERROR, onImageDecodeError);
    }
}
}
