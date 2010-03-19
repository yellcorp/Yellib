package org.yellcorp.geom
{
import flash.display.DisplayObject;
import flash.geom.Point;


public class TransformUtil
{
    public static function convertPoint(pointInFromSpace:Point, fromSpace:DisplayObject, toSpace:DisplayObject):Point
    {
        var global:Point = fromSpace.localToGlobal(pointInFromSpace);
        return toSpace.globalToLocal(global);
    }
}
}
