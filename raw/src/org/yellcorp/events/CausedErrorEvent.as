package org.yellcorp.events
{
import flash.events.AsyncErrorEvent;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.TextEvent;


public class CausedErrorEvent extends ErrorEvent
{
    public var cause:Event;

    public function CausedErrorEvent(type:String, cause:*, bubbles:Boolean = false, cancelable:Boolean = false, text:String = null)
    {
        this.cause = coerceCause(cause);
        super(type, bubbles, cancelable, text || getText(cause));
    }

    public function getEventChain():Array
    {
        var chain:Array = [ this ];
        var currentEvent:Event = this;

        do {
            currentEvent = CausedErrorEvent(currentEvent).cause;
            if (currentEvent) chain.push(currentEvent);
        } while (currentEvent is CausedErrorEvent);

        return chain;
    }

    public override function clone():Event
    {
        return baseClone(CausedErrorEvent);
    }

    protected function baseClone(newClass:Class):Event
    {
        return new newClass(type, cause ? cause.clone() : cause, bubbles, cancelable, text);
    }

    public override function toString():String
    {
        return baseToString("WrappedErrorEvent");
    }

    protected function baseToString(className:String):String
    {
        return formatToString(className, "cause");
    }

    private static function coerceCause(cause:*):Event
    {
        if (!cause) return null;

        if (cause is Event)
        {
            return Event(cause).clone();
        }
        else if (cause is Error)
        {
            return wrapAsyncError(cause);
        }
        else
        {
            throw new ArgumentError("cause must be an Event or Error");
        }
    }

    private static function getText(cause:*):String
    {
        if (cause is TextEvent)
        {
            return TextEvent(cause).text;
        }
        else if (cause is Error)
        {
            return Error(cause).message;
        }
        else
        {
            return null;
        }
    }

    private static function wrapAsyncError(cause:Error):ErrorEvent
    {
        return new AsyncErrorEvent(AsyncErrorEvent.ASYNC_ERROR, false, false, cause.message, cause);
    }
}
}
