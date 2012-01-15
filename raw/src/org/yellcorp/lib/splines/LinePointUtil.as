package org.yellcorp.lib.splines
{
import flash.geom.Point;


public class LinePointUtil
{
    public static function lineParamClosestToPoint(p0:Point, p1:Point, q:Point):Number
    {
        var xDiff:Number = p1.x - p0.x;
        var yDiff:Number = p1.y - p0.y;

        return ((q.x - p0.x) * xDiff + (q.y - p0.y) * yDiff) / (xDiff * xDiff + yDiff * yDiff);
    }

    public static function linePointClosestToPoint(p0:Point, p1:Point, q:Point, out:Point):Point
    {
        var param:Number = lineParamClosestToPoint(p0, p1, q);
        out.x = p0.x + param * (p1.x - p0.x);
        out.y = p0.y + param * (p1.y - p0.y);
        return out;
    }

    public static function linePointDistanceSquared(p0:Point, p1:Point, q:Point):Number
    {
        var param:Number = lineParamClosestToPoint(p0, p1, q);
        var pqx:Number = p0.x + param * (p1.x - p0.x);
        var pqy:Number = p0.y + param * (p1.y - p0.y);

        var dx:Number = pqx - q.x;
        var dy:Number = pqy - q.y;

        return dx * dx + dy * dy;
    }

    public static function linePointDistance(p0:Point, p1:Point, q:Point):Number
    {
        return Math.sqrt(linePointDistanceSquared(p0, p1, q));
    }

    // like line* methods but clamps to the segment between p0 and p1, which
    // also allows meaningful values to be returned when p0 and p1 are
    // coincident
    public static function segmentPointClosestToPoint(p0:Point, p1:Point, q:Point, out:Point):Point
    {
        var param:Number;

        if (p0.x == p1.x && p0.y == p1.y)
        {
            out.x = p0.x;
            out.y = p0.y;
            return out;
        }

        param = lineParamClosestToPoint(p0, p1, q);

        if (param <= 0)
        {
            out.x = p0.x;
            out.y = p0.y;
        }
        else if (param >= 1)
        {
            out.x = p1.x;
            out.y = p1.y;
        }
        else
        {
            out.x = p0.x + param * (p1.x - p0.x);
            out.y = p0.y + param * (p1.y - p0.y);
        }
        return out;
    }

    public static function segmentPointDistanceSquared(p0:Point, p1:Point, q:Point):Number
    {
        var param:Number;
        var pqx:Number;
        var pqy:Number;

        var dx:Number;
        var dy:Number;

        if (p0.x == p1.x && p0.y == p1.y)
        {
            dx = q.x - p0.x;
            dy = q.y - p0.y;
        }
        else
        {
            param = lineParamClosestToPoint(p0, p1, q);

            if (param <= 0)
            {
                pqx = p0.x;
                pqy = p0.y;
            }
            else if (param >= 1)
            {
                pqx = p1.x;
                pqy = p1.y;
            }
            else
            {
                pqx = p0.x + param * (p1.x - p0.x);
                pqy = p0.y + param * (p1.y - p0.y);
            }

            dx = pqx - q.x;
            dy = pqy - q.y;
        }

        return dx * dx + dy * dy;
    }

    public static function segmentPointDistance(p0:Point, p1:Point, q:Point):Number
    {
        return Math.sqrt(segmentPointDistanceSquared(p0, p1, q));
    }
}
}
