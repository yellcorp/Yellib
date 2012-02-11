package org.yellcorp.lib.geom
{
import flash.geom.Point;
import flash.geom.Rectangle;


public class RectUtil
{
    public static function multiply(
        rect:Rectangle, factor:Number, out:Rectangle = null):Rectangle
    {
        if (!out) out = new Rectangle();
        out.x = rect.x * factor;
        out.y = rect.y * factor;
        out.width = rect.width * factor;
        out.height = rect.height * factor;
        return out;
    }

    public static function transform(
        rect:Rectangle,
        xFactor:Number, yFactor:Number,
        xOffset:Number, yOffset:Number,
        out:Rectangle = null):Rectangle
    {
        if (!out) out = new Rectangle();
        out.x = rect.x * xFactor + xOffset;
        out.y = rect.y * yFactor + yOffset;
        out.width = rect.width * xFactor;
        out.height = rect.height * yFactor;
        return out;
    }

    public static function roundOut(
        rect:Rectangle, out:Rectangle = null):Rectangle
    {
        if (!out) out = new Rectangle();

        var r:Number = rect.right, b:Number = rect.bottom;

        out.x = Math.floor(rect.x);
        out.y = Math.floor(rect.y);
        out.width = Math.ceil(r) - out.x;
        out.height = Math.ceil(b) - out.y;
        return out;
    }

    public static function roundIn(
        rect:Rectangle, out:Rectangle = null):Rectangle
    {
        if (!out) out = new Rectangle();

        var r:Number = rect.right, b:Number = rect.bottom;

        out.x = Math.ceil(rect.x);
        out.y = Math.ceil(rect.y);
        out.width = Math.floor(r) - out.x;
        out.height = Math.floor(b) - out.y;
        return out;
    }

    public static function mapPoint(
        point:Point,
        from:Rectangle, to:Rectangle,
        out:Rectangle = null):Rectangle
    {
        if (!out) out = new Rectangle();
        out.x = to.x + to.width * (point.x - from.x) / from.width;
        out.y = to.y + to.height * (point.y - from.y) / from.height;
        return out;
    }

    public static function mapRect(
        rect:Rectangle,
        from:Rectangle, to:Rectangle,
        out:Rectangle = null):Rectangle
    {
        if (!out) out = new Rectangle();
        out.x = to.x + to.width * (rect.x - from.x) / from.width;
        out.y = to.y + to.height * (rect.y - from.y) / from.height;
        out.width = to.width * (rect.right - from.x) / from.width;
        out.height = to.height * (rect.bottom - from.y) / from.height;
        return out;
    }

    public static function clampPoint(
        point:Point, rect:Rectangle, out:Point = null):Point
    {
        if (!out) out = new Point();

        if (point.x < rect.left)  {  out.x = rect.left;  }
        else if (point.x > rect.right)  {  out.x = rect.right;  }
        else  {  out.x = point.x;  }

        if (point.y < rect.top)  {  out.y = rect.top;  }
        else if (point.y > rect.bottom)  {  out.y = rect.bottom;  }
        else  {  out.y = point.y;  }

        return out;
    }

    public static function setArea(
        rect:Rectangle, area:Number, out:Rectangle = null):Rectangle
    {
        if (!out) out = new Rectangle();
        var areaRatio:Number = Math.sqrt(area / (rect.width * rect.height));
        out.x = rect.x;
        out.y = rect.y;
        out.width = rect.width * areaRatio;
        out.height = rect.height * areaRatio;
        return out;
    }
}
}
