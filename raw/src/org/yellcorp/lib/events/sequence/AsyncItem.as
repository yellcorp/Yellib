package org.yellcorp.lib.events.sequence
{
import flash.events.Event;
import flash.events.IEventDispatcher;


public class AsyncItem implements IEventDispatcher
{
    internal var owner:AsyncSequence;

    protected var _target:IEventDispatcher;
    protected var _startFunction:Function;
    protected var _startArgs:Array;
    protected var _continueEventName:String;
    protected var _ifReturnsTrue:Function;
    protected var _errorEventNames:Array;

    private var bubbleEvents:Object;
    private var captureEvents:Object;

    public function AsyncItem()
    {
        bubbleEvents = { };
        captureEvents = { };
    }

    public function run():void
    {
        listen();

        // TODO: try/catch that calls unlisten()?
        if (_startArgs && _startArgs.length > 0)
        {
            _startFunction.apply(null, _startArgs);
        }
        else
        {
            _startFunction();
        }
    }

    private function onContinue(event:Event):void
    {
        unlisten();
        if (_ifReturnsTrue == null || _ifReturnsTrue(event))
        {
            owner.next();
        }
        else
        {
            onCancel(event);
        }
    }

    private function onCancel(event:Event):void
    {
        unlisten();
        owner.cancel();
    }

    private function listen():void
    {
        _target.addEventListener(_continueEventName, onContinue);
        if (_errorEventNames)
        {
            for each (var cancelEvent:String in _errorEventNames)
            {
                _target.addEventListener(cancelEvent, onCancel);
            }
        }
    }

    private function unlisten():void
    {
        _target.removeEventListener(_continueEventName, onContinue);
        if (_errorEventNames)
        {
            for each (var cancelEvent:String in _errorEventNames)
            {
                _target.removeEventListener(cancelEvent, onCancel);
            }
        }

        removeExternalEvents(bubbleEvents, false);
        bubbleEvents = {};

        removeExternalEvents(captureEvents, true);
        captureEvents = {};
    }

    private function removeExternalEvents(events:Object, capture:Boolean):void
    {
        var listeners:Array;
        for (var event:String in events)
        {
            listeners = events[event];
            for each (var listener:Function in listeners)
            {
                _target.removeEventListener(event, listener, capture);
            }
        }
    }

    public function get target():IEventDispatcher
    {
        return _target;
    }

    public function get startFunction():Function
    {
        return _startFunction;
    }

    public function get startArgs():Array
    {
        return _startArgs;
    }

    public function get continueEventName():String
    {
        return _continueEventName;
    }

    public function get ifReturnsTrue():Function
    {
        return _ifReturnsTrue;
    }

    public function get errorEventNames():Array
    {
        return _errorEventNames;
    }

    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
        var record:Object = useCapture ? captureEvents : bubbleEvents;
        var handlerList:Array;

        handlerList = record[type];
        if (handlerList)
        {
            handlerList.push(listener);
        }
        else
        {
            record[type] = [ listener ];
        }
        _target.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {
        var record:Object = useCapture ? captureEvents : bubbleEvents;
        var handlerList:Array;
        var i:int;

        handlerList = record[type];
        if (handlerList)
        {
            i = handlerList.indexOf(listener);
            if (i >= 0)
            {
                handlerList.splice(i, 1);
            }
        }
        _target.removeEventListener(type, listener, useCapture);
    }

    public function dispatchEvent(event:Event):Boolean
    {
        return _target.dispatchEvent(event);
    }

    public function hasEventListener(type:String):Boolean
    {
        return _target.hasEventListener(type);
    }

    public function willTrigger(type:String):Boolean
    {
        return _target.willTrigger(type);
    }
}
}
