package org.yellcorp.color
{
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
