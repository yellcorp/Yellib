package org.yellcorp.geom
{
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;


public class FitUtil
{
    public static const MODE_FIT:String = "fit";
    public static const MODE_FILL:String = "fill";

    public static const ALIGN_TOP_LEFT:String = "TL";
    public static const ALIGN_TOP_CENTER:String = "T";
    public static const ALIGN_TOP_RIGHT:String = "TR";

    public static const ALIGN_CENTER_LEFT:String = "L";
    public static const ALIGN_CENTER_CENTER:String = "C";
    public static const ALIGN_CENTER_RIGHT:String = "R";

    public static const ALIGN_BOTTOM_LEFT:String = "BL";
    public static const ALIGN_BOTTOM_CENTER:String = "B";
    public static const ALIGN_BOTTOM_RIGHT:String = "BR";

    private static var xAlign:Object = {
        TL: 0.0,  T: 0.5, TR: 1.0,
         L: 0.0,  C: 0.5,  R: 1.0,
        BL: 0.0,  B: 0.5, BR: 1.0
    };

    private static var yAlign:Object = {
        TL: 0.0,  T: 0.0, TR: 0.0,
         L: 0.5,  C: 0.5,  R: 0.5,
        BL: 1.0,  B: 1.0, BR: 1.0
    };

    public function fitTransform(source:Rectangle, target:Rectangle,
                                 mode:String = "fit",
                                 align:String = "TL",
                                 rounding:Boolean = false,
                                 result:Matrix = null):Matrix
    {
        var scale:Number;
        var scaledWidth:Number;
        var scaledHeight:Number;

        if (mode == MODE_FILL)
        {
            scale = Math.max(target.width / source.width,
                             target.height / source.height);
        }
        else
        {
            scale = Math.min(target.width / source.width,
                             target.height / source.height);
        }

        if (!result) result = new Matrix();

        if (rounding)
        {
            scaledWidth =  int(.5 + source.width * scale);
            scaledHeight = int(.5 + source.height * scale);
            result.a = scaledWidth / source.width;
            result.d = scaledHeight / source.height;
        }
        else
        {
            scaledWidth =  source.width * scale;
            scaledHeight = source.height * scale;
            result.a = result.d = scale;
        }
        result.b = result.c = 0;
        alignRectsMatrix(scaledWidth, scaledHeight,
                         target.width, target.height,
                         target.left, target.top,
                         align, result);
        if (rounding)
        {
            result.tx = int(.5 + result.tx);
            result.ty = int(.5 + result.ty);
        }
        return result;
    }

    public function alignRectsPoint(sourceWidth:Number,
                                    sourceHeight:Number,
                                    targetWidth:Number,
                                    targetHeight:Number,
                                    targetX:Number,
                                    targetY:Number,
                                    align:String,
                                    result:Point = null):Point
    {
        if (!result) result = new Point();
        result.x = targetX + xAlign[align] * (targetWidth - sourceWidth);
        result.y = targetY + yAlign[align] * (targetHeight - sourceHeight);
        return result;
    }

    public function alignRectsMatrix(sourceWidth:Number,
                                     sourceHeight:Number,
                                     targetWidth:Number,
                                     targetHeight:Number,
                                     targetX:Number,
                                     targetY:Number,
                                     align:String,
                                     result:Matrix = null):Matrix
    {
        if (!result) result = new Matrix();
        result.tx = targetX + xAlign[align] * (targetWidth - sourceWidth);
        result.ty = targetY + yAlign[align] * (targetHeight - sourceHeight);
        return result;
    }
}
}
