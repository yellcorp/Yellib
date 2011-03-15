package org.yellcorp.lib.geom
{
/**
 * Matrix with 4 rows, 3 columns, with the 4th column
 * always assumed to be [ 0 0 0 1 ]T
 *
 * Translation is in the last row.  This implies:
 *
 * Vectors are considered ROWs
 *
 * Matrix multiplication operations affect 'past' ops, not 'future'
 *         e.g. to create a rotation about [x y z], first rotate,
 *         THEN translate to [x y z], not vice versa
 *
 * Translation is a simple add to the last row
 *
 * In mathematical notation, the vector is on the left and the
 * matrix is on the right: v' = vM
 *
 * Like:    Direct3D, flash.geom.Matrix
 * Unlike:  OpenGL, Mac OSX Quartz, papervision
 */
public class Matrix4x3
{
    public var m00:Number = 1, m01:Number = 0, m02:Number = 0;
    public var m10:Number = 0, m11:Number = 1, m12:Number = 0;
    public var m20:Number = 0, m21:Number = 0, m22:Number = 1;
    public var m30:Number = 0, m31:Number = 0, m32:Number = 0;

    public function Matrix4x3() { }

    public function clone():Matrix4x3
    {
        var newMatrix:Matrix4x3 = new Matrix4x3();
        copy(this, newMatrix);
        return newMatrix;
    }

    public static function copy(source:Matrix4x3, dest:Matrix4x3):void
    {
        dest.m00 = source.m00;
        dest.m01 = source.m01;
        dest.m02 = source.m02;

        dest.m10 = source.m10;
        dest.m11 = source.m11;
        dest.m12 = source.m12;

        dest.m20 = source.m20;
        dest.m21 = source.m21;
        dest.m22 = source.m22;

        dest.m30 = source.m30;
        dest.m31 = source.m31;
        dest.m32 = source.m32;
    }

    public function identity():void
    {
        m00 =
        m11 =
        m22 = 1;

        m01 =
        m02 =
        m10 =

        m12 =
        m20 =
        m21 =

        m30 =
        m31 =
        m32 = 0;
    }

    public function toString(p:uint = 4):String
    {
        return "[ " +
               "[ " + m00.toFixed(p) + ", " + m01.toFixed(p) + ", " + m02.toFixed(p) + " ], " +
               "[ " + m10.toFixed(p) + ", " + m11.toFixed(p) + ", " + m12.toFixed(p) + " ], " +
               "[ " + m20.toFixed(p) + ", " + m21.toFixed(p) + ", " + m22.toFixed(p) + " ], " +
               "[ " + m30.toFixed(p) + ", " + m31.toFixed(p) + ", " + m32.toFixed(p) + " ] " + "]";
    }

    // transforms

    public function translate(x:Number, y:Number, z:Number):void
    {
        m30 += x;
        m31 += y;
        m32 += z;
    }

    public function scale(s:Number):void
    {
        scale3(s, s, s);
    }

    public function scale3(x:Number, y:Number, z:Number):void
    {
        m00 *= x;
        m10 *= x;
        m20 *= x;
        m30 *= x;

        m01 *= y;
        m11 *= y;
        m21 *= y;
        m31 *= y;

        m02 *= z;
        m12 *= z;
        m22 *= z;
        m32 *= z;
    }

    public function rotateA(radians:Number, ax:Number, ay:Number, az:Number):void
    {
        var c:Number = Math.cos(radians);
        var s:Number = Math.sin(radians);
        var ic:Number = 1 - c;

        var sax:Number = s * ax;
        var say:Number = s * ay;
        var saz:Number = s * az;

        var icax:Number = ic * ax;
        var icay:Number = ic * ay;
        var icaz:Number = ic * az;

        multiply12(
            icax * ax + c,
            icax * ay - saz,
            icax * az + say,

            icay * ax + saz,
            icay * ay + c,
            icay * az - sax,

            icaz * ax - say,
            icaz * ay + sax,
            icaz * az + c,

            0, 0, 0
        );
    }

    public function rotateX(radians:Number):void
    {
        var cos:Number = Math.cos(radians);
        var sin:Number = Math.sin(radians);

        multiply12(   1,    0,    0,
                      0,  cos,  sin,
                      0, -sin,  cos,
                      0,    0,    0);
    }

    public function rotateY(radians:Number):void
    {
        var cos:Number = Math.cos(radians);
        var sin:Number = Math.sin(radians);

        multiply12( cos,    0, -sin,
                      0,    1,    0,
                    sin,    0,  cos,
                      0,    0,    0);
    }

    public function rotateZ(radians:Number):void
    {
        var cos:Number = Math.cos(radians);
        var sin:Number = Math.sin(radians);

        multiply12( cos,  sin,    0,
                   -sin,  cos,    0,
                      0,    0,    1,
                      0,    0,    0);
    }

    public function multiply(b:Matrix4x3):void
    {
        var r00:Number = m00 * b.m00 + m01 * b.m10 + m02 * b.m20;
        var r01:Number = m00 * b.m01 + m01 * b.m11 + m02 * b.m21;
        var r02:Number = m00 * b.m02 + m01 * b.m12 + m02 * b.m22;

        var r10:Number = m10 * b.m00 + m11 * b.m10 + m12 * b.m20;
        var r11:Number = m10 * b.m01 + m11 * b.m11 + m12 * b.m21;
        var r12:Number = m10 * b.m02 + m11 * b.m12 + m12 * b.m22;

        var r20:Number = m20 * b.m00 + m21 * b.m10 + m22 * b.m20;
        var r21:Number = m20 * b.m01 + m21 * b.m11 + m22 * b.m21;
        var r22:Number = m20 * b.m02 + m21 * b.m12 + m22 * b.m22;

        var r30:Number = m30 * b.m00 + m31 * b.m10 + m32 * b.m20 + b.m30;
        var r31:Number = m30 * b.m01 + m31 * b.m11 + m32 * b.m21 + b.m31;
        var r32:Number = m30 * b.m02 + m31 * b.m12 + m32 * b.m22 + b.m32;

        m00 = r00;
        m01 = r01;
        m02 = r02;

        m10 = r10;
        m11 = r11;
        m12 = r12;

        m20 = r20;
        m21 = r21;
        m22 = r22;

        m30 = r30;
        m31 = r31;
        m32 = r32;
    }

    public function multiply12(a00:Number, a01:Number, a02:Number,
                               a10:Number, a11:Number, a12:Number,
                               a20:Number, a21:Number, a22:Number,
                               a30:Number, a31:Number, a32:Number):void
    {
        var r00:Number = m00 * a00 + m01 * a10 + m02 * a20;
        var r01:Number = m00 * a01 + m01 * a11 + m02 * a21;
        var r02:Number = m00 * a02 + m01 * a12 + m02 * a22;

        var r10:Number = m10 * a00 + m11 * a10 + m12 * a20;
        var r11:Number = m10 * a01 + m11 * a11 + m12 * a21;
        var r12:Number = m10 * a02 + m11 * a12 + m12 * a22;

        var r20:Number = m20 * a00 + m21 * a10 + m22 * a20;
        var r21:Number = m20 * a01 + m21 * a11 + m22 * a21;
        var r22:Number = m20 * a02 + m21 * a12 + m22 * a22;

        var r30:Number = m30 * a00 + m31 * a10 + m32 * a20 + a30;
        var r31:Number = m30 * a01 + m31 * a11 + m32 * a21 + a31;
        var r32:Number = m30 * a02 + m31 * a12 + m32 * a22 + a32;

        m00 = r00;
        m01 = r01;
        m02 = r02;

        m10 = r10;
        m11 = r11;
        m12 = r12;

        m20 = r20;
        m21 = r21;
        m22 = r22;

        m30 = r30;
        m31 = r31;
        m32 = r32;
    }

    public function multiplyV(inVector:Vector3, outVector:Vector3):void
    {
        // i guess this means they're row vectors
        outVector.x = inVector.x * m00 +
                      inVector.y * m10 +
                      inVector.z * m20 + m30;

        outVector.y = inVector.x * m01 +
                      inVector.y * m11 +
                      inVector.z * m21 + m31;

        outVector.z = inVector.x * m02 +
                      inVector.y * m12 +
                      inVector.z * m22 + m32;
    }

    public function invert():void
    {
        var invDet:Number = 1 / det();

        if (!isFinite(invDet))
        {
            invalidate();
            return;
        }

        var c00:Number = m00;
        var c01:Number = m01;
        var c02:Number = m02;

        var c10:Number = m10;
        var c11:Number = m11;
        var c12:Number = m12;

        var c20:Number = m20;
        var c21:Number = m21;
        var c22:Number = m22;

        var c30:Number = m30;
        var c31:Number = m31;
        var c32:Number = m32;

        m00 = (c11 * c22 - c12 * c21) * invDet;
        m01 = (c02 * c21 - c01 * c22) * invDet;
        m02 = (c01 * c12 - c02 * c11) * invDet;

        m10 = (c12 * c20 - c10 * c22) * invDet;
        m11 = (c00 * c22 - c02 * c20) * invDet;
        m12 = (c02 * c10 - c00 * c12) * invDet;

        m20 = (c10 * c21 - c11 * c20) * invDet;
        m21 = (c01 * c20 - c00 * c21) * invDet;
        m22 = (c00 * c11 - c01 * c10) * invDet;

        m30 = -(c30 * m00 + c31 * m10 + c32 * m20);
        m31 = -(c30 * m01 + c31 * m11 + c32 * m21);
        m32 = -(c30 * m02 + c31 * m12 + c32 * m22);
    }

    public function det():Number
    {
        return m00 * (m11 * m22 - m12 * m21) +
               m01 * (m12 * m20 - m10 * m22) +
               m02 * (m10 * m21 - m11 * m20);
    }

    public function isfinite():Boolean
    {
        return isFinite(m00) && isFinite(m01) && isFinite(m02) &&
               isFinite(m10) && isFinite(m11) && isFinite(m12) &&
               isFinite(m20) && isFinite(m21) && isFinite(m22) &&
               isFinite(m30) && isFinite(m31) && isFinite(m32);
    }

    private function invalidate():void
    {
        m00 = m01 = m02 =
        m10 = m11 = m12 =
        m20 = m21 = m22 =
        m30 = m31 = m32 = Number.NaN;
    }
}
}
