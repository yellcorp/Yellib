package org.yellcorp.lib.net.batchloader.adapters
{
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;


internal class CommonLoaderAdapter
{
    protected var callback:BatchLoaderCallback;

    protected var eventTarget:IEventDispatcher;

    public function CommonLoaderAdapter(eventTarget:IEventDispatcher)
    {
        this.eventTarget = eventTarget;
    }

    public function start(callback:BatchLoaderCallback):void
    {
        this.callback = callback;
        listen();
    }

    protected function listen():void
    {
        eventTarget.addEventListener(Event.COMPLETE, onComplete);
        eventTarget.addEventListener(IOErrorEvent.IO_ERROR, onError);
        eventTarget.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
        eventTarget.addEventListener(ProgressEvent.PROGRESS, onProgress);
        eventTarget.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
    }

    protected function unlisten():void
    {
        eventTarget.removeEventListener(Event.COMPLETE, onComplete);
        eventTarget.removeEventListener(IOErrorEvent.IO_ERROR, onError);
        eventTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
        eventTarget.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        eventTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
    }

    protected function onComplete(event:Event):void
    {
        callback.complete();
        callback = null;
        eventTarget = null;
    }

    protected function onError(event:ErrorEvent):void
    {
        callback.error(event);
        callback = null;
        eventTarget = null;
    }

    protected function onProgress(event:ProgressEvent):void
    {
        callback.progress(event.bytesLoaded, event.bytesTotal);
    }

    protected function onHttpStatus(event:HTTPStatusEvent):void
    {
        callback.httpStatus(event.status);
    }
}
}
