package org.yellcorp.lib.splines
{
import org.yellcorp.lib.splines.streams.GraphicsStream;

import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;


public class CubicBezier
{
    public var p0:Point;
    public var p1:Point;
    public var p2:Point;
    public var p3:Point;

    public static function createFromPoints(point0:Point, point1:Point, point2:Point, point3:Point):CubicBezier
    {
        var b:CubicBezier = new CubicBezier();
        b.p0 = point0;  b.p1 = point1;  b.p2 = point2;  b.p3 = point3;
        return b;
    }

    public static function create():CubicBezier
    {
        return createFromPoints(new Point(), new Point(), new Point(), new Point());
    }

    public static function createFromCoords(x0:Number, y0:Number,
                                            x1:Number, y1:Number,
                                            x2:Number, y2:Number,
                                            x3:Number, y3:Number):CubicBezier
    {
        return createFromPoints(new Point(x0, y0),
                                new Point(x1, y1),
                                new Point(x2, y2),
                                new Point(x3, y3));
    }

    public static function createFromPointArray(array:*):CubicBezier
    {
        var b:CubicBezier = create();
        b.setPointArray(array);
        return b;
    }

    public static function createFromCoordArray(array:*):CubicBezier
    {
        var b:CubicBezier = create();
        b.setCoordArray(array);
        return b;
    }

    public function toString():String
    {
        return "[CubicBezier (" + p0.x + ", " + p0.y +
                        "), (" + p1.x + ", " + p1.y +
                        "), (" + p2.x + ", " + p2.y +
                        "), (" + p3.x + ", " + p3.y +
                        ")]";
    }

    public function clone():CubicBezier
    {
        return createFromPoints(p0.clone(), p1.clone(), p2.clone(), p3.clone());
    }

    public function setPoints(point0:Point, point1:Point, point2:Point, point3:Point):void
    {
        p0 = point0;  p1 = point1;  p2 = point2;  p3 = point3;
    }

    public function setCoords(x0:Number, y0:Number,
                              x1:Number, y1:Number,
                              x2:Number, y2:Number,
                              x3:Number, y3:Number):void
    {
        p0.x = x0;  p0.y = y0;  p1.x = x1;  p1.y = y1;
        p2.x = x2;  p2.y = y2;  p3.x = x3;  p3.y = y3;
    }

    public function setPointArray(array:*):void
    {
        if (array.length != 4)
            throw new ArgumentError("Array must be of length 4");

        setCoords(array[0].x, array[0].y,
                  array[1].x, array[1].y,
                  array[2].x, array[2].y,
                  array[3].x, array[3].y);
    }

    public function setCoordArray(array:*):void
    {
        if (array.length != 8)
            throw new ArgumentError("Array must be of length 8");

        setCoords(array[0], array[1],
                  array[2], array[3],
                  array[4], array[5],
                  array[6], array[7]);
    }

    public function sample(t:Number, out:Point):Point
    {
        out.x = sampleX(t);
        out.y = sampleY(t);
        return out;
    }

    public function sampleX(t:Number):Number
    {
        return evaluate(p0.x, p1.x, p2.x, p3.x, t);
    }

    public function sampleY(t:Number):Number
    {
        return evaluate(p0.y, p1.y, p2.y, p3.y, t);
    }

    public function tangent(t:Number, out:Point):Point
    {
        out.x = 3 * (p1.x - p0.x +
                     t * (2 * (p0.x - 2 * p1.x + p2.x) +
                          t * (p3.x - p0.x + 3 * (p1.x - p2.x))));

        out.y = 3 * (p1.y - p0.y +
                     t * (2 * (p0.y - 2 * p1.y + p2.y) +
                          t * (p3.y - p0.y + 3 * (p1.y - p2.y))));

        return out;
    }

    public function split(t:Number, outLow:CubicBezier, outHigh:CubicBezier):void
    {
        var q0x:Number = p0.x + (p1.x - p0.x) * t;
        var q1x:Number = p1.x + (p2.x - p1.x) * t;
        var q2x:Number = p2.x + (p3.x - p2.x) * t;

        var r0x:Number = q0x + (q1x - q0x) * t;
        var r1x:Number = q1x + (q2x - q1x) * t;

        var sx:Number = r0x + (r1x - r0x) * t;

        var q0y:Number = p0.y + (p1.y - p0.y) * t;
        var q1y:Number = p1.y + (p2.y - p1.y) * t;
        var q2y:Number = p2.y + (p3.y - p2.y) * t;

        var r0y:Number = q0y + (q1y - q0y) * t;
        var r1y:Number = q1y + (q2y - q1y) * t;

        var sy:Number = r0y + (r1y - r0y) * t;

        if (outLow)
        {
            outLow.setCoords(
                p0.x, p0.y,
                q0x,  q0y,
                r0x,  r0y,
                sx,   sy);
        }

        if (outHigh)
        {
            outHigh.setCoords(
                sx,   sy,
                r1x,  r1y,
                q2x,  q2y,
                p3.x, p3.y);
        }
    }

    public function boundingBox(out:Rectangle):Rectangle
    {
        var xs:Array = [ p0.x, p3.x ];
        var ys:Array = [ p0.y, p3.y ];

        var xtExtrema:Array = [ ];
        var ytExtrema:Array = [ ];

        var t:Number;

        solve_dt(p0.x, p1.x, p2.x, p3.x, xtExtrema);
        solve_dt(p0.y, p1.y, p2.y, p3.y, ytExtrema);

        for each (t in xtExtrema)
        {
            if (t > 0 && t < 1)  xs.push(sampleX(t));
        }

        for each (t in ytExtrema)
        {
            if (t > 0 && t < 1)  ys.push(sampleY(t));
        }

        var minX:Number = Math.min.apply(null, xs);
        var maxX:Number = Math.max.apply(null, xs);
        var minY:Number = Math.min.apply(null, ys);
        var maxY:Number = Math.max.apply(null, ys);

        out.x = minX;
        out.y = minY;
        out.width = maxX - minX;
        out.height = maxY - minY;

        return out;
    }

    public function get flatnessSquared():Number
    {
        var d1:Number = LinePointUtil.segmentPointDistanceSquared(p0, p1, p3);
        var d2:Number = LinePointUtil.segmentPointDistanceSquared(p0, p2, p3);

        return d1 > d2 ? d1 : d2;
    }

    public function draw(target:Graphics, threshold:Number = 0.5):void
    {
        BezierFlatten.cubicToPolyQuad(this, threshold, new GraphicsStream(target));
    }

    public function drawHull(target:Graphics):void
    {
        target.moveTo(p0.x, p0.y);
        target.lineTo(p1.x, p1.y);
        target.lineTo(p2.x, p2.y);
        target.lineTo(p3.x, p3.y);
    }

    public static function evaluate(a:Number, b:Number, c:Number, d:Number, t:Number):Number
    {
        var p:Number = 3 * (b - a);
        var q:Number = 3 * (c - b) - p;
        var r:Number = d - a - p - q;
        return a + t * (p + t * (q + t * r));
    }

    public static function evaluate_dt(a:Number, b:Number, c:Number, d:Number, t:Number):Number
    {
        var p:Number = 3 * (b - a);
        var q:Number = 3 * (c - b) - p;
        var r:Number = 3 * (d - a - p - q);
        return p + t * (2 * q + t * r);
    }

    public static function evaluate_d2t(a:Number, b:Number, c:Number, d:Number, t:Number):Number
    {
        var p:Number = 3 * (b - a);
        var q:Number = 3 * (c - b) - p;
        var r:Number = 3 * (d - a - p - q);
        return 2 * (q + t * r);
    }

    public static function evaluate_d3t(a:Number, b:Number, c:Number, d:Number):Number
    {
        return 6 * (d - a + 3 * (b - c));
    }

    public static function solve_dt(a:Number, b:Number, c:Number, d:Number, out:Array):void
    {
        var cubicFactor:Number = a + 3 * (c - b) - d;
        var quadFactor:Number = a - 2 * b + c;
        var radicand:Number;

        if (cubicFactor != 0)
        {
            // the part under the square root sign. need to check
            // this isn't negative
            radicand = a * (d - c) + b * (b - c - d) + c * c;

            // if it's 0, then the +/- doesn't change the sum, push one root
            if (radicand == 0)
            {
                out.push(quadFactor / cubicFactor);
            }
            // otherwise push the + and - solution
            else if (radicand > 0)
            {
                var sqrt:Number = Math.sqrt(radicand);
                out.push( (quadFactor + sqrt) / cubicFactor,
                          (quadFactor - sqrt) / cubicFactor );
            }
        }
        else if (quadFactor != 0)
        {
            // if the cubicFactor == 0, then d == a + 3 * (c - b), in which
            // case the solution simplifies to the following:

            // note when cubicFactor == 0 this curve can be represented
            // by a quadratic bezier
            out.push((a - b) / (2 * quadFactor));
        }
        // else this curve represents a uniform line segment
    }

    public static function solve_d2t(a:Number, b:Number, c:Number, d:Number):Number
    {
        return (a - 2 * b + c) / (a + 3 * (c - b) - d);
    }
}
}
