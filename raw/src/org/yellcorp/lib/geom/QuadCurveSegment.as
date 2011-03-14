package org.yellcorp.lib.geom
{
import flash.display.Graphics;
import flash.geom.Point;


public class QuadCurveSegment
{
    public var start:Point;
    public var end:Point;
    public var influence:Point;

    public function QuadCurveSegment(start:Point, influence:Point, end:Point)
    {
        this.start = start;
        this.influence = influence;
        this.end = end;
    }
    public function clone():QuadCurveSegment
    {
        return new QuadCurveSegment(start.clone(), influence.clone(), end.clone());
    }

    public function sample(t:Number, outPoint:Point = null):Point
    {
        var invt:Number = 1 - t;
        if (!outPoint) outPoint = new Point();
        outPoint.x = invt * invt * start.x + 2 * invt * t * influence.x + t * t * end.x;
        outPoint.y = invt * invt * start.y + 2 * invt * t * influence.y + t * t * end.y;
        return outPoint;
    }

    public function subdivideLow(t:Number):QuadCurveSegment
    {
        return new QuadCurveSegment(
            start.clone(),
            Point.interpolate(influence, start, t), // args are backwards
            sample(t));
    }

    public function subdivideHigh(t:Number):QuadCurveSegment
    {
        return new QuadCurveSegment(
            sample(t),
            Point.interpolate(end, influence, t),
            end.clone());
    }

    public function draw(g:Graphics):void
    {
        g.moveTo(start.x, start.y);
        g.curveTo(influence.x, influence.y, end.x, end.y);
    }

    public function drawHull(g:Graphics):void
    {
        g.moveTo(start.x, start.y);
        g.lineTo(influence.x, influence.y);
        g.lineTo(end.x, end.y);
    }
}
}
