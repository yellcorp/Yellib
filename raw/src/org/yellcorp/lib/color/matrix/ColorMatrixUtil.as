package org.yellcorp.lib.color.matrix
{
import flash.geom.ColorTransform;


public class ColorMatrixUtil
{
    public static const MAX:int = 20;
    public static const WIDTH:int = 5;
    public static const EPSILON:Number = 1 / 512;

    public static function makeIdentity(cm:Array = null):Array
    {
        if (!cm) cm = new Array(MAX);

        setDiagonal(cm, 1, 1, 1, 1);
        setOffset(cm, 0, 0, 0, 0);
        clearCrossChannel(cm);

        return cm;
    }

    public static function toString(colorMatrix:Array):String
    {
        var i:int;
        var str:String = "[ColorMatrix [";

        for (i = 0; i < MAX; i++)
        {
            if (i > 0)
            {
                if (i % WIDTH == 0)
                {
                    str += "], [";
                }
                else
                {
                    str += ", ";
                }
            }
            str += colorMatrix[i].toFixed(3);
        }

        str += "]]";

        return str;
    }

    public static function setDiagonal(cm:Array, r:Number, g:Number, b:Number, a:Number = Number.NaN):Array
    {
        cm[0] = r;
        cm[6] = g;
        cm[12] = b;

        if (isFinite(a)) cm[18] = a;

        return cm;
    }

    public static function setOffset(cm:Array, r:Number, g:Number, b:Number, a:Number = Number.NaN):Array
    {
        cm[4] = r;
        cm[9] = g;
        cm[14] = b;

        if (isFinite(a)) cm[19] = a;

        return cm;
    }

    public static function clearCrossChannel(cm:Array):void
    {
                 cm[ 1] = cm[ 2] = cm[ 3] =
        cm[ 5] =          cm[ 7] = cm[ 8] =
        cm[10] = cm[11] =          cm[13] =
        cm[15] = cm[16] = cm[17] =          0;
    }

    public static function setDefaultAlpha(cm:Array):void
    {
        cm[15] = cm[16] = cm[17] = cm[19] = 0;
        cm[18] = 1;
    }

    public static function fromColorTransform(ct:ColorTransform, out:Array = null):Array
    {
        if (!out) out = [ ];

        ColorMatrixUtil.setDiagonal(out,
            ct.redMultiplier,
            ct.greenMultiplier,
            ct.blueMultiplier,
            ct.alphaMultiplier);

        ColorMatrixUtil.setOffset(out,
            ct.redOffset,
            ct.greenOffset,
            ct.blueOffset,
            ct.alphaOffset);

        ColorMatrixUtil.clearCrossChannel(out);

        return out;
    }

    public static function multiply(a:Array, b:Array, out:Array = null):Array
    {
        if (!out)
        {
            out = [ ];
        }
        else
        {
            if (a === out) a = a.concat();
            if (b === out) b = b.concat();
        }

        out[0] = a[0] * b[0] + a[1] * b[5] + a[2] * b[10] + a[3] * b[15];
        out[1] = a[0] * b[1] + a[1] * b[6] + a[2] * b[11] + a[3] * b[16];
        out[2] = a[0] * b[2] + a[1] * b[7] + a[2] * b[12] + a[3] * b[17];
        out[3] = a[0] * b[3] + a[1] * b[8] + a[2] * b[13] + a[3] * b[18];
        out[4] = a[0] * b[4] + a[1] * b[9] + a[2] * b[14] + a[3] * b[19] + a[4];

        out[5] = a[5] * b[0] + a[6] * b[5] + a[7] * b[10] + a[8] * b[15];
        out[6] = a[5] * b[1] + a[6] * b[6] + a[7] * b[11] + a[8] * b[16];
        out[7] = a[5] * b[2] + a[6] * b[7] + a[7] * b[12] + a[8] * b[17];
        out[8] = a[5] * b[3] + a[6] * b[8] + a[7] * b[13] + a[8] * b[18];
        out[9] = a[5] * b[4] + a[6] * b[9] + a[7] * b[14] + a[8] * b[19] + a[9];

        out[10] = a[10] * b[0] + a[11] * b[5] + a[12] * b[10] + a[13] * b[15];
        out[11] = a[10] * b[1] + a[11] * b[6] + a[12] * b[11] + a[13] * b[16];
        out[12] = a[10] * b[2] + a[11] * b[7] + a[12] * b[12] + a[13] * b[17];
        out[13] = a[10] * b[3] + a[11] * b[8] + a[12] * b[13] + a[13] * b[18];
        out[14] = a[10] * b[4] + a[11] * b[9] + a[12] * b[14] + a[13] * b[19] + a[14];

        out[15] = a[15] * b[0] + a[16] * b[5] + a[17] * b[10] + a[18] * b[15];
        out[16] = a[15] * b[1] + a[16] * b[6] + a[17] * b[11] + a[18] * b[16];
        out[17] = a[15] * b[2] + a[16] * b[7] + a[17] * b[12] + a[18] * b[17];
        out[18] = a[15] * b[3] + a[16] * b[8] + a[17] * b[13] + a[18] * b[18];
        out[19] = a[15] * b[4] + a[16] * b[9] + a[17] * b[14] + a[18] * b[19] + a[19];

        return out;
    }

    // same as multiply but with the order swapped.
    // ColorMatrixFilter works with vertical colour vectors, unlike
    // transform vectors which are horizontal, multiplying two together
    // applies the effect of the right argument 'before' the left one.
    // this version allows the order to be specified with order and wording
    // matching the flash api
    public static function concatenate(a:Array, b:Array, out:Array = null):Array
    {
        return multiply(b, a, out);
    }

    public static function lerp(a:Array, b:Array, t:Number, out:Array = null):Array
    {
        var i:int;
        if (!out) out = [ ];

        for (i = 0; i < MAX; i++)
            out[i] = a[i] + t * (b[i] - a[i]);

        return out;
    }

    public static function isfinite(m:Array):Boolean
    {
        var e:Number;
        for (var i:int = 0; i < MAX; i++)
        {
            e = m[i];
            if (!isFinite(e))
                return false;
        }
        return true;
    }

    /**
     * Returns true if the color matrix cm is representable as a
     * ColorTransform. This is true if a color matrix has zeros everywhere
     * outside the diagonal and the last column.
     */
    public static function isColorTransform(cm:Array):Boolean
    {
        // skip 0, 18 and 19
        for (var i:int = 1; i < 18; i++)
        {
            if (i % 6 != 0  &&  i % 5 != 4  // skip diagonal and last col
                && (cm[i] >= EPSILON || cm[i] < -EPSILON))
            {
                return false;
            }
        }
        return true;
    }

    public static function invert(m:Array, out:Array = null):Array
    {
        // uses a fairly dumb guass-jordan algorithm to transform
        // the augmented matrix into RREF, with float roundoff everywhere.
        // probably a better way but i don't know it. using determinants?
        // some kind of decomposition? does anyone even invert colormatrices?
        if (!out)
        {
            out = new Array(MAX);
        }
        makeIdentity(out);
        rref(m.concat(), out);
        return out;
    }

    // Helper functions for Gauss-Jordan elimination
    // in each of these functions, the total augmented matrix remains
    // in two separate arrays: orig and aug. orig starts out as the
    // original matrix, aug start out as the identity. at the end
    // of the algorithm, aug contains the inverse.

    // each row operation is applied to both Arrays

    private static function rref(orig:Array, aug:Array):void
    {
        var row:int;
        var col:int;

        // [  0  1  2  3  4 ] [ 1 0 0 0 0 ]
        // [  5  6  7  8  9 ] [ 0 1 0 0 0 ]
        // [ 10 11 12 13 14 ] [ 0 0 1 0 0 ]
        // [ 15 16 17 18 19 ] [ 0 0 0 1 0 ]
        // [  0  0  0  0  1 ] [ 0 0 0 0 1 ]

        for (row = 0, col = 0; row < MAX; row += WIDTH, col++)
        {
            if (orig[row + col] == 0 &&
                !moveNonZeroToDiagonal(orig, aug, row, col))
            {
                // zero column: matrix is singular
                aug[0] = Number.NaN;
                return;
            }
            zeroRows(orig, aug, row, col, false);
        }

        // by this point we have upper triangular matrix of the form:
        // [ a b c d e ]
        // [ 0 f g h i ]
        // [ 0 0 j k l ]
        // [ 0 0 0 m n ]
        // [ 0 0 0 0 1 ]

        // cheap way to zero out the last column, given that the bottom
        // row is an implicit [ 0 0 0 0 1 ]
        zeroOffsets(orig, aug);

        // now run backwards and up from row/column 3
        for (row = 3 * WIDTH, col = 3; row >= 0; row -= WIDTH, col--)
        {
            if (row > 0)
            {
                zeroRows(orig, aug, row, col, true);
            }
            divideRow(aug, row, orig[row + col]);
        }
    }

    private static function moveNonZeroToDiagonal(orig:Array, aug:Array, row:int, col:int):Boolean
    {
        for (var searchRow:int = row + WIDTH; searchRow < MAX; searchRow += WIDTH)
        {
            if (orig[searchRow + col] != 0)
            {
                swapRows(orig, row, searchRow);
                swapRows(aug, row, searchRow);
                return true;
            }
        }
        return false;
    }

    private static function zeroRows(orig:Array, aug:Array, refRow:int, col:int, up:Boolean):void
    {
        var rowStep:int = up ? -WIDTH : WIDTH;
        var pivot:Number = orig[refRow + col];
        var eliminate:Number;

        for (var row:int = refRow + rowStep; row >= 0 && row < MAX; row += rowStep)
        {
            eliminate = orig[row + col];
            if (eliminate != 0)
            {
                addRowMultiple(orig, aug, refRow, row, -eliminate / pivot);
            }
        }
    }

    private static function swapRows(m:Array, rowA:int, rowB:int):void
    {
        var temp:Number;

        for (var i:int = 0; i < WIDTH; i++)
        {
            temp = m[rowA + i];
            m[rowA + i] = m[rowB + i];
            m[rowB + i] = temp;
        }
    }

    private static function addRowMultiple(orig:Array, aug:Array, fromRow:int, toRow:int, factor:Number):void
    {
        for (var col:int = 0; col < WIDTH; col++)
        {
            orig[toRow + col] += orig[fromRow + col] * factor;
            aug[toRow + col]  += aug[fromRow + col]  * factor;
        }
    }

    private static function divideRow(aug:Array, row:int, factor:Number):void
    {
        for (var col:int = 0; col < WIDTH; col++)
        {
            aug[row + col] /= factor;
        }
    }

    private static function zeroOffsets(orig:Array, aug:Array):void
    {
        for (var i:int = WIDTH - 1; i < MAX; i += WIDTH)
        {
            aug[i] -= orig[i];
            orig[i] = 0;
        }
    }
}
}
