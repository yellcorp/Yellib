package org.yellcorp.lib.core.math
{
/**
 * Calculates hermite interpolation between two sample values, each
 * also having a derivative.
 *
 * @param v0 The value at t = 0.
 * @param d0 The derivative at t = 0.
 * @param v1 The value at t = 1.
 * @param d1 The derivative at t = 1.
 * @param t  The interpolant.
 *
 * @return   The interpolated value.
 */
public function hermite(v0:Number, d0:Number, v1:Number, d1:Number, t:Number):Number
{
    var t2:Number = t * t;
    var t3:Number = t * t * t;

    var valueBasis:Number = 2 * t3 - 3 * t2;

    return v0 * (valueBasis + 1) +
           v1 * (-valueBasis) +
           d0 * (t3 - 2 * t2 + t) +
           d1 * (t3 - t2);
}
}
