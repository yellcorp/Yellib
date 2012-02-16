package org.yellcorp.lib.core.math
{
/**
 * Linearly interpolates a value in two dimensions.
 *
 * @param v00 The value at x=0, y=0.
 * @param v10 The value at x=1, y=0.
 * @param v01 The value at x=0, y=1.
 * @param v11 The value at x=1, y=1.
 * @param x   X interpolant.
 * @param y   Y interpolant.
 *
 * @return   The interpolated value.
 */
public function lerp2d(v00:Number, v10:Number,
                              v01:Number, v11:Number,
                              x:Number, y:Number):Number
{
    var vx0:Number = v00 + x * (v10 - v00);
    var vx1:Number = v01 + x * (v11 - v01);

    return vx0 + y * (vx1 - vx0);
}
}
