package org.yellcorp.lib.splines
{


public class CubicBezierUtil
{
    public static function join(spline1:CubicBezier, spline2:CubicBezier, weight:Number = 0.5):void
    {
        var iw:Number = 1 - weight;

        var newx:Number = spline1.p3.x * iw + spline2.p0.x * weight;
        var newy:Number = spline1.p3.y * iw + spline2.p0.y * weight;

        spline1.p3.x =
        spline2.p0.x = newx;

        spline1.p3.y =
        spline2.p0.y = newy;
    }

    public static function smoothInfluenceAngle(spline1:CubicBezier, spline2:CubicBezier, weight:Number = 0.5):void
    {
    }

    public static function smoothInfluence(spline1:CubicBezier, spline2:CubicBezier, weight:Number = 0.5):void
    {
    }
}
}
