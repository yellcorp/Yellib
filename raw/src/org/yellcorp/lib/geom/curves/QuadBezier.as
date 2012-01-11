package org.yellcorp.lib.geom.curves
{
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;


public class QuadBezier
{
    public var p0:Point;
    public var p1:Point;
    public var p2:Point;

    public static function createFromPoints(point0:Point, point1:Point, point2:Point):QuadBezier
    {
        var b:QuadBezier = new QuadBezier();
        b.p0 = point0;  b.p1 = point1;  b.p2 = point2;
        return b;
    }

    public static function create():QuadBezier
    {
        return createFromPoints(new Point(), new Point(), new Point());
    }

    public static function createFromCoords(x0:Number, y0:Number,
                                            x1:Number, y1:Number,
                                            x2:Number, y2:Number):QuadBezier
    {
        return createFromPoints(new Point(x0, y0),
                                new Point(x1, y1),
                                new Point(x2, y2));
    }

    public static function createFromPointArray(array:*):QuadBezier
    {
        var b:QuadBezier = create();
        b.setPointArray(array);
        return b;
    }

    public static function createFromCoordArray(array:*):QuadBezier
    {
        var b:QuadBezier = create();
        b.setCoordArray(array);
        return b;
    }

    public function toString():String
    {
        return "[QuadBezier (" + p0.x + ", " + p0.y +
                        "), (" + p1.x + ", " + p1.y +
                        "), (" + p2.x + ", " + p2.y +
                        ")]";
    }

    public function clone():QuadBezier
    {
        return createFromPoints(p0.clone(), p1.clone(), p2.clone());
    }

    public function setPoints(point0:Point, point1:Point, point2:Point):void
    {
        p0 = point0;  p1 = point1;  p2 = point2;
    }

    public function setCoords(x0:Number, y0:Number,
                              x1:Number, y1:Number,
                              x2:Number, y2:Number):void
    {
        p0.x = x0;  p0.y = y0;  p1.x = x1;  p1.y = y1;  p2.x = x2;  p2.y = y2;
    }

    public function setPointArray(array:*):void
    {
        if (array.length != 3)
            throw new ArgumentError("Array must be of length 3");

        setCoords(array[0].x, array[0].y,
                  array[1].x, array[1].y,
                  array[2].x, array[2].y);
    }

    public function setCoordArray(array:*):void
    {
        if (array.length != 6)
            throw new ArgumentError("Array must be of length 6");

        setCoords(array[0], array[1],
                  array[2], array[3],
                  array[4], array[5]);
    }

    public function sample(t:Number, out:Point):Point
    {
        var u:Number = 1 - t;

        out.x = u * (p0.x * u + p1.x * t * 2) + p2.x * t * t;
        out.y = u * (p0.y * u + p1.y * t * 2) + p2.y * t * t;

        return out;
    }

    public function sampleX(t:Number):Number
    {
        var u:Number = 1 - t;
        return u * (p0.x * u + p1.x * t * 2) + p2.x * t * t;
    }

    public function sampleY(t:Number):Number
    {
        var u:Number = 1 - t;
        return u * (p0.y * u + p1.y * t * 2) + p2.y * t * t;
    }

    public function tangent(t:Number, out:Point):Point
    {
        var u:Number = 1 - t;
        out.x = 2 * ((p1.x - p0.x) * u + (p2.x - p1.x) * t);
        out.y = 2 * ((p1.y - p0.y) * u + (p2.y - p1.y) * t);
        return out;
    }

    public function split(t:Number, outLow:QuadBezier, outHigh:QuadBezier):void
    {
        splitLow(t, outLow);
        splitHigh(t, outHigh);
    }

    public function splitLow(t:Number, out:QuadBezier):QuadBezier
    {
        out.p0.x = p0.x;
        out.p0.y = p0.y;
        out.p1.x = p0.x + (p1.x - p0.x) * t;
        out.p1.y = p0.y + (p1.y - p0.y) * t;
        sample(t, out.p2);
        return out;
    }

    public function splitHigh(t:Number, out:QuadBezier):QuadBezier
    {
        sample(t, out.p0);
        out.p1.x = p1.x + (p2.x - p1.x) * t;
        out.p1.y = p1.y + (p2.y - p1.y) * t;
        out.p2.x = p2.x;
        out.p2.y = p2.y;
        return out;
    }

    public function boundingBox(out:Rectangle):Rectangle
    {
        var minX:Number = Math.min(p0.x, p2.x);
        var maxX:Number = Math.max(p0.x, p2.x);
        var minY:Number = Math.min(p0.y, p2.y);
        var maxY:Number = Math.max(p0.y, p2.y);

        var xtExtrema:Number = (p0.x - p1.x) / (p0.x - 2 * p1.x + p2.x);
        var ytExtrema:Number = (p0.y - p1.y) / (p0.y - 2 * p1.y + p2.y);

        var xExtrema:Number;
        var yExtrema:Number;

        if (xtExtrema > 0 && xtExtrema < 1)
        {
            xExtrema = sampleX(xtExtrema);
            minX = Math.min(minX, xExtrema);
            maxX = Math.max(maxX, xExtrema);
        }

        if (ytExtrema > 0 && ytExtrema < 1)
        {
            yExtrema = sampleY(ytExtrema);
            minY = Math.min(minY, yExtrema);
            maxY = Math.max(maxY, yExtrema);
        }

        out.x = minX;
        out.y = minY;
        out.width = maxX - minX;
        out.height = maxY - minY;

        return out;
    }

    public function draw(target:Graphics):void
    {
        target.moveTo(p0.x, p0.y);
        target.curveTo(p1.x, p1.y, p2.x, p2.y);
    }

    public function drawHull(target:Graphics):void
    {
        target.moveTo(p0.x, p0.y);
        target.lineTo(p1.x, p1.y);
        target.lineTo(p2.x, p2.y);
    }
}
}
