package org.yellcorp.lib.net.batchloader.adapters
{
import flash.events.IEventDispatcher;


[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
[Event(name="open", type="flash.events.Event")]
[Event(name="progress", type="flash.events.ProgressEvent")]
[Event(name="complete", type="flash.events.Event")]
[Event(name="itemError", type="org.yellcorp.lib.net.batchloader.events.BatchItemErrorEvent")]
public interface BatchLoaderItem extends IEventDispatcher
{
    function start():void;
    function stop():void;
    function dispose():void;
}
}
