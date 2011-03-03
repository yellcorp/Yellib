package org.yellcorp.bitmap.loader
{
import flash.geom.Matrix;
import flash.geom.Point;


internal class ResizerV9 implements Resizer
{
    public static const FP9_MAX_AXIS:uint = 2880;

    public function isOversize(width:int, height:int):Boolean
    {
        return width > FP9_MAX_AXIS || height > FP9_MAX_AXIS;
    }


    public function fitCrop(inWidth:int, inHeight:int,
        outSize:Point):void
    {
        outSize.x = Math.min(FP9_MAX_AXIS, inWidth);
        outSize.y = Math.min(FP9_MAX_AXIS, inHeight);
    }


    public function fitScale(inWidth:int, inHeight:int,
        outSize:Point, outMatrix:Matrix):void
    {
        var outWidth:Number;
        var outHeight:Number;

        if (inWidth > inHeight)
        {
            outWidth = FP9_MAX_AXIS;
            outHeight = Math.round(inHeight * FP9_MAX_AXIS / inWidth);
        }
        else
        {
            outWidth = Math.round(inWidth * FP9_MAX_AXIS / inHeight);
            outHeight = FP9_MAX_AXIS;
        }

        outSize.x = outWidth;
        outSize.y = outHeight;

        // recalculate the ratio as rounding changes it very
        // slightly which would cause semitransparent edges near
        // the bottom and right borders

        outMatrix.a = outWidth / inWidth;
        outMatrix.b = 0;
        outMatrix.c = 0;
        outMatrix.d = outHeight / inHeight;

        outMatrix.tx = 0;
        outMatrix.ty = 0;
    }
}
}
