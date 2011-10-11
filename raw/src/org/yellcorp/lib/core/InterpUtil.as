package org.yellcorp.lib.core
{
public class InterpUtil
{
    /**
     * Calculates linear interpolation between a minimum and maximum value, based on
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
    public static function lerp(v0:Number, v1:Number, t:Number):Number
    {
        return v0 + t * (v1 - v0);
    }

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
    public static function invLerp(v0:Number, v1:Number, value:Number):Number
    {
        return (value - v0) / (v1 - v0);
    }

    /**
     * Given a number on input range, returns that number scaled to the
     * same relative quantity on an output range.  Numbers are not clamped
     * to ranges.
     *
     * @example The following code takes 100 on an input range from 0 to
     * 200, and outputs the equivalent value on a scale from -1 to 1.  The
     * result is 0 because 100 is halfway between 0 and 200, and 0 is
     * halfway between -1 and 1.
     * <listing version="3.0">
     * InterpUtil.lerpRange(100, 0, 200, -1, 1);
     * // returned value is 0
     * </listing>
     *
     * @param    inVal    The input value to be scaled
     * @param    inMin    The input lower range
     * @param    inMax    The input higher range
     * @param    outMin    The output lower range
     * @param    outMax    The output higher range
     * @return            The input value scaled to the output range.
     */
    public static function lerpRange(inVal:Number, inMin:Number, inMax:Number, outMin:Number, outMax:Number):Number
    {
        var outVal:Number;
        outVal = outMin + (outMax - outMin) * (inVal - inMin) / (inMax - inMin);
        return outVal;
    }

    /**
     * Linearly interpolates a value in two dimensions.
     *
     * @param v00 The value at (0, 0).
     * @param v01 The value at (0, 1).
     * @param v10 The value at (1, 0).
     * @param v11 The value at (1, 1).
     * @param x   X interpolant.
     * @param y   Y interpolant.
     *
     * @return   The interpolated value.
     */
    public static function lerp2d(v00:Number, v01:Number,
                                  v10:Number, v11:Number,
                                  x:Number, y:Number):Number
    {
        var v0x:Number = v00 + x * (v01 - v00);
        var v1x:Number = v10 + x * (v11 - v10);

        return v0x + y * (v1x - v0x);
    }

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
    public static function clerp(v0:Number, v1:Number, v2:Number, v3:Number, t:Number):Number
    {
        var P:Number = (v3 - v2) - (v0 - v1);
        var Q:Number = (v0 - v1) - P;
        var R:Number = v2 - v0;
        var S:Number = v1;

        return ((P * t + Q) * t + R) * t + S;
    }

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
    public static function hermite(v0:Number, d0:Number, v1:Number, d1:Number, t:Number):Number
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
}
