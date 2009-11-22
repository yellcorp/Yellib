package org.yellcorp.events
{
import flash.events.IEventDispatcher;


public class EventUtil
{
    public static function massAddListeners(targetList:Array,
                                            eventList:Array,
                                            handler:Function,
                                            useCapture:Boolean = false,
                                            priority:int = 0,
                                            useWeakReference:Boolean = false):void
    {
        var target:IEventDispatcher;
        var eventType:String;

        for each (target in targetList)
        {
            for each (eventType in eventList)
            {
                target.addEventListener(eventType, handler, useCapture, priority, useWeakReference);
            }
        }
    }

    public static function massRemoveListeners(targetList:Array,
                                               eventList:Array,
                                               handler:Function,
                                               useCapture:Boolean = false):void
    {
        var target:IEventDispatcher;
        var eventType:String;

        for each (target in targetList)
        {
            for each (eventType in eventList)
            {
                target.removeEventListener(eventType, handler, useCapture);
            }
        }
    }
}
}
