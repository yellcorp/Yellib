package org.yellcorp.lerper
{
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;


public class Lerp
{
    public function lerpNumber(a:Number, b:Number, t:Number):Number
    {
        return a + t * (b - a);
    }

    public function lerpPoint(a:Point, b:Point, t:Number, out:Point):Point
    {
        out.x = a.x + t * (b.x - a.x);
        out.y = b.y + t * (b.y - a.y);

        return out;
    }

    public function lerpRect(a:Rectangle, b:Rectangle, t:Number, out:Rectangle):Rectangle
    {
        out.x = a.x + t * (b.x - a.x);
        out.y = b.y + t * (b.y - a.y);
        out.width = a.width + t * (b.width - a.width);
        out.height = a.height + t * (b.height - a.height);

        return out;
    }

    public function lerpCx(a:ColorTransform, b:ColorTransform, t:Number, out:ColorTransform):ColorTransform
    {
        out.alphaMultiplier = a.alphaMultiplier + t * (b.alphaMultiplier - a.alphaMultiplier);
        out.alphaOffset = a.alphaOffset + t * (b.alphaOffset - a.alphaOffset);
        out.blueMultiplier = a.blueMultiplier + t * (b.blueMultiplier - a.blueMultiplier);
        out.blueOffset = a.blueOffset + t * (b.blueOffset - a.blueOffset);
        out.greenMultiplier = a.greenMultiplier + t * (b.greenMultiplier - a.greenMultiplier);
        out.greenOffset = a.greenOffset + t * (b.greenOffset - a.greenOffset);
        out.redMultiplier = a.redMultiplier + t * (b.redMultiplier - a.redMultiplier);
        out.redOffset = a.redOffset + t * (b.redOffset - a.redOffset);

        return out;
    }
}
}
