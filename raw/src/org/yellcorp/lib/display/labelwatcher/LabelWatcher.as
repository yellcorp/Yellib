package org.yellcorp.lib.display.labelwatcher
{
import org.yellcorp.lib.core.Disposable;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;


[Event(name="labelChanged", type="org.yellcorp.lib.display.labelwatcher.LabelWatchEvent")]
public class LabelWatcher extends EventDispatcher implements Disposable
{
    private var _target:MovieClip;
    private var lastLabel:String;

    public function LabelWatcher(target:MovieClip)
    {
        super();
        _target = target;
        if (_target.stage)
        {
            watch();
        }
        _target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        _target.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    public function dispose():void
    {
        _target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        _target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        unwatch();
        _target = null;
    }

    private function watch():void
    {
        lastLabel = _target.currentLabel;
        dispatchEvent(new LabelWatchEvent(LabelWatchEvent.LABEL_CHANGED, lastLabel));
        _target.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function unwatch():void
    {
        _target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(event:Event):void
    {
        if (lastLabel != _target.currentLabel)
        {
            lastLabel = _target.currentLabel;
            dispatchEvent(new LabelWatchEvent(LabelWatchEvent.LABEL_CHANGED, lastLabel));
        }
    }

    private function onAddedToStage(event:Event):void
    {
        watch();
    }

    private function onRemovedFromStage(event:Event):void
    {
        unwatch();
    }
}
}
