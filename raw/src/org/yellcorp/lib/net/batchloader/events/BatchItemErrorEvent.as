package org.yellcorp.lib.net.batchloader.events
{
import flash.events.ErrorEvent;
import flash.events.Event;


public class BatchItemErrorEvent extends ErrorEvent
{
    public static const ITEM_ERROR:String = "itemError";

    private var _id:String;
    private var _error:*;

    public function BatchItemErrorEvent(type:String, id:String, error:*, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "")
    {
        super(type, bubbles, cancelable, text);
        _id = id;
        _error = error;
    }

    public override function clone():Event
    {
        return new BatchItemErrorEvent(type, _id, _error, bubbles, cancelable, text);
    }

    public override function toString():String
    {
        return formatToString("BatchItemErrorEvent", "type", "id", "error");
    }

    public function get id():String
    {
        return _id;
    }

    public function get error():*
    {
        return _error;
    }
}
}
