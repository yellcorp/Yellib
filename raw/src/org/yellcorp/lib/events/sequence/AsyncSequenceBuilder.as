package org.yellcorp.lib.events.sequence
{
import flash.events.IEventDispatcher;


public class AsyncSequenceBuilder
{
    private var sequence:AsyncSequence;
    private var currentItem:EditableAsyncItem;

    public function AsyncSequenceBuilder()
    {
        sequence = new AsyncSequence();
    }

    public function add(target:IEventDispatcher):AsyncSequenceBuilder
    {
        if (currentItem)
        {
            sequence.push(currentItem);
        }
        currentItem = new EditableAsyncItem();
        currentItem.target = target;
        return this;
    }

    public function startedBy(startFunction:Function, startArgs:Array = null):AsyncSequenceBuilder
    {
        currentItem.startFunction = startFunction;
        currentItem.startArgs = startArgs;
        return this;
    }

    public function continueOn(continueEventName:String, ifReturnsTrue:Function = null):AsyncSequenceBuilder
    {
        currentItem.continueEventName = continueEventName;
        currentItem.ifReturnsTrue = ifReturnsTrue;
        return this;
    }

    public function errorOn(errorEventNames:Array):AsyncSequenceBuilder
    {
        currentItem.errorEventNames = errorEventNames.slice();
        return this;
    }

    public function addEventListener(type:String, listener:Function,
        useCapture:Boolean = false, priority:int = 0,
        useWeakReference:Boolean = false):AsyncSequenceBuilder
    {
        currentItem.addEventListener(type, listener, useCapture, priority, useWeakReference);
        return this;
    }

    public function create():AsyncSequence
    {
        var result:AsyncSequence = sequence;
        sequence = new AsyncSequence();
        return result;
    }
}
}


/*
import flash.events.Event;
import flash.events.IOErrorEvent;


AsyncSequenceBuilder.
    add(loader.contentLoaderInfo).
        startedBy(loader.load).
        continueOn(Event.COMPLETE).
        cancelOn(IOErrorEvent.IO_ERROR).
        addEventListener(blah).
     add(urlLoader).
         startedBy(urlLoader.load).
     create();
 */
