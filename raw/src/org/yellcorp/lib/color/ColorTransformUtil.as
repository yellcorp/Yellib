package org.yellcorp.lib.color
{
import flash.display.BitmapDataChannel;
import flash.geom.ColorTransform;


public class ColorTransformUtil
{
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

    public static function makeNegative(out:ColorTransform = null):ColorTransform
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

    public static function makeMultiply(c:uint, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        var r:Number = (c >> 16) & 0xFF;
        var g:Number = (c >>  8) & 0xFF;
        var b:Number = c & 0xFF;

        out.redMultiplier   = r / 255;
        out.greenMultiplier = g / 255;
        out.blueMultiplier  = b / 255;
        out.alphaMultiplier = 1;

        out.redOffset       =
        out.greenOffset     =
        out.blueOffset      =
        out.alphaOffset     = 0;

        return out;
    }

    public static function makeAdd(c:uint, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        var r:Number = (c >> 16) & 0xFF;
        var g:Number = (c >>  8) & 0xFF;
        var b:Number = c & 0xFF;

        out.redMultiplier   =
        out.greenMultiplier =
        out.blueMultiplier  =
        out.alphaMultiplier = 1;

        out.redOffset       = r;
        out.greenOffset     = g;
        out.blueOffset      = b;
        out.alphaOffset     = 0;

        return out;
    }

    public static function makeScreen(c:uint, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        var r:int = (c >> 16) & 0xFF;
        var g:int = (c >>  8) & 0xFF;
        var b:int = c & 0xFF;

        out.redMultiplier   = 1 - r / 255;
        out.greenMultiplier = 1 - g / 255;
        out.blueMultiplier  = 1 - b / 255;
        out.alphaMultiplier = 1;

        out.redOffset       = r;
        out.greenOffset     = g;
        out.blueOffset      = b;
        out.alphaOffset     = 0;

        return out;
    }

    public static function makeTint(c:uint, amount:Number = 1.0, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        var r:int = (c >> 16) & 0xFF;
        var g:int = (c >>  8) & 0xFF;
        var b:int = c & 0xFF;

        out.redMultiplier   =
        out.greenMultiplier =
        out.blueMultiplier  = 1 - amount;
        out.alphaMultiplier = 1;

        out.redOffset       = r * amount;
        out.greenOffset     = g * amount;
        out.blueOffset      = b * amount;
        out.alphaOffset     = 0;

        return out;
    }

    public static function makeMap(newBlack:uint, newWhite:uint, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        var br:int = (newBlack >> 16) & 0xFF;
        var bg:int = (newBlack >>  8) & 0xFF;
        var bb:int = newBlack & 0xFF;

        var wr:int = (newWhite >> 16) & 0xFF;
        var wg:int = (newWhite >>  8) & 0xFF;
        var wb:int = newWhite & 0xFF;

        out.redMultiplier   = (wr - br) / 255;
        out.greenMultiplier = (wg - bg) / 255;
        out.blueMultiplier  = (wb - bb) / 255;
        out.alphaMultiplier = 1;

        out.redOffset       = br;
        out.greenOffset     = bg;
        out.blueOffset      = bb;
        out.alphaOffset     = 0;

        return out;
    }

    public static function makeRangeMap(fromLow:uint, fromHigh:uint,
                                        toLow:uint,   toHigh:uint,
                                        out:ColorTransform = null):ColorTransform
    {

        var fr0:int = (fromLow >> 16) & 0xFF;
        var fg0:int = (fromLow >>  8) & 0xFF;
        var fb0:int = fromLow & 0xFF;

        var fr1:int = (fromHigh >> 16) & 0xFF;
        var fg1:int = (fromHigh >>  8) & 0xFF;
        var fb1:int = fromHigh & 0xFF;

        var tr0:int = (toLow >> 16) & 0xFF;
        var tg0:int = (toLow >>  8) & 0xFF;
        var tb0:int = toLow & 0xFF;

        var tr1:int = (toHigh >> 16) & 0xFF;
        var tg1:int = (toHigh >>  8) & 0xFF;
        var tb1:int = toHigh & 0xFF;

        if (!out) out = new ColorTransform();

        // this elaborate dance is to absorb div/0 errors.  considered
        // throwing an exception or letting NaNs propagate, but because the
        // output range is clamped, +/-Inf can be swapped for any
        // appropriately out-of-range finite number.  this plus plenty of
        // conceivable use cases where inRange = 0 makes it possible to
        // fix the input values instead of rejecting them

        var scaleR:Number = (fr1 - fr0);
        var scaleG:Number = (fg1 - fg0);
        var scaleB:Number = (fb1 - fb0);

        // this magic number is taken from the maximum multiplier before
        // ColorMatrixFilter ditches SSE acceleration.  even though this
        // is a ColorTransform instead but it's a reasonable assumption

        // this number means a 1 or -1 difference in the target range will
        // scale to +/-4000, then get divided by 255 to get a multiplier of
        // +/-15.686.  SSE is ditched at +/-15.99
        if (scaleR == 0) scaleR = 0.00025;
        if (scaleG == 0) scaleG = 0.00025;
        if (scaleB == 0) scaleB = 0.00025;

        scaleR = (tr1 - tr0) / scaleR;
        scaleG = (tg1 - tg0) / scaleG;
        scaleB = (tb1 - tb0) / scaleB;

        out.redMultiplier   = ((255 - fr0) * scaleR + tr0) / 255;
        out.greenMultiplier = ((255 - fg0) * scaleG + tg0) / 255;
        out.blueMultiplier  = ((255 - fb0) * scaleB + tb0) / 255;
        out.alphaMultiplier = 1;

        out.redOffset       = -fr0 * scaleR + tr0;
        out.greenOffset     = -fg0 * scaleG + tg0;
        out.blueOffset      = -fb0 * scaleB + tb0;
        out.alphaOffset     = 0;

        return out;
    }

    public static function makeLevels(blackPoint:Number, whitePoint:Number, channels:uint = 7, out:ColorTransform = null):ColorTransform
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

    public static function makeFromColorMatrix(m:Array, out:ColorTransform = null):ColorTransform
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

    public static function invert(ct:ColorTransform, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        var irm:Number = 1 / ct.redMultiplier;
        var igm:Number = 1 / ct.greenMultiplier;
        var ibm:Number = 1 / ct.blueMultiplier;
        var iam:Number = 1 / ct.alphaMultiplier;

        out.redMultiplier =   irm;
        out.greenMultiplier = igm;
        out.blueMultiplier =  ibm;
        out.alphaMultiplier = iam;

        out.redOffset *=   -irm;
        out.greenOffset *= -igm;
        out.blueOffset *=  -ibm;
        out.alphaOffset *= -iam;

        return out;
    }
}
}
