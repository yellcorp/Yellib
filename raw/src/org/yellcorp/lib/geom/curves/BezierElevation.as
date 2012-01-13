package org.yellcorp.lib.geom.curves
{


public class BezierElevation
{
    public static function lineToQuad(x0:Number, y0:Number, x1:Number, y1:Number, out:QuadBezier):QuadBezier
    {
        out.p0.x = x0;
        out.p0.y = y0;

        out.p1.x = .5 * (x0 + x1);
        out.p1.y = .5 * (y0 + y1);

        out.p2.x = x1;
        out.p2.y = y1;

        return out;
    }

    public static function lineToCubic(x0:Number, y0:Number, x1:Number, y1:Number, out:CubicBezier):CubicBezier
    {
        var diffThirdX:Number = (x1 - x0) / 3;
        var diffThirdY:Number = (y1 - y0) / 3;

        out.p0.x = x0;
        out.p0.y = y0;

        out.p1.x = x0 + diffThirdX;
        out.p1.y = y0 + diffThirdY;

        out.p2.x = x0 + diffThirdX * 2;
        out.p2.y = y0 + diffThirdY * 2;

        out.p3.x = x1;
        out.p3.y = y1;

        return out;
    }

    public static function quadToCubic(quad:QuadBezier, out:CubicBezier):CubicBezier
    {
        out.p0.x = quad.p0.x;
        out.p0.y = quad.p0.y;

        out.p1.x = quad.p1.x + (quad.p0.x - quad.p1.x) / 3;
        out.p1.y = quad.p1.y + (quad.p0.y - quad.p1.y) / 3;

        out.p2.x = quad.p1.x + (quad.p2.x - quad.p1.x) / 3;
        out.p2.y = quad.p1.y + (quad.p2.y - quad.p1.y) / 3;

        out.p3.x = quad.p2.x;
        out.p3.y = quad.p2.y;

        return out;
    }
}
}
