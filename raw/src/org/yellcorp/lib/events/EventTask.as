package org.yellcorp.lib.events
{
import org.yellcorp.lib.core.Set;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.IEventDispatcher;


public class EventTask
{
    private var target:IEventDispatcher;

    private var listeners:Array; // <ListenerDescriptor>
    private var terminatingEventTypes:Set;
    private var listened:Boolean;

    public function EventTask(target:IEventDispatcher)
    {
        this.target = target;
        listeners = [ ];
        terminatingEventTypes = new Set();
    }

    public function handleOnce(eventType:String, listener:Function,
        useCapture:Boolean = false, priority:int = 0):EventTask
    {
        if (listened)
            throw new IllegalOperationError("listen() must be the last method called");

        listeners.push(new ListenerDescriptor(eventType, listener, useCapture, priority));
        terminatingEventTypes.add(eventType);
        return this;
    }

    public function handle(eventType:String, listener:Function,
        useCapture:Boolean = false, priority:int = 0):EventTask
    {
        if (listened)
            throw new IllegalOperationError("listen() must be the last method called");

        listeners.push(new ListenerDescriptor(eventType, listener, useCapture, priority));
        return this;
    }

    public function listen():void
    {
        for each (var listener:ListenerDescriptor in listeners)
        {
            listener.addTo(target);
        }

        for each (var eventType:String in terminatingEventTypes)
        {
            target.addEventListener(eventType, onTerminate, false, int.MIN_VALUE);
        }
        listened = true;
    }

    public function unlisten():EventTask
    {
        for each (var listener:ListenerDescriptor in listeners)
        {
            listener.removeFrom(target);
        }

        for each (var eventType:String in terminatingEventTypes)
        {
            target.removeEventListener(eventType, onTerminate, false);
        }
        return this;
    }

    private function onTerminate(event:Event):void
    {
        if (listened)
        {
            unlisten();
            destroy();
        }
    }

    private function destroy():void
    {
        target = null;
        listeners = null;
        terminatingEventTypes = null;
    }
}
}

import flash.events.IEventDispatcher;


class ListenerDescriptor
{
    public var eventType:String;
    public var listener:Function;
    public var useCapture:Boolean;
    public var priority:int;

    public function ListenerDescriptor(eventType:String, listener:Function,
            useCapture:Boolean = false, priority:int = 0)
    {
        this.eventType = eventType;
        this.listener = listener;
        this.useCapture = useCapture;
        this.priority = priority;
    }

    public function addTo(target:IEventDispatcher):void
    {
        target.addEventListener(eventType, listener, useCapture, priority);
    }

    public function removeFrom(target:IEventDispatcher):void
    {
        target.removeEventListener(eventType, listener, useCapture);
    }
}
