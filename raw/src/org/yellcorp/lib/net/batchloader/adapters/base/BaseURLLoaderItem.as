package org.yellcorp.lib.net.batchloader.adapters.base
{
import org.yellcorp.lib.net.batchloader.adapters.BatchLoaderItem;
import org.yellcorp.lib.net.batchloader.events.BatchItemErrorEvent;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.setTimeout;


public class BaseURLLoaderItem extends EventDispatcher implements BatchLoaderItem
{
    protected var request:URLRequest;
    protected var urlLoader:URLLoader;

    protected var loadOpen:Boolean;
    protected var loadCompleted:Boolean;

    public function BaseURLLoaderItem(request:URLRequest, urlLoader:URLLoader = null)
    {
        this.urlLoader = urlLoader || new URLLoader();
        this.request = request;

        urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
        urlLoader.addEventListener(Event.OPEN, onOpen);
        urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
        urlLoader.addEventListener(Event.COMPLETE, onComplete);
        urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
        urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
    }

    public function start():void
    {
        if (loadCompleted)
        {
            setTimeout(onComplete, 1, null);
        }
        else if (!loadOpen)
        {
            loadOpen = true;
            urlLoader.load(request);
        }
    }

    public function stop():void
    {
        if (loadOpen)
        {
            urlLoader.close();
            loadOpen = false;
        }
    }

    public function dispose():void
    {
        urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
        urlLoader.removeEventListener(Event.OPEN, onOpen);
        urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        urlLoader.removeEventListener(Event.COMPLETE, onComplete);
        urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
        urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

        this.urlLoader = null;
        this.request = null;
    }

    public function get content():*
    {
        return urlLoader.data;
    }

    protected function onHttpStatus(event:HTTPStatusEvent):void
    {
        dispatchEvent(event);
    }

    protected function onOpen(event:Event):void
    {
        dispatchEvent(event);
    }

    protected function onProgress(event:ProgressEvent):void
    {
        dispatchEvent(event);
    }

    protected function onComplete(event:Event):void
    {
        loadOpen = false;
        loadCompleted = true;
        dispatchEvent(new Event(Event.COMPLETE));
    }

    protected function onError(event:ErrorEvent):void
    {
        loadOpen = false;
        loadCompleted = false;
        dispatchEvent(new BatchItemErrorEvent(BatchItemErrorEvent.ITEM_ERROR, null, event));
    }
}
}
