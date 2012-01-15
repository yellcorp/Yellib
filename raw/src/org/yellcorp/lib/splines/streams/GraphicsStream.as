package org.yellcorp.lib.splines.streams
{
import flash.display.Graphics;


public class GraphicsStream implements SplineStream
{
    public var target:Graphics;

    public function GraphicsStream(target:Graphics)
    {
        this.target = target;
    }

    public function moveTo(x:Number, y:Number):void
    {
        target.moveTo(x, y);
    }

    public function lineTo(x:Number, y:Number):void
    {
        target.lineTo(x, y);
    }

    public function curveTo(cx:Number, cy:Number, px:Number, py:Number):void
    {
        target.curveTo(cx, cy, px, py);
    }
}
}
