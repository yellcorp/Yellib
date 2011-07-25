package org.yellcorp.lib.color.matrix
{
import org.yellcorp.lib.color.SRGB;

import flash.display.BitmapDataChannel;


public class ColorMatrixFactory
{
    public static const SQRT3:Number = Math.sqrt(3);

    public static function makeDesaturate(out:Array = null):Array
    {
        if (!out)
        {
            out = [ ];
            ColorMatrixUtil.setDefaultAlpha(out);
        }

        out[ 0] = 0.33333;  out[ 1] = 0.33334;  out[ 2] = 0.33333;  out[ 3] = 0;  out[ 4] = 0;
        out[ 5] = 0.33333;  out[ 6] = 0.33334;  out[ 7] = 0.33333;  out[ 8] = 0;  out[ 9] = 0;
        out[10] = 0.33333;  out[11] = 0.33334;  out[12] = 0.33333;  out[13] = 0;  out[14] = 0;

        return out;
    }

    public static function makeLuma(out:Array = null):Array
    {
        if (!out)
        {
            out = [ ];
            ColorMatrixUtil.setDefaultAlpha(out);
        }

        out[ 0] = SRGB.redY;  out[ 1] = SRGB.greenY;  out[ 2] = SRGB.blueY;  out[ 3] = 0;  out[ 4] = 0;
        out[ 5] = SRGB.redY;  out[ 6] = SRGB.greenY;  out[ 7] = SRGB.blueY;  out[ 8] = 0;  out[ 9] = 0;
        out[10] = SRGB.redY;  out[11] = SRGB.greenY;  out[12] = SRGB.blueY;  out[13] = 0;  out[14] = 0;
        out[15] =         0;  out[16] =           0;  out[17] =          0;  out[18] = 1;  out[19] = 0;

        return out;
    }

    public static function makeMultiply(c:uint, out:Array = null):Array
    {
        if (!out)
        {
            out = [ ];
            ColorMatrixUtil.setDefaultAlpha(out);
        }

        var r:Number = (c >> 16) & 0xFF;
        var g:Number = (c >>  8) & 0xFF;
        var b:Number = c & 0xFF;

        ColorMatrixUtil.setDiagonal(out,
            r / 255,
            g / 255,
            b / 255);

        ColorMatrixUtil.setOffset(out, 0, 0, 0);
        ColorMatrixUtil.clearCrossChannel(out);
        return out;
    }

    public static function makeAdd(c:uint, out:Array = null):Array
    {
        if (!out)
        {
            out = [ ];
            ColorMatrixUtil.setDefaultAlpha(out);
        }

        var r:Number = (c >> 16) & 0xFF;
        var g:Number = (c >>  8) & 0xFF;
        var b:Number = c & 0xFF;

        ColorMatrixUtil.setDiagonal(out, 1, 1, 1);
        ColorMatrixUtil.setOffset(out, r, g, b);
        ColorMatrixUtil.clearCrossChannel(out);
        return out;
    }

    public static function makeScreen(c:uint, out:Array = null):Array
    {
        if (!out)
        {
            out = [ ];
            ColorMatrixUtil.setDefaultAlpha(out);
        }

        var r:Number = (c >> 16) & 0xFF;
        var g:Number = (c >>  8) & 0xFF;
        var b:Number = c & 0xFF;

        ColorMatrixUtil.setDiagonal(out,
            1 - r / 255,
            1 - g / 255,
            1 - b / 255);

        ColorMatrixUtil.setOffset(out, r, g, b);
        ColorMatrixUtil.clearCrossChannel(out);
        return out;
    }

    public static function makeTint(c:uint, amount:Number, out:Array = null):Array
    {
        if (!out)
        {
            out = [ ];
            ColorMatrixUtil.setDefaultAlpha(out);
        }

        var r:Number = (c >> 16) & 0xFF;
        var g:Number = (c >>  8) & 0xFF;
        var b:Number = c & 0xFF;

        var inv:Number = 1 - amount;

        ColorMatrixUtil.setDiagonal(out, inv, inv, inv);
        ColorMatrixUtil.setOffset(out, r * amount, g * amount, b * amount);
        ColorMatrixUtil.clearCrossChannel(out);
        return out;
    }

    public static function makeMap(blackPoint:uint, whitePoint:uint, out:Array = null):Array
    {
        if (!out)
        {
            out = [ ];
            ColorMatrixUtil.setDefaultAlpha(out);
        }

        var br:int = (blackPoint >> 16) & 0xFF;
        var bg:int = (blackPoint >>  8) & 0xFF;
        var bb:int = blackPoint & 0xFF;

        var wr:int = (whitePoint >> 16) & 0xFF;
        var wg:int = (whitePoint >>  8) & 0xFF;
        var wb:int = whitePoint & 0xFF;

        ColorMatrixUtil.setDiagonal(out,
            (wr - br) / 255,
            (wg - bg) / 255,
            (wb - bb) / 255);

        ColorMatrixUtil.setOffset(out, br, bg, bb);
        ColorMatrixUtil.clearCrossChannel(out);
        return out;
    }

    public static function makeDuotone(blackPoint:uint, whitePoint:uint, out:Array = null):Array
    {
        if (!out)
        {
            out = [ ];
            ColorMatrixUtil.setDefaultAlpha(out);
        }

        var br:int = (blackPoint >> 16) & 0xFF;
        var bg:int = (blackPoint >>  8) & 0xFF;
        var bb:int = blackPoint & 0xFF;

        var wr:int = (whitePoint >> 16) & 0xFF;
        var wg:int = (whitePoint >>  8) & 0xFF;
        var wb:int = whitePoint & 0xFF;

        var dr:Number = (wr - br) / 255;
        var dg:Number = (wg - bg) / 255;
        var db:Number = (wb - bb) / 255;

        out[ 0] = SRGB.redY * dr;  out[ 1] = SRGB.greenY * dr;  out[ 2] = SRGB.blueY * dr;  out[ 3] = 0;  out[ 4] = br;
        out[ 5] = SRGB.redY * dg;  out[ 6] = SRGB.greenY * dg;  out[ 7] = SRGB.blueY * dg;  out[ 8] = 0;  out[ 9] = bg;
        out[10] = SRGB.redY * db;  out[11] = SRGB.greenY * db;  out[12] = SRGB.blueY * db;  out[13] = 0;  out[14] = bb;

        return out;
    }

    public static function makeLevels(blackPoint:Number, whitePoint:Number, channels:uint = 7, out:Array = null):Array
    {
        if (!out) out = [ ];

        var factor:Number = 255 / (whitePoint - blackPoint);
        var offset:Number = -blackPoint * factor;

        if (channels & BitmapDataChannel.RED)
        {
            out[0] = factor;
            out[4] = offset;
        }
        else
        {
            out[0] = 1;
            out[4] = 0;
        }

        if (channels & BitmapDataChannel.GREEN)
        {
            out[6] = factor;
            out[9] = offset;
        }
        else
        {
            out[6] = 1;
            out[9] = 0;
        }

        if (channels & BitmapDataChannel.BLUE)
        {
            out[12] = factor;
            out[14] = offset;
        }
        else
        {
            out[12] = 1;
            out[14] = 0;
        }

        if (channels & BitmapDataChannel.ALPHA)
        {
            out[18] = factor;
            out[19] = offset;
        }
        else
        {
            out[18] = 1;
            out[19] = 0;
        }

        ColorMatrixUtil.clearCrossChannel(out);
        return out;
    }

    public static function makeHueSaturation(hueRadians:Number, saturation:Number, out:Array = null):Array
    {
        // if you can work it out you could apply a shear of some kind
        // so the rotation axis stays as |[1,1,1]| but any point off the
        // axis rotates parallel to the luma plane (0.2126, 0.7152, 0.0722)

        // this would maintain luma values but i don't think even
        // real HSB does this

        var cosa:Number;
        var sina:Number;

        var invsat:Number;

        var diag:Number;
        var skewpos:Number;
        var skewneg:Number;

        if (!out)
        {
            out = [ ];
            ColorMatrixUtil.setDefaultAlpha(out);
        }

        if (saturation != 0)
        {
            cosa = Math.cos(hueRadians);
            sina = Math.sin(hueRadians);

            saturation /= 3;
            invsat = 1 / 3 - saturation;

            diag = saturation * (1 + 2 * cosa) + invsat;

            skewpos = saturation * (1 - cosa - SQRT3 * sina) + invsat;
            skewneg = saturation * (1 - cosa + SQRT3 * sina) + invsat;
        }
        else
        {
            diag = skewpos = skewneg = 1/3;
        }

        out[0] =
        out[6] =
        out[12] = diag;

        out[1] =
        out[7] =
        out[10] = skewpos;

        out[2] =
        out[5] =
        out[11] = skewneg;

        out[3] =
        out[4] =
        out[8] =
        out[9] =
        out[13] =
        out[14] = 0;

        return out;
    }

    public static function makeCopyChannelToAlpha(inChannelMask:uint, out:Array = null):Array
    {
        if (!out) out = ColorMatrixUtil.makeIdentity();

        out[15] = inChannelMask & BitmapDataChannel.RED ? 1 : 0;
        out[16] = inChannelMask & BitmapDataChannel.GREEN ? 1 : 0;
        out[17] = inChannelMask & BitmapDataChannel.BLUE ? 1 : 0;
        out[18] = inChannelMask & BitmapDataChannel.ALPHA ? 1 : 0;

        return out;
    }

    public static function makeChannelUnion(inChannelMask:uint, outChannel:uint, out:Array = null):Array
    {
        if (!out) out = ColorMatrixUtil.makeIdentity();

        setChannelLogicOp(inChannelMask, outChannel, 0, out);

        return out;
    }

    public static function makeChannelIntersection(inChannelMask:uint, outChannel:uint, out:Array = null):Array
    {
        var offset:Number;
        var countBits:uint = inChannelMask;

        if (!out) out = ColorMatrixUtil.makeIdentity();

        // count the bits in inChannelMask, this tells us how many source
        // channels are being used.  the offset result is
        // ((number of channels used) - 1) * -255
        offset = 255;
        while (countBits > 0)
        {
            if (countBits & 1) offset -= 255;
            countBits >>>= 1;
        }

        setChannelLogicOp(inChannelMask, outChannel, offset, out);

        return out;
    }

    private static function setChannelLogicOp(inChannelMask:uint, outChannel:uint, offset:Number, out:Array):void
    {
        var outRow:int;

        switch (outChannel)
        {
        case BitmapDataChannel.RED :
            outRow = 0;
            break;

        case BitmapDataChannel.GREEN :
            outRow = 5;
            break;

        case BitmapDataChannel.BLUE :
            outRow = 10;
            break;

        case BitmapDataChannel.ALPHA :
            outRow = 15;
            break;

        default :
            throw new ArgumentError("Must specify exactly one output channel");
            break;
        }

        out[outRow++] = inChannelMask & BitmapDataChannel.RED ? 1 : 0;
        out[outRow++] = inChannelMask & BitmapDataChannel.GREEN ? 1 : 0;
        out[outRow++] = inChannelMask & BitmapDataChannel.BLUE ? 1 : 0;
        out[outRow++] = inChannelMask & BitmapDataChannel.ALPHA ? 1 : 0;
        out[outRow++] = offset;

        // decided not to set the rest to identity.  if you only want the
        // result of outChannel then it doesn't matter.  if you do want the
        // other channels, you can set the matrix up before calling i guess
    }
}
}
