package org.yellcorp.lib.core.math
{
/**
 * Calculates cubic interpolation between two sample values, influenced
 * by two external sample values, based on
 * an interpolant <code>t</code> between 0 and 1.  When
 * <code>t</code> is 0, <code>v1</code> is returned.  When
 * <code>t</code> is 1, <code>v2</code> is returned.  <code>t</code>
 * is not clamped to a [0, 1] range.
 *
 * @param v0 The value at t = -1.
 * @param v1 The value at t = 0.
 * @param v2 The value at t = 1.
 * @param v3 The value at t = 2.
 * @param t  Interpolant.
 *
 * @return   The interpolated value.
 */
public function clerp(v0:Number, v1:Number, v2:Number, v3:Number, t:Number):Number
{
    var p:Number = (v3 - v2) - (v0 - v1);
    var q:Number = (v0 - v1) - p;
    var r:Number = v2 - v0;
    var s:Number = v1;

    return ((p * t + q) * t + r) * t + s;
}
}
