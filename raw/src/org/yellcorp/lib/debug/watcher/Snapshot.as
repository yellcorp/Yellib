package org.yellcorp.lib.debug.watcher
{
import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.utils.Dictionary;


public class Snapshot
{
    private var order:Array;
    private var transforms:Dictionary;

    public function Snapshot()
    {
        order = [ ];
        transforms = new Dictionary(false);
    }

    public function prepend(display:DisplayObject):void
    {
        order.unshift(display);
        transforms[display] = display.transform.matrix.clone();
    }

    public function contains(display:DisplayObject):Boolean
    {
        return Boolean(transforms[display]);
    }

    public function getMatrix(display:DisplayObject):Matrix
    {
        return transforms[display];
    }

    public static function difference(s1:Snapshot, s2:Snapshot):Array
    {
        if (!s1) s1 = new Snapshot();
        if (!s2) s2 = new Snapshot();

        var i:int;
        var resultDiffs:Array = [ ];
        var diff:Difference;
        var display:DisplayObject;
        var indexLookup:Dictionary = makeIndexLookup(s1.order);

        for (i = 0; i < s1.order.length; i++)
        {
            display = s1.order[i];
            if (!s2.contains(display))
            {
                resultDiffs.push(
                    new Difference(
                        display,
                        null, -1,
                        s1.getMatrix(display), i));
            }
        }

        for (i = 0; i < s2.order.length; i++)
        {
            display = s2.order[i];
            diff = new Difference(display, s2.getMatrix(display), i);

            if (s1.contains(display))
            {
                diff.oldTransform = s1.getMatrix(display);
                diff.oldIndex = indexLookup[display];
                if (diff.type != Difference.NONE)
                {
                    resultDiffs.push(diff);
                }
            }
            else
            {
                resultDiffs.push(diff);
            }
        }

        return resultDiffs;
    }

    private static function makeIndexLookup(order:Array):Dictionary
    {
        var lookup:Dictionary = new Dictionary(true);

        for (var i:int = 0; i < order.length; i++)
        {
            lookup[order[i]] = i;
        }
        return lookup;
    }
}
}
