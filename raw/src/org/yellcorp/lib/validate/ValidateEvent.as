package org.yellcorp.lib.validate
{
import flash.events.Event;


public class ValidateEvent extends Event
{
    public static const ACCEPTED:String = "accepted";
    public static const REJECTED:String = "rejected";

    private var _control:*;
    private var _value:*;
    private var _message:String;
    private var _accepted:Boolean;

    public function ValidateEvent(type:String, control:*, value:*, message:String, accepted:Boolean, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        _control = control;
        _value = value;
        _message = message;
        _accepted = accepted;
    }

    public function get control():*
    {
        return _control;
    }

    public function get value():*
    {
        return _value;
    }

    public function get message():String
    {
        return _message;
    }

    public function get accepted():Boolean
    {
        return _accepted;
    }

    public override function clone():Event
    {
        return new ValidateEvent(type, control, value, message, accepted, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("ValidateEvent", "control", "value", "message", "accepted");
    }
}
}
