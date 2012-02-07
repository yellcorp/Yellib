package org.yellcorp.lib.net.batchloader.adapters.base
{
import org.yellcorp.lib.error.AbstractCallError;
import org.yellcorp.lib.net.batchloader.events.BatchItemErrorEvent;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.utils.setTimeout;


[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
[Event(name="open", type="flash.events.Event")]
[Event(name="progress", type="flash.events.ProgressEvent")]
[Event(name="complete", type="flash.events.Event")]
[Event(name="itemError", type="org.yellcorp.lib.net.batchloader.events.BatchItemErrorEvent")]
public class BaseNetworkLoaderItem extends EventDispatcher
{
    protected var netLoader:IEventDispatcher;

    protected var loadOpen:Boolean;
    protected var loadCompleted:Boolean;

    public function BaseNetworkLoaderItem(netLoader:IEventDispatcher)
    {
        this.netLoader = netLoader;
        netLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
        netLoader.addEventListener(Event.OPEN, onOpen);
        netLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
        netLoader.addEventListener(Event.COMPLETE, onComplete);
        netLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
        netLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
    }

    public function dispose():void
    {
        netLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
        netLoader.removeEventListener(Event.OPEN, onOpen);
        netLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        netLoader.removeEventListener(Event.COMPLETE, onComplete);
        netLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
        netLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
        this.netLoader = null;
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
            try {
                load();
            }
            catch (e:Error)
            {
                handleError(e);
            }
        }
    }

    public function stop():void
    {
        if (loadOpen)
        {
            close();
            loadOpen = false;
        }
    }

    protected function load():void
    {
        throw new AbstractCallError();
    }

    protected function close():void
    {
        throw new AbstractCallError();
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
        handleError(event);
    }

    protected final function handleError(error:*):void
    {
        loadOpen = false;
        loadCompleted = false;
        dispatchEvent(new BatchItemErrorEvent(BatchItemErrorEvent.ITEM_ERROR, error));
    }
}
}
