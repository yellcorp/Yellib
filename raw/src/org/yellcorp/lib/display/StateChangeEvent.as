package org.yellcorp.lib.display
{
import flash.events.Event;


public class StateChangeEvent extends Event
{
    public static const STATE_CHANGE_START:String = "STATE_CHANGE_START";
    public static const STATE_CHANGE_END:String = "STATE_CHANGE_END";
    public static const STATE_CHANGE_CANCEL:String = "STATE_CHANGE_CANCEL";
    public static const STATE_NOT_FOUND:String = "STATE_NOT_FOUND";

    public var stateName:String;

    public function StateChangeEvent(type:String, stateName:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        this.stateName = stateName;
        super(type, bubbles, cancelable);
    }

    public override function clone():Event
    {
        return new StateChangeEvent(type, stateName, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("StateChangeEvent", "stateName", "bubbles", "cancelable");
    }
}
}
