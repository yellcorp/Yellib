package org.yellcorp.bitmap.loader
{
import flash.geom.Matrix;
import flash.geom.Point;


internal class ResizerV10 implements Resizer
{
    public static const FP10_MAX_AXIS:uint = 8192;
    public static const FP10_MAX_AREA:uint = 16777216;

    public function isOversize(width:int, height:int):Boolean
    {
        return width > FP10_MAX_AXIS || height > FP10_MAX_AXIS ||
               width * height > FP10_MAX_AREA;
    }


    public function fitCrop(inWidth:int, inHeight:int,
        outSize:Point):void
    {
        var outWidth:Number;
        var outHeight:Number;
        var areaScale:Number;

        outWidth =  Math.min(FP10_MAX_AXIS, inWidth);
        outHeight = Math.min(FP10_MAX_AXIS, inHeight);

        if (outWidth * outHeight > FP10_MAX_AREA)
        {
            areaScale = Math.sqrt(FP10_MAX_AREA / (inWidth * inHeight));
            outWidth = Math.floor(inWidth * areaScale);
            outHeight = Math.floor(inHeight * areaScale);
        }
        outSize.x = outWidth;
        outSize.y = outHeight;
    }


    public function fitScale(inWidth:int, inHeight:int,
        outSize:Point, outMatrix:Matrix):void
    {
        var areaScale:Number;

        var outWidth:Number;
        var outHeight:Number;

        if (inWidth > FP10_MAX_AXIS || inHeight > FP10_MAX_AXIS)
        {
            if (inWidth > inHeight)
            {
                outWidth = FP10_MAX_AXIS;
                outHeight = inHeight * FP10_MAX_AXIS / inWidth;
            }
            else
            {
                outWidth = inWidth * FP10_MAX_AXIS / inHeight;
                outHeight = FP10_MAX_AXIS;
            }
        }
        // axes now within limits, but area may still be too big

        // round before the area test to get the true final pixel count
        outWidth = Math.round(outWidth);
        outHeight = Math.round(outHeight);

        if (outWidth * outHeight > FP10_MAX_AREA)
        {
            // but use the original dimensions for calculating the
            // area scale as it's slightly more accurate
            areaScale = Math.sqrt(FP10_MAX_AREA / (inWidth * inHeight));

            // floor because a round could bump the total area back
            // above the limit
            outWidth = Math.floor(inWidth * areaScale);
            outHeight = Math.floor(inHeight * areaScale);
        }

        outSize.x = outWidth;
        outSize.y = outHeight;

        outMatrix.a = outWidth / inWidth;
        outMatrix.b = 0;
        outMatrix.c = 0;
        outMatrix.d = outHeight / inHeight;
        outMatrix.tx = 0;
        outMatrix.ty = 0;
    }
}
}
