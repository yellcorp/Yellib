package org.yellcorp.lib.debug.watcher
{
import org.yellcorp.lib.core.Disposable;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;


[Event(name="displayChanged", type="org.yellcorp.lib.debug.watcher.DisplayChangeEvent")]
public class DisplayWatcher extends EventDispatcher implements Disposable
{
    private var _target:DisplayObject;
    private var lastSnapshot:Snapshot;

    public function DisplayWatcher(target:DisplayObject)
    {
        _target = target;
        super();
        target.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    public function get target():DisplayObject
    {
        return _target;
    }

    public function dispose():void
    {
        target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        _target = null;
    }

    private function onEnterFrame(event:Event):void
    {
        var snapshot:Snapshot = captureSnapshot(_target);
        var diff:Array = Snapshot.difference(lastSnapshot, snapshot);

        if (diff.length > 0)
        {
            dispatchEvent(new DisplayChangeEvent(DisplayChangeEvent.DISPLAY_CHANGED, diff));
        }
        lastSnapshot = snapshot;
    }

    private static function captureSnapshot(target:DisplayObject):Snapshot
    {
        var snapshot:Snapshot = new Snapshot();

        for (; target; target = target.parent)
        {
            snapshot.prepend(target);
        }
        return snapshot;
    }
}
}
