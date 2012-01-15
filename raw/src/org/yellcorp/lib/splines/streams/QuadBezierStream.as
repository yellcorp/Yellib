package org.yellcorp.lib.splines.streams
{
import org.yellcorp.lib.splines.BezierElevation;
import org.yellcorp.lib.splines.QuadBezier;


public class QuadBezierStream implements SplineStream
{
    public var splines:Vector.<QuadBezier> = new Vector.<QuadBezier>();

    private var nx:Number = 0;
    private var ny:Number = 0;

    public function moveTo(x:Number, y:Number):void
    {
        nx = x;
        ny = y;
    }

    public function lineTo(x:Number, y:Number):void
    {
        splines.push(BezierElevation.lineToQuad(nx, ny, x, y, QuadBezier.create()));
        nx = x;
        ny = y;
    }

    public function curveTo(cx:Number, cy:Number, px:Number, py:Number):void
    {
        splines.push(QuadBezier.createFromCoords(nx, ny, cx, cy, px, py));
        nx = px;
        ny = py;
    }
}
}
