package org.yellcorp.lib.debug.watcher
{
import flash.events.Event;


public class DisplayChangeEvent extends Event
{
    public static const DISPLAY_CHANGED:String = "displayChanged";
    public var delta:Array;

    public function DisplayChangeEvent(type:String, result:Array, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        this.delta = result;
        super(type, bubbles, cancelable);
    }

    public override function clone():Event
    {
        return new DisplayChangeEvent(type, delta, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("DisplayChangeEvent", "type", "result");
    }
}
}
