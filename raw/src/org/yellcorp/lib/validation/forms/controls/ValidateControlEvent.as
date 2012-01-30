package org.yellcorp.lib.validation.forms.controls
{
import flash.events.Event;


public class ValidateControlEvent extends Event
{
    public static const CHANGE_COMPLETE:String = "changeComplete";
    public static const CHANGE:String = "change";

    public function ValidateControlEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
    }

    public override function clone():Event
    {
        return new ValidateControlEvent(type, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("ValidateEvent", "type");
    }
}
}
