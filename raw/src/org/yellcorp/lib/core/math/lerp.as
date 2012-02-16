package org.yellcorp.lib.core.math
{
/**
 * Calculates linear interpolation between two values, based on
 * an interpolant <code>t</code> between 0 and 1.  When
 * <code>t</code> is 0, <code>v0</code> is returned.  When
 * <code>t</code> is 1, <code>v1</code> is returned.  <code>t</code>
 * is not clamped to a [0, 1] range.
 *
 * @param v0  The value at t = 0.
 * @param v1  The value at t = 1.
 * @param t   Interpolant.
 *
 * @return   The interpolated value.
 */
public function lerp(v0:Number, v1:Number, t:Number):Number
{
    return v0 + t * (v1 - v0);
}
}
