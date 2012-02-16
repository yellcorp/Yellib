package org.yellcorp.lib.core.math
{
/**
 * Maps a number from one range to another.
 *
 * @example The following code takes 100 on the interval [0, 200], and
 * outputs the equivalent value on the interval [-1, 1].  The
 * result is 0 because 100 is halfway between 0 and 200, and 0 is
 * halfway between -1 and 1.
 * <listing version="3.0">
 * linearMap(100, 0, 200, -1, 1);
 * // returned value is 0
 * </listing>
 *
 * @param    value The value on the input interval
 * @param    a0    The start of the input interval
 * @param    a1    The end of the input interval
 * @param    b0    The start of the output interval
 * @param    b1    The end of the output interval
 * @return         The input value mapped to the output interval.
 */
public function linearMap(value:Number, a0:Number, a1:Number, b0:Number, b1:Number):Number
{
    return b0 + (b1 - b0) * (value - a0) / (a1 - a0);
}
}
