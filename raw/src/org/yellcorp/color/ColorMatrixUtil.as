package org.yellcorp.color
{
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.geom.ColorTransform;


public class ColorMatrixUtil
{
    public static const SCALE:Number = 255;
    public static const INVSCALE:Number = 1 / 255;
    public static const SQRT3:Number = Math.sqrt(3);    // used for hue rotate

    public static function copyColorTransform(c:ColorTransform, out:ColorMatrix = null):ColorMatrix
    {
        if (!out) out = new ColorMatrix();
        out.setDiagonalOffset( c.redMultiplier, c.greenMultiplier, c.blueMultiplier, c.alphaMultiplier,
                               c.redOffset, c.greenOffset, c.blueOffset, c.alphaOffset );
        return out;
    }

    public static function setMultiply(c:VectorRGB, out:ColorMatrix = null):ColorMatrix
    {
        if (!out) out = new ColorMatrix();
        out.setDiagonalOffset( c.r * INVSCALE,
                               c.g * INVSCALE,
                               c.b * INVSCALE,
                               1,
                               0, 0, 0, 0 );
        return out;
    }

    public static function setAdd(c:VectorRGB, out:ColorMatrix = null):ColorMatrix
    {
        if (!out) out = new ColorMatrix();
        out.setDiagonalOffset(   1,   1,   1, 1,
                               c.r, c.g, c.b, 0 );
        return out;
    }

    public static function setScreen(c:VectorRGB, out:ColorMatrix = null):ColorMatrix
    {
        if (!out) out = new ColorMatrix();
        out.setDiagonalOffset( 1 - c.r * INVSCALE,
                               1 - c.g * INVSCALE,
                               1 - c.b * INVSCALE,
                               1,
                               c.r, c.g, c.b, 0 );
        return out;
    }

    public static function setTint(c:VectorRGB, amount:Number = 1.0, out:ColorMatrix = null):ColorMatrix
    {
        if (!out) out = new ColorMatrix();
        var ainv:Number = 1 - amount;
        out.setDiagonalOffset( ainv, ainv, ainv, 1,
                               c.r * amount,
                               c.g * amount,
                               c.b * amount,
                               0 );
        return out;
    }

    public static function setMap(newBlack:VectorRGB, newWhite:VectorRGB, out:ColorMatrix = null):ColorMatrix
    {
        if (!out) out = new ColorMatrix();
        out.setDiagonalOffset( (newWhite.r - newBlack.r) * INVSCALE,
                               (newWhite.g - newBlack.g) * INVSCALE,
                               (newWhite.b - newBlack.b) * INVSCALE,
                               1,
                               newBlack.r, newBlack.g, newBlack.b, 0 );
        return out;
    }

    public static function setLevels(blackPoint:Number, whitePoint:Number, channels:uint = 7, out:ColorMatrix = null):ColorMatrix
    {
        var factor:Number = 255 / (whitePoint - blackPoint);
        var offset:Number = -blackPoint * factor;

        var i:int;
        var mask:uint = 1;
        var mIndex:int = 0;
        var oIndex:int = 4;

        if (!out) out = new ColorMatrix();

        for (i = 0; i < 4; i++)
        {
            if ((channels & mask) > 0)
            {
                out[mIndex] = factor;
                out[oIndex] = offset;
            }
            else
            {
                out[mIndex] = 1;
                out[oIndex] = 0;
            }
            mask <<= 1;
            mIndex += 6;
            oIndex += 5;
        }

        return out;
    }

    public static function setHueSaturation(hueRadians:Number, saturation:Number, out:ColorMatrix = null):ColorMatrix
    {
        // wow, completely overthought
        // just 3d rotate with normalized(1,1,1) as the axis
        // i.e. (3^-2, 3^-2, 3^-2)

        // don't even need to scale or xlate

        // if you can work it out you could apply a shear of some kind
        // so the rotation axis stays as [1,1,1] but any point off the
        // axis rotates parallel to the luma plane (0.2126, 0.7152, 0.0722)

        // this would maintain luma values but i don't think even
        // real HSB does this

        var cosa:Number;
        var sina:Number;

        var unsat:Number;

        var diag:Number;
        var skewpos:Number;
        var skewneg:Number;

        if (!out) out = new ColorMatrix();

        if (saturation != 0)
        {
            cosa = Math.cos(hueRadians);
            sina = Math.sin(hueRadians);

            // compiler should optimize 1/3 to 0.3333...
            saturation *= 1/3;
            unsat = (1/3) - saturation;

            diag = saturation * (1 + 2 * cosa) + unsat;
            skewpos = saturation * (1 - cosa - SQRT3 * sina) + unsat;
            skewneg = saturation * (1 - cosa + SQRT3 * sina) + unsat;
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
        out[14] =
        out[15] =
        out[16] =
        out[17] =
        out[19] = 0;

        out[18] = 1;

        return out;
    }

    public static function setChannelToAlpha(inChannelMask:uint, out:ColorMatrix = null):ColorMatrix
    {
        if (!out) out = new ColorMatrix();

        out[15] = inChannelMask & BitmapDataChannel.RED ? 1 : 0;
        out[16] = inChannelMask & BitmapDataChannel.GREEN ? 1 : 0;
        out[17] = inChannelMask & BitmapDataChannel.BLUE ? 1 : 0;
        out[18] = inChannelMask & BitmapDataChannel.ALPHA ? 1 : 0;

        return out;
    }

    public static function setChannelUnion(inChannelMask:uint, outChannel:uint, out:ColorMatrix = null):ColorMatrix
    {
        if (!out) out = new ColorMatrix();

        setChannelLogicOp(inChannelMask, outChannel, 0, out);

        return out;
    }

    public static function setChannelIntersection(inChannelMask:uint, outChannel:uint, out:ColorMatrix = null):ColorMatrix
    {
        var offset:Number;
        var countBits:uint = inChannelMask;

        if (!out) out = new ColorMatrix();

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

    private static function setChannelLogicOp(inChannelMask:uint, outChannel:uint, offset:Number, out:ColorMatrix):void
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

        // probably don't need to set the rest to identity.  if you only want the
        // result of outChannel then it doesn't matter.  if you do want the
        // other channels, you can set the matrix up before calling i guess
        /*
        if (outRow !=  0) { out[ 0] = 1; out[ 1] = 0; out[ 2] = 0; out[ 3] = 0; out[ 4] = 0; };
        if (outRow !=  5) { out[ 5] = 0; out[ 6] = 1; out[ 7] = 0; out[ 8] = 0; out[ 9] = 0; };
        if (outRow != 10) { out[10] = 0; out[11] = 0; out[12] = 1; out[13] = 0; out[14] = 0; };
        if (outRow != 15) { out[15] = 0; out[16] = 0; out[17] = 0; out[18] = 1; out[19] = 0; };
         */
    }

    /*
    //debug
    private static function copyMatRGBToGeo(c:Array, m:Matrix4x3):void
    {
        m.m00 = c[0];   m.m10 = c[1];   m.m20 = c[2];   m.m30 = c[4];
        m.m01 = c[5];   m.m11 = c[6];   m.m21 = c[7];   m.m31 = c[9];
        m.m02 = c[10];  m.m12 = c[11];  m.m22 = c[12];  m.m32 = c[14];
    }

    private static function copyMatGeoToRGB(m:Matrix4x3, c:Array):void
    {
        c[0]  = m.m00;  c[1]  = m.m10;  c[2]  = m.m20;  c[4]  = m.m30;
        c[5]  = m.m01;  c[6]  = m.m11;  c[7]  = m.m21;  c[9]  = m.m31;
        c[10] = m.m02;  c[11] = m.m12;  c[12] = m.m22;  c[14] = m.m32;
    }
 */

        // FACTORY METHODS: These produce invariant ColorMatrix objects
        // so there is no 'out' option - they always return a new object

        public static function createDesaturate():ColorMatrix
        {
            return new ColorMatrix([ 0.3334, 0.3333, 0.3333, 0, 0,
                                     0.3334, 0.3333, 0.3333, 0, 0,
                                     0.3334, 0.3333, 0.3333, 0, 0,
                                         0,       0,      0, 1, 0 ]);
        }

        public static function createLumaSRGB():ColorMatrix
        {
            return new ColorMatrix([ 0.2126, 0.7152, 0.0722, 0, 0,
                                     0.2126, 0.7152, 0.0722, 0, 0,
                                     0.2126, 0.7152, 0.0722, 0, 0,
                                          0,      0,      0, 1, 0 ]);
        }
    }
}
