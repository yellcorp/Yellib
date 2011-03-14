package org.yellcorp.lib.color
{
import flash.display.BitmapDataChannel;
import flash.geom.ColorTransform;


public class ColorTransformUtil
{
    public static const SCALE:Number = 255;
    public static const INVSCALE:Number = 1 / 255;

    public static function copyColorMatrix(m:Array, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        out.redMultiplier   = m[0];
        out.greenMultiplier = m[6];
        out.blueMultiplier  = m[12];
        out.alphaMultiplier = m[18];
        out.redOffset       = m[4];
        out.greenOffset     = m[9];
        out.blueOffset      = m[14];
        out.alphaOffset     = m[19];

        return out;
    }

    public static function clear(out:ColorTransform):ColorTransform
    {
        out.redMultiplier   =
        out.greenMultiplier =
        out.blueMultiplier  =
        out.alphaMultiplier = 1;
        out.redOffset       =
        out.greenOffset     =
        out.blueOffset      =
        out.alphaOffset     = 0;

        return out;
    }

    public static function setInvert(out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        out.redMultiplier   = -1;
        out.greenMultiplier = -1;
        out.blueMultiplier  = -1;
        out.alphaMultiplier = 1;

        out.redOffset       = 255;
        out.greenOffset     = 255;
        out.blueOffset      = 255;
        out.alphaOffset     = 0;

        return out;
    }

    public static function setMultiply(c:VectorRGB, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        out.redMultiplier   = c.r * INVSCALE;
        out.greenMultiplier = c.g * INVSCALE;
        out.blueMultiplier  = c.b * INVSCALE;
        out.alphaMultiplier = 1;

        out.redOffset       =
        out.greenOffset     =
        out.blueOffset      =
        out.alphaOffset     = 0;

        return out;
    }

    public static function setAdd(c:VectorRGB, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        out.redMultiplier   =
        out.greenMultiplier =
        out.blueMultiplier  =
        out.alphaMultiplier = 1;

        out.redOffset       = c.r;
        out.greenOffset     = c.g;
        out.blueOffset      = c.b;
        out.alphaOffset     = 0;

        return out;
    }

    public static function setScreen(c:VectorRGB, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        out.redMultiplier   = 1 - c.r * INVSCALE;
        out.greenMultiplier = 1 - c.g * INVSCALE;
        out.blueMultiplier  = 1 - c.b * INVSCALE;
        out.alphaMultiplier = 1;

        out.redOffset       = c.r;
        out.greenOffset     = c.g;
        out.blueOffset      = c.b;
        out.alphaOffset     = 0;

        return out;
    }

    public static function setTint(c:VectorRGB, amount:Number = 1.0, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        var ainv:Number = 1 - amount;
        out.redMultiplier   = ainv;
        out.greenMultiplier = ainv;
        out.blueMultiplier  = ainv;
        out.alphaMultiplier = 1;

        out.redOffset       = c.r * amount;
        out.greenOffset     = c.g * amount;
        out.blueOffset      = c.b * amount;
        out.alphaOffset     = 0;

        return out;
    }

    public static function setMap(newBlack:VectorRGB, newWhite:VectorRGB, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        out.redMultiplier   = (newWhite.r - newBlack.r) * INVSCALE;
        out.greenMultiplier = (newWhite.g - newBlack.g) * INVSCALE;
        out.blueMultiplier  = (newWhite.b - newBlack.b) * INVSCALE;
        out.alphaMultiplier = 1;

        out.redOffset       = newBlack.r;
        out.greenOffset     = newBlack.g;
        out.blueOffset      = newBlack.b;
        out.alphaOffset     = 0;

        return out;
    }

    public static function setRangeMap(fromLow:VectorRGB, fromHigh:VectorRGB,
                                       toLow:VectorRGB,   toHigh:VectorRGB,
                                       out:ColorTransform = null):ColorTransform
    {
        var scaleR:Number;
        var scaleG:Number;
        var scaleB:Number;

        if (!out) out = new ColorTransform();

        // this elaborate dance is to absorb div/0 errors.  considered
        // throwing an exception or letting NaNs propagate, but because the
        // output range is clamped, +/-Inf can be swapped for any
        // appropriately out-of-range finite number.  this plus plenty of
        // conceivable use cases where inRange = 0 makes it possible to
        // fix the input values instead of rejecting them

        scaleR = (fromHigh.r - fromLow.r);
        scaleG = (fromHigh.g - fromLow.g);
        scaleB = (fromHigh.b - fromLow.b);

        // this magic number is taken from the maximum multiplier before
        // ColorMatrixFilter ditches SSE acceleration.  even though this
        // is a ColorTransform instead but it's a reasonable assumption

        // this number means a 1 or -1 difference in the target range will
        // scale to +/-4000, then get divided by 255 to get a multiplier of
        // +/-15.686.  SSE is ditched at +/-15.99
        if (scaleR == 0) scaleR = 0.00025;
        if (scaleG == 0) scaleG = 0.00025;
        if (scaleB == 0) scaleB = 0.00025;

        scaleR = (toHigh.r - toLow.r) / scaleR;
        scaleG = (toHigh.g - toLow.g) / scaleG;
        scaleB = (toHigh.b - toLow.b) / scaleB;

        out.redMultiplier   = ((255 - fromLow.r) * scaleR + toLow.r) * INVSCALE;
        out.greenMultiplier = ((255 - fromLow.g) * scaleG + toLow.g) * INVSCALE;
        out.blueMultiplier  = ((255 - fromLow.b) * scaleB + toLow.b) * INVSCALE;
        out.alphaMultiplier = 1;

        out.redOffset       = -fromLow.r * scaleR + toLow.r;
        out.greenOffset     = -fromLow.g * scaleG + toLow.g;
        out.blueOffset      = -fromLow.b * scaleB + toLow.b;
        out.alphaOffset     = 0;

        return out;
    }

    public static function setLevels(blackPoint:Number, whitePoint:Number, channels:uint = 7, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        var factor:Number = 255 / (whitePoint - blackPoint);
        var offset:Number = -blackPoint * factor;

        if (channels & BitmapDataChannel.RED)
        {
            out.redMultiplier = factor;
            out.redOffset = offset;
        }
        else
        {
            out.redMultiplier = 1;
            out.redOffset = 0;
        }

        if (channels & BitmapDataChannel.GREEN)
        {
            out.greenMultiplier = factor;
            out.greenOffset = offset;
        }
        else
        {
            out.greenMultiplier = 1;
            out.greenOffset = 0;
        }

        if (channels & BitmapDataChannel.BLUE)
        {
            out.blueMultiplier = factor;
            out.blueOffset = offset;
        }
        else
        {
            out.blueMultiplier = 1;
            out.blueOffset = 0;
        }

        if (channels & BitmapDataChannel.ALPHA)
        {
            out.alphaMultiplier = factor;
            out.alphaOffset = offset;
        }
        else
        {
            out.alphaMultiplier = 1;
            out.alphaOffset = 0;
        }

        return out;
    }
}
}
