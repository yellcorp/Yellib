package org.yellcorp.lib.debug.watcher
{
import flash.events.Event;


public class DisplayChangeEvent extends Event
{
    public static const DISPLAY_CHANGED:String = "displayChanged";
    public var result:Array;

    public function DisplayChangeEvent(type:String, result:Array, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        this.result = result;
        super(type, bubbles, cancelable);
    }

    public override function clone():Event
    {
        return new DisplayChangeEvent(type, result, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("DisplayChangeEvent", "type", "result");
    }
}
}
