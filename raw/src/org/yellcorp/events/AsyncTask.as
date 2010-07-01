package org.yellcorp.events
{
import flash.events.Event;
import flash.events.IEventDispatcher;


public class AsyncTask
{
    private var dispatcher:IEventDispatcher;
    private var terminatingEvents:Array;
    private var otherEvents:Array;

    public function AsyncTask(dispatcher:IEventDispatcher, terminatingEvents:Array, otherEvents:Array = null)
    {
        this.dispatcher = dispatcher;
        this.terminatingEvents = terminatingEvents.slice();
        this.otherEvents = otherEvents ? otherEvents.slice() : [ ];
        listen();
    }

    private function listen():void
    {
        var i:int;
        for (i = 0;i < otherEvents.length; i += 2)
        {
            dispatcher.addEventListener(otherEvents[i], otherEvents[i + 1]);
        }
        for (i = 0;i < terminatingEvents.length; i += 2)
        {
            dispatcher.addEventListener(terminatingEvents[i], onTerminate);
        }
    }

    private function unlisten(event:Event):void
    {
        var i:int;
        var currentEventType:String;
        for (i = 0;i < otherEvents.length; i += 2)
        {
            dispatcher.removeEventListener(otherEvents[i], otherEvents[i + 1]);
        }
        for (i = 0;i < terminatingEvents.length; i += 2)
        {
            currentEventType = terminatingEvents[i];
            if (currentEventType == event.type)
            {
                terminatingEvents[i + 1](event);
            }
            dispatcher.removeEventListener(currentEventType, onTerminate);
        }
    }

    private function onTerminate(event:Event):void
    {
        unlisten(event);
        this.dispatcher = null;
        this.terminatingEvents = null;
        this.otherEvents = null;
    }
}
}
