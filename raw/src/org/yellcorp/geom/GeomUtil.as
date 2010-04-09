package org.yellcorp.geom
{
import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;


public class GeomUtil
{
    public static function createRectMap(source:Rectangle, target:Rectangle,
        preTranslate:Boolean = false, outMatrix:Matrix = null):Matrix
    {
        return createRectMapParam(
            source.left, source.right, source.top, source.bottom,
            target.left, target.right, target.top, target.bottom,
            preTranslate, outMatrix);
    }

    public static function createRectMapParam(
        fromXMin:Number, fromXMax:Number, fromYMin:Number, fromYMax:Number,
        toXMin:Number, toXMax:Number, toYMin:Number, toYMax:Number,
        preTranslate:Boolean = false, outMatrix:Matrix = null):Matrix
    {
        var scaleX:Number = (toXMax - toXMin) / (fromXMax - fromXMin);
        var scaleY:Number = (toYMax - toYMin) / (fromYMax - fromYMin);

        if (!outMatrix) outMatrix = new Matrix();

        outMatrix.a = scaleX;
        outMatrix.b = 0;
        outMatrix.c = 0;
        outMatrix.d = scaleY;
        outMatrix.tx = toXMin - fromXMin;
        outMatrix.ty = toYMin - fromYMin;

        if (preTranslate)
        {
            outMatrix.tx *= scaleX;
            outMatrix.ty *= scaleY;
        }
        return outMatrix;
    }

    public static function setRectArea(rect:Rectangle, area:Number):void
    {
        var areaRatio:Number = Math.sqrt(area / (rect.width * rect.height));
        rect.width *= areaRatio;
        rect.height *= areaRatio;
    }

    public static function pointsEqual(a:Point, b:Point):Boolean
    {
        if (!a && !b)
        {
            return true;
        }
        else if (!a || !b)
        {
            return false;
        }
        else
        {
            return (a.x == b.x && a.y == b.y);
        }
    }
}
}
