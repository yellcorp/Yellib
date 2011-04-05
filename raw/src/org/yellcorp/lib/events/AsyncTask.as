package org.yellcorp.lib.events
{
import org.yellcorp.lib.core.Set;

import flash.events.IEventDispatcher;


public class AsyncTask
{
    private var target:IEventDispatcher;
    private var terminatingHandlers:Array;
    private var terminatingEvents:Set;
    private var otherHandlers:Array;
    private var waiting:Boolean;

    public function AsyncTask(target:IEventDispatcher,
        terminatingHandlers:Array, otherHandlers:Array = null)
    {
        this.target = target;
        this.terminatingHandlers = terminatingHandlers;
        this.otherHandlers = otherHandlers;
        waiting = true;
        listen();
    }

    private function listen():void
    {
        var i:int;
        terminatingEvents = new Set();

        for (i = 0; i < terminatingHandlers.length; i += 2)
        {
            target.addEventListener(terminatingHandlers[i], terminatingHandlers[i + 1]);
            terminatingEvents.add(terminatingHandlers[i]);
        }
        if (otherHandlers)
        {
            for (i = 0; i < otherHandlers.length; i += 2)
            {
                target.addEventListener(otherHandlers[i], otherHandlers[i + 1]);
            }
        }
        for each (var event:String in terminatingEvents)
        {
            target.addEventListener(event, onTerminate, false, int.MIN_VALUE);
        }
    }

    private function unlisten():void
    {
        var i:int;

        for (i = 0; i < terminatingHandlers.length; i += 2)
        {
            target.removeEventListener(terminatingHandlers[i], terminatingHandlers[i + 1]);
        }
        if (otherHandlers)
        {
            for (i = 0; i < otherHandlers.length; i += 2)
            {
                target.removeEventListener(otherHandlers[i], otherHandlers[i + 1]);
            }
        }
        for each (var event:String in terminatingEvents)
        {
            target.removeEventListener(event, onTerminate, false);
        }
    }

    private function onTerminate(event:String):void
    {
        if (waiting)
        {
            waiting = false;
            unlisten();
            this.target = null;
            this.terminatingHandlers = null;
            this.otherHandlers = null;
            terminatingEvents = null;
        }
    }

    public static function listenOnce(target:IEventDispatcher,
        terminatingHandlers:Array, otherHandlers:Array = null):AsyncTask
    {
        return new AsyncTask(target, terminatingHandlers, otherHandlers);
    }
}
}
