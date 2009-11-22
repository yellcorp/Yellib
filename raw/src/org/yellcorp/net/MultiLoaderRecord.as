package org.yellcorp.net
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;


[Event(name="complete", type="flash.events.Event")]
[Event(name="open", type="flash.events.Event")]
[Event(name="ioError", type="flash.events.IOErrorEvent")]
[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
[Event(name="progress", type="flash.events.ProgressEvent")]

public class MultiLoaderRecord extends EventDispatcher
{
    internal var id:String;
    internal var loader:URLLoader;
    internal var request:URLRequest;

    public function MultiLoaderRecord(initId:String, initLoader:URLLoader, initRequest:URLRequest)
    {
        super(null);

        id = initId;
        loader = initLoader;
        request = initRequest;

        loader.addEventListener(Event.COMPLETE, bubble);
        loader.addEventListener(Event.OPEN, bubble);
        loader.addEventListener(IOErrorEvent.IO_ERROR, bubble);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, bubble);
        loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, bubble);
        loader.addEventListener(ProgressEvent.PROGRESS, bubble);
    }

    public function destroy():void
    {
        loader.removeEventListener(Event.COMPLETE, bubble);
        loader.removeEventListener(Event.OPEN, bubble);
        loader.removeEventListener(IOErrorEvent.IO_ERROR, bubble);
        loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, bubble);
        loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, bubble);
        loader.removeEventListener(ProgressEvent.PROGRESS, bubble);

        id = null;
        loader = null;
        request = null;
    }

    private function bubble(event:Event):void
    {
        dispatchEvent(event.clone());
    }
}
}
