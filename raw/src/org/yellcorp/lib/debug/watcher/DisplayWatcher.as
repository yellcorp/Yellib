package org.yellcorp.lib.debug.watcher
{
import org.yellcorp.lib.core.Disposable;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Matrix;


[Event(name="displayChanged", type="org.yellcorp.lib.debug.watcher.DisplayChangeEvent")]
public class DisplayWatcher extends EventDispatcher implements Disposable
{
    private var _target:DisplayObject;
    private var lastSnapshot:Array;

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
        var snapshot:Array = captureSnapshot(_target);
        var diff:Array = calcSnapshotDiff(lastSnapshot, snapshot);

        if (diff.length > 0)
        {
            dispatchEvent(new DisplayChangeEvent(DisplayChangeEvent.DISPLAY_CHANGED, diff));
        }

        lastSnapshot = snapshot;
    }

    private static function captureSnapshot(target:DisplayObject):Array
    {
        var snapshot:Array = [ ];

        for (; target; target = target.parent)
        {
            snapshot.unshift(target.transform.matrix.clone());
            snapshot.unshift(target);
        }
        return snapshot;
    }

    private static function calcSnapshotDiff(before:Array, after:Array):Array
    {
        var i:int = 0;
        var j:int = 0;

        var diffs:Array = [];
        var index:int;

        if (!after)
        {
            return allChanged(before, Remove);
        }
        else if (!before)
        {
            return allChanged(after, Add);
        }
        else
        {
            while (i < before.length && j < after.length)
            {
                if (before[i] === after[j])
                {
                    if (!matricesEqual(before[i + 1], after[j + 1]))
                    {
                        diffs.push(new Change(after[i], before[i + 1], after[j + 1]));
                    }
                    i += 2;
                    j += 2;
                }
                else
                {
                    index = find(before, after[j], i);
                    if (index >= 0)
                    {
                        while (i < index)
                        {
                            // stuff in 'before' has been deleted
                            diffs.push(new Remove(before[i], before[i + 1]));
                            i += 2;
                        }
                    }
                    else
                    {
                        index = find(after, before[i], j);
                        if (index >= 0)
                        {
                            while (j < index)
                            {
                                // stuff in 'after' has been added
                                diffs.push(new Add(after[j], after[j + 1]));
                                j += 2;
                            }
                        }
                        else
                        {
                            break;
                        }
                    }
                }
            }

            for (; i < before.length; i += 2)
            {
                diffs.push(new Remove(before[i], before[i + 1]));
            }

            for (; j < after.length; j += 2)
            {
                diffs.push(new Add(after[j], after[j + 1]));
            }

            return diffs;
        }
    }

    private static function allChanged(snapshot:Array, resultClass:Class):Array
    {
        var a:Array = [];
        for (var i:int = 0; i < snapshot.length; i += 2)
        {
            a.push(new resultClass(snapshot[i], snapshot[i+1]));
        }
        return a;
    }

    private static function find(haystack:Array, needle:DisplayObject, start:int):int
    {
        for (var i:int = start; i < haystack.length; start += 2)
        {
            if (haystack[i] == needle)
            {
                return i;
            }
        }
        return -1;
    }

    private static function matricesEqual(m:Matrix, n:Matrix):Boolean
    {
        return m.a == n.a  &&
               m.b == n.b  &&
               m.c == n.c  &&
               m.d == n.d  &&
               m.tx== n.tx &&
               m.ty== n.ty;
    }
}
}
