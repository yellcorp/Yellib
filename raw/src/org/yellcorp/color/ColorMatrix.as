package org.yellcorp.color
{

// note subclasses of Array must be dynamic, see Adobe docs
dynamic public class ColorMatrix extends Array
{
    public function ColorMatrix(initValues:Array = null)
    {
        super();

        if (!initValues)
        {
            identity();
        }
        else
        {
            copy(initValues);
        }
    }

    public function clone():ColorMatrix
    {
        return new ColorMatrix(this);
    }

    public function copy(from:Array):void
    {
        var i:int;
        var max:int = from.length;
        var v:Number;

        for (i = 0; i < 20; i++)
        {
            if (i < max && isFinite(v = from[i]))
            {
                this[i] = v;
            }
            else if (i % 6 == 0)
            {
                this[i] = 1;
            }
            else
            {
                this[i] = 0;
            }
        }
    }

    public function toString():String
    {
        var i:int;
        var str:String = "[ColorMatrix [";

        for (i = 0; i < 20; i++)
        {
            if (i > 0)
            {
                if (i % 5 == 0)
                {
                    str += "], [";
                }
                else
                {
                    str += ", ";
                }
            }
            str += this[i].toFixed(3);
        }

        str += "]]";

        return str;
    }

    public function identity():ColorMatrix
    {
        this[ 0] = 1; this[ 1] = 0; this[ 2] = 0; this[ 3] = 0; this[ 4] = 0;
        this[ 5] = 0; this[ 6] = 1; this[ 7] = 0; this[ 8] = 0; this[ 9] = 0;
        this[10] = 0; this[11] = 0; this[12] = 1; this[13] = 0; this[14] = 0;
        this[15] = 0; this[16] = 0; this[17] = 0; this[18] = 1; this[19] = 0;

        return this;
    }

    public function clearNonDiagonalAffine():ColorMatrix
    {
        var i:int;

        for (i = 0; i < 20; i++)
        {
            if (i % 6 != 0 && i % 5 != 4)
                this[i] = 0;
        }

        return this;
    }

    public function setDiagonalOffset(redMult:Number, greenMult:Number, blueMult:Number, alphaMult:Number,
                                      redOffset:Number, greenOffset:Number, blueOffset:Number, alphaOffset:Number):ColorMatrix
    {
        this[0] = redMult;
        this[6] = greenMult;
        this[12] = blueMult;
        this[18] = alphaMult;

        this[4] = redOffset;
        this[9] = greenOffset;
        this[14] = blueOffset;
        this[19] = alphaOffset;

        return this;
    }

    // there is no 'setter' version of this function
    // as you need to have a copy of both arrays to
    // calculate the multiplied matrix, and initing
    // local var copies of the whole array is probably
    // not worth the effort
    public function multiply(m:Array):ColorMatrix
    {
        var result:ColorMatrix = new ColorMatrix();

        result[0] = this[0] * m[0] + this[1] * m[5] + this[2] * m[10] + this[3] * m[15];
        result[1] = this[0] * m[1] + this[1] * m[6] + this[2] * m[11] + this[3] * m[16];
        result[2] = this[0] * m[2] + this[1] * m[7] + this[2] * m[12] + this[3] * m[17];
        result[3] = this[0] * m[3] + this[1] * m[8] + this[2] * m[13] + this[3] * m[18];
        result[4] = this[0] * m[4] + this[1] * m[9] + this[2] * m[14] + this[3] * m[19] + this[4];

        result[5] = this[5] * m[0] + this[6] * m[5] + this[7] * m[10] + this[8] * m[15];
        result[6] = this[5] * m[1] + this[6] * m[6] + this[7] * m[11] + this[8] * m[16];
        result[7] = this[5] * m[2] + this[6] * m[7] + this[7] * m[12] + this[8] * m[17];
        result[8] = this[5] * m[3] + this[6] * m[8] + this[7] * m[13] + this[8] * m[18];
        result[9] = this[5] * m[4] + this[6] * m[9] + this[7] * m[14] + this[8] * m[19] + this[9];

        result[10] = this[10] * m[0] + this[11] * m[5] + this[12] * m[10] + this[13] * m[15];
        result[11] = this[10] * m[1] + this[11] * m[6] + this[12] * m[11] + this[13] * m[16];
        result[12] = this[10] * m[2] + this[11] * m[7] + this[12] * m[12] + this[13] * m[17];
        result[13] = this[10] * m[3] + this[11] * m[8] + this[12] * m[13] + this[13] * m[18];
        result[14] = this[10] * m[4] + this[11] * m[9] + this[12] * m[14] + this[13] * m[19] + this[14];

        result[15] = this[15] * m[0] + this[16] * m[5] + this[17] * m[10] + this[18] * m[15];
        result[16] = this[15] * m[1] + this[16] * m[6] + this[17] * m[11] + this[18] * m[16];
        result[17] = this[15] * m[2] + this[16] * m[7] + this[17] * m[12] + this[18] * m[17];
        result[18] = this[15] * m[3] + this[16] * m[8] + this[17] * m[13] + this[18] * m[18];
        result[19] = this[15] * m[4] + this[16] * m[9] + this[17] * m[14] + this[18] * m[19] + this[19];

        return result;
    }

    // same as multiply but with the order swapped.
    // ColorMatrixFilter works with vertical colour vectors, unlike
    // transform vectors which are horizontal, multiplying two together
    // applies the effect of the right argument 'before' the left one.
    // this version allows the order to be specified with order and wording
    // matching the flash api
    public function concatenate(m:Array):ColorMatrix
    {
        var result:ColorMatrix = new ColorMatrix();

        result[0] = m[0] * this[0] + m[1] * this[5] + m[2] * this[10] + m[3] * this[15];
        result[1] = m[0] * this[1] + m[1] * this[6] + m[2] * this[11] + m[3] * this[16];
        result[2] = m[0] * this[2] + m[1] * this[7] + m[2] * this[12] + m[3] * this[17];
        result[3] = m[0] * this[3] + m[1] * this[8] + m[2] * this[13] + m[3] * this[18];
        result[4] = m[0] * this[4] + m[1] * this[9] + m[2] * this[14] + m[3] * this[19] + m[4];

        result[5] = m[5] * this[0] + m[6] * this[5] + m[7] * this[10] + m[8] * this[15];
        result[6] = m[5] * this[1] + m[6] * this[6] + m[7] * this[11] + m[8] * this[16];
        result[7] = m[5] * this[2] + m[6] * this[7] + m[7] * this[12] + m[8] * this[17];
        result[8] = m[5] * this[3] + m[6] * this[8] + m[7] * this[13] + m[8] * this[18];
        result[9] = m[5] * this[4] + m[6] * this[9] + m[7] * this[14] + m[8] * this[19] + m[9];

        result[10] = m[10] * this[0] + m[11] * this[5] + m[12] * this[10] + m[13] * this[15];
        result[11] = m[10] * this[1] + m[11] * this[6] + m[12] * this[11] + m[13] * this[16];
        result[12] = m[10] * this[2] + m[11] * this[7] + m[12] * this[12] + m[13] * this[17];
        result[13] = m[10] * this[3] + m[11] * this[8] + m[12] * this[13] + m[13] * this[18];
        result[14] = m[10] * this[4] + m[11] * this[9] + m[12] * this[14] + m[13] * this[19] + m[14];

        result[15] = m[15] * this[0] + m[16] * this[5] + m[17] * this[10] + m[18] * this[15];
        result[16] = m[15] * this[1] + m[16] * this[6] + m[17] * this[11] + m[18] * this[16];
        result[17] = m[15] * this[2] + m[16] * this[7] + m[17] * this[12] + m[18] * this[17];
        result[18] = m[15] * this[3] + m[16] * this[8] + m[17] * this[13] + m[18] * this[18];
        result[19] = m[15] * this[4] + m[16] * this[9] + m[17] * this[14] + m[18] * this[19] + m[19];

        return result;
    }

    /*
//        debug only
        public function rgbDet():Number
        {
            //  0  1  2
            //  5  6  7
            // 10 11 12

             return this[0] * (this[6] * this[12] - this[7] * this[11]) +
                   this[1] * (this[7] * this[10] - this[5] * this[12]) +
                   this[2] * (this[5] * this[11] - this[6] * this[10]);
        }
         */

        public function inverse():ColorMatrix
        {
            /* Gauss-Jordan elimination
             *
             * http://ceee.rice.edu/Books/CS/chapter2/linear42.html
             * http://ceee.rice.edu/Books/CS/chapter2/linear43.html
             * http://ceee.rice.edu/Books/CS/chapter2/linear44.html
             * http://ceee.rice.edu/Books/CS/chapter2/linear45.html
             * http://ceee.rice.edu/Books/CS/chapter2/linear46.html
             *
             * Highly subject to rounding error but who cares
             */

            var input:ColorMatrix = clone();
            var inv:ColorMatrix = new ColorMatrix();

            var diag:int = 0;
            var row:int = 0;

            for (diag = 0; diag < 4; diag++)
            {
                if (input[diag*6] == 0 && !swapNonZero(diag, input, inv))
                    return null;

                for (row = diag + 1; row < 4; row++)
                    zeroRow(row, diag, input, inv);
            }

            for (row = 0; row < 4; row++)
                zeroEnd(row, input, inv);

            for (diag = 3; diag >= 0; diag--)
            {
                for (row = diag - 1; row >= 0; row--)
                    zeroRow(row, diag, input, inv);
            }

            for (diag = 0; diag < 4; diag++)
                scaleRow(diag, input, inv);

            return inv;
        }

        public static function lerp(a:Array, b:Array, t:Number, out:ColorMatrix = null):ColorMatrix
        {
            var i:int;
            if (!out) out = new ColorMatrix();

            for (i = 0; i < 20; i++)
                out[i] = a[i] + t * (b[i] - a[i]);

            return out;
        }

        // Helper functions for Gauss-Jordan elimination

        private static function zeroRow(row:int, diag:int, input:Array, output:Array):void
        {
            var rowStart:int = row * 5;
            var diagStart:int = diag * 5;
            var factor:Number = -input[rowStart + diag];
            var iCol:int;

            if (factor == 0) return;

            factor /= input[diagStart + diag];

            for (iCol = 0; iCol < 5; iCol++)
            {
                input[rowStart + iCol] += input[diagStart + iCol] * factor;
                output[rowStart + iCol] += output[diagStart + iCol] * factor;
            }
        }

        private static function zeroEnd(row:int, input:Array, output:Array):void
        {
            var rowStart:int = row * 5;
            var factor:Number = -input[rowStart + 4];

            if (factor == 0) return;

            input[rowStart + 4] = 0;
            output[rowStart + 4] += factor;
        }

        private static function scaleRow(row:int, input:Array, output:Array):void
        {
            var rowStart:int = row * 5;
            var factor:Number = 1 / input[row * 6];
            var iCol:int;

            for (iCol = 0; iCol < 5; iCol++)
            {
                output[rowStart + iCol] *= factor;
            }
        }

        private static function swapNonZero(diag:int, input:Array, output:Array):Boolean
        {
            var iRow:int;

            var baseA:int = diag * 5;
            var baseB:int;

            for (iRow = diag + 1; iRow < 4; iRow++)
            {
                baseB = iRow * 5;
                if (input[baseB + diag] != 0)
                {
                    swapRows(input, baseA, baseB);
                    swapRows(output, baseA, baseB);
                    return true;
                }
            }

            return false;
        }

        private static function swapRows(a:Array, baseA:int, baseB:int):void
        {
            var i:int;
            var temp:Number;

            for (i = 0; i < 5; i++)
            {
                temp = a[baseA + i];
                a[baseA + i] = a[baseB + i];
                a[baseB + i] = temp;
            }
        }
    }
}
