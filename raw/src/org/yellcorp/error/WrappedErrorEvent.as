package org.yellcorp.error
{
import flash.events.AsyncErrorEvent;
import flash.events.ErrorEvent;
import flash.events.Event;


public class WrappedErrorEvent extends ErrorEvent
{
    public var cause:ErrorEvent;

    public function WrappedErrorEvent(type:String, cause:*, bubbles:Boolean = false, cancelable:Boolean = false, text:String = null)
    {
        super(type, bubbles, cancelable, text);
        this.cause = coerceCause(cause);
        this.text = text === null ? this.cause.text : text;
    }

    public override function clone():Event
    {
        return baseClone(WrappedErrorEvent);
    }

    protected function baseClone(newClass:Class):Event
    {
        return new newClass(type, cause.clone(), bubbles, cancelable, text);
    }

    public override function toString():String
    {
        return baseToString("WrappedErrorEvent");
    }

    protected function baseToString(className:String):String
    {
        return formatToString(className, "cause");
    }

    private function coerceCause(cause:*):ErrorEvent
    {
        if (cause is ErrorEvent)
        {
            return cause;
        }
        else if (cause is Error)
        {
            return asyncError(cause);
        }
        else
        {
            throw new ArgumentError("cause must be an ErrorEvent or Error");
        }
    }

    private function asyncError(cause:Error):ErrorEvent
    {
        return new AsyncErrorEvent(AsyncErrorEvent.ASYNC_ERROR, false, false, cause.message, cause);
    }
}
}
