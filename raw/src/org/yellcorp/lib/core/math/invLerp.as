package org.yellcorp.lib.core.math
{
/**
 * Inverse linear interpolation.  Returns the linear interpolant between
 * v0 and v1 required to return a given value.
 *
 * @param v0    The value at t = 0.
 * @param v1    The value at t = 1.
 * @param value The value for which to find the interpolant.
 *
 * @return   The interpolant.
 */
public function invLerp(v0:Number, v1:Number, value:Number):Number
{
    return (value - v0) / (v1 - v0);
}
}
