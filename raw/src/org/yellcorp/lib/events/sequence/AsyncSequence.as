package org.yellcorp.lib.events.sequence
{
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.EventDispatcher;


[Event(name="complete", type="flash.events.Event")]
[Event(name="sequenceError", type="org.yellcorp.lib.events.sequence.SequenceErrorEvent")]
public class AsyncSequence extends EventDispatcher
{
    private var sequence:Array;
    private var _currentIndex:int;
    private var _running:Boolean;
    private var onAllComplete:Function;
    private var onError:Function;

    public function AsyncSequence()
    {
        super();
        sequence = [];
        _currentIndex = 0;
    }

    public function run(onAllComplete:Function = null, onError:Function = null):void
    {
        checkNotRunning();

        this.onAllComplete = onAllComplete;
        this.onError = onError;

        _currentIndex = 0;
        _running = true;
        runCurrent();
    }

    public function push(item:EditableAsyncItem):void
    {
        checkNotRunning();
        item.owner = this;
        sequence.push(item);
    }

    public function get currentIndex():int
    {
        return _currentIndex;
    }

    public function get length():int
    {
        return sequence.length;
    }

    public function get running():Boolean
    {
        return _running;
    }

    internal function next():void
    {
        _currentIndex++;
        runCurrent();
    }

    internal function error(event:Event):void
    {
        var errorEvent:SequenceErrorEvent =
            new SequenceErrorEvent(SequenceErrorEvent.SEQUENCE_ERROR,
                    event, _currentIndex);

        dispatchEvent(errorEvent);
        if (onError != null)
        {
            callWithOptionalArgument(onError, errorEvent);
        }
    }

    private function runCurrent():void
    {
        var item:AsyncItem;

        if (_currentIndex >= sequence.length)
        {
            complete();
        }
        else
        {
            item = sequence[_currentIndex];
            item.run();
        }
    }

    private function complete():void
    {
        var completeEvent:Event = new Event(Event.COMPLETE);
        dispatchEvent(new Event(Event.COMPLETE));
        if (onAllComplete != null)
        {
            callWithOptionalArgument(onAllComplete, completeEvent);
        }
    }

    private function checkNotRunning():void
    {
        if (_running)
        {
            throw new IllegalOperationError("Method not allowed after run() has been called");
        }
    }

    private static function callWithOptionalArgument(func:Function, arg:*):void
    {
        if (func.length >= 1)
        {
            func(arg);
        }
        else
        {
            func();
        }
    }
}
}
