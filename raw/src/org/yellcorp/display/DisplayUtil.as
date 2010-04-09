package org.yellcorp.display
{
import flash.display.DisplayObject;
import flash.geom.Point;


public class DisplayUtil
{
    /**
     * Convenience method for getting a DisplayObject's location as a Point.
     *
     * @param dobj The DisplayObject to query.
     * @param out An optional Point variable to store the result in. This can
     *            be used to avoid calling the Point constructor.
     */
    public static function getDisplayObjectPoint(dobj:DisplayObject, out:Point = null):Point
    {
        if (!out)
        {
            out = new Point(dobj.x, dobj.y);
        }
        else
        {
            out.x = dobj.x;
            out.y = dobj.y;
        }
        return out;
    }

    public static function convertPoint(pointInFromSpace:Point, fromSpace:DisplayObject, toSpace:DisplayObject):Point
    {
        if (fromSpace === toSpace) return pointInFromSpace.clone();
        var global:Point = fromSpace.localToGlobal(pointInFromSpace);
        return toSpace.globalToLocal(global);
    }
}
}
