package org.yellcorp.geom
{
import flash.geom.Rectangle;


public class FitUtil
{
    public static const MODE_FIT:String = "fit";
    public static const MODE_FILL:String = "fill";

    public static function fitRect(source:Rectangle, target:Rectangle,
                                   mode:String = "fit",
                                   xAlign:Number = 0.5,
                                   yAlign:Number = 0.5,
                                   rounding:Boolean = false):void
    {
        var scale:Number;

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

        if (rounding)
        {
            source.width =  int(.5 + source.width * scale);
            source.height = int(.5 + source.height * scale);
        }
        else
        {
            source.height *= scale;
            source.width *= scale;
        }
        alignRects(source, target, xAlign, yAlign);
        if (rounding)
        {
            source.x = int(.5 + source.x);
            source.y = int(.5 + source.y);
        }
    }

    public static function alignRects(source:Rectangle, target:Rectangle, xAlign:Number, yAlign:Number):void
    {
        source.x = target.x + xAlign * (target.width - source.width);
        source.y = target.y + yAlign * (target.height - source.height);
    }
}
}
