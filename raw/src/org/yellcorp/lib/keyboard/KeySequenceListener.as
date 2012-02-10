package org.yellcorp.lib.keyboard
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.KeyboardEvent;


[Event(name="cancel", type="flash.events.Event")]
[Event(name="complete", type="flash.events.Event")]
public class KeySequenceListener extends EventDispatcher
{
    private var _keySequence:String;
    private var _target:IEventDispatcher;
    private var nextIndex:int;

    public function KeySequenceListener(keySequence:String, target:IEventDispatcher = null)
    {
        this.keySequence = keySequence;
        this.target = target;
    }

    public function dispose():void
    {
        this.target = null;
    }

    public function reset():void
    {
        nextIndex = 0;
    }

    public function get keySequence():String
    {
        return _keySequence;
    }

    public function set keySequence(new_keySequence:String):void
    {
        _keySequence = new_keySequence;
        reset();
    }

    public function get target():IEventDispatcher
    {
        return _target;
    }

    public function set target(target:IEventDispatcher):void
    {
        if (_target) _target.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        _target = target;
        if (_target) _target.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        reset();
    }

    private function onKeyDown(event:KeyboardEvent):void
    {
        if (_keySequence === null) return;
        if (event.charCode == _keySequence.charCodeAt(nextIndex))
        {
            nextIndex++;
            if (nextIndex >= _keySequence.length)
            {
                reset();
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }
        else
        {
            reset();
            dispatchEvent(new Event(Event.CANCEL));
        }
    }
}
}
