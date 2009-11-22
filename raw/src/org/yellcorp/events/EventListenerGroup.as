package org.yellcorp.events
{
import flash.events.Event;
import flash.events.IEventDispatcher;


public class EventListenerGroup implements IEventDispatcher
{
    private var target:IEventDispatcher;
    private var listeners:Array;

    private var _enabled:Boolean;

    public function EventListenerGroup(target:IEventDispatcher, startEnabled:Boolean = true)
    {
        this.target = target;

        _enabled = startEnabled;

        listeners = [ ];
    }

    public function get enabled():Boolean
    {
        return _enabled;
    }

    public function set enabled(v:Boolean):void
    {
        var i:int;

        if (_enabled != v)
        {
            _enabled = v;
            if (v)
            {
                for (i = 0; i < listeners.length; i++)
                {
                    ListenerRecord(listeners[i]).applyTo(target);
                }
            }
            else
            {
                for (i = 0; i < listeners.length; i++)
                {
                    ListenerRecord(listeners[i]).removeFrom(target);
                }
            }
        }
    }

    public function clear():void
    {
        if (_enabled)
        {
            enabled = false;
            listeners = [ ];
            _enabled = true;
        }
        else
        {
            listeners = [ ];
        }
    }

    public function dispatchEvent(event:Event):Boolean
    {
        return target.dispatchEvent(event);
    }

    public function hasEventListener(type:String):Boolean
    {
        return target.hasEventListener(type);
    }

    public function willTrigger(type:String):Boolean
    {
        return target.willTrigger(type);
    }

    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
        var record:ListenerRecord;

        if (findRecord(type, listener, useCapture) < 0)
        {
            record = new ListenerRecord(type, listener, useCapture, priority, useWeakReference);
            listeners.push(record);

            if (_enabled)
            {
                record.applyTo(target);
            }
        }
        else
        {
            return;
        }
    }

    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {
        var index:int;
        var record:ListenerRecord;

        index = findRecord(type, listener, useCapture);

        if (index >= 0)
        {
            record = listeners[index];
            record.removeFrom(target);
            listeners.splice(index, 1);
        }
    }

    private function findRecord(type:String, listener:Function, useCapture:Boolean):int
    {
        var i:int;
        var record:ListenerRecord;

        for (i = 0; i < listeners.length; i++)
        {
            record = listeners[i];
            if (type === record.type &&
                listener === record.listener &&
                useCapture === record.useCapture)
            {
                return i;
            }
        }

        return -1;
    }
}
}

import flash.events.IEventDispatcher;


internal class ListenerRecord
{
    internal var type:String;
    internal var listener:Function;
    internal var useCapture:Boolean;
    internal var priority:int;
    internal var useWeakReference:Boolean;

    public function ListenerRecord(type:String, listener:Function, useCapture:Boolean, priority:int, useWeakReference:Boolean)
    {
        this.type = type;
        this.listener = listener;
        this.useCapture = useCapture;
        this.priority = priority;
        this.useWeakReference = useWeakReference;
    }

    public function applyTo(target:IEventDispatcher):void
    {
        trace("applyTo: " + toString());
        target.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public function removeFrom(target:IEventDispatcher):void
    {
        trace("removeFrom: " + toString());
        target.removeEventListener(type, listener, useCapture);
    }

    public function toString():String
    {
        return "[ListenerRecord type=" + type +
               " useCapture=" + useCapture +
               " priority=" + priority +
               " useWeakReference=" + useWeakReference +
               "]";
    }
}
