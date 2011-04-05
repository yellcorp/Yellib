package org.yellcorp.lib.events.sequence
{
import flash.events.Event;


public class SequenceErrorEvent extends Event
{
    public static const SEQUENCE_ERROR:String = "sequenceError";

    private var _cause:Event;
    private var _index:int;

    public function SequenceErrorEvent(type:String, cause:Event, index:int, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        _cause = cause;
        _index = index;
    }

    public function get cause():Event
    {
        return _cause;
    }

    public function get index():int
    {
        return _index;
    }

    public override function clone():Event
    {
        return new SequenceErrorEvent(type, _cause, _index, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("SequenceErrorEvent", "type");
    }
}
}
