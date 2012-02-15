package org.yellcorp.lib.debug.console.richtext
{
import org.yellcorp.lib.error.AbstractCallError;

import flash.events.Event;
import flash.events.EventDispatcher;


public class TextBlock extends EventDispatcher
{
    public function TextBlock()
    {
        super();
    }

    public function getText():String
    {
        throw new AbstractCallError();
    }

    public function interact(data:Object):void
    {
    }

    protected function notifyChange():void
    {
        dispatchEvent(new Event(Event.CHANGE));
    }
}
}
