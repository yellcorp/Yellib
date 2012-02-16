package org.yellcorp.lib.core.math
{
/**
 * Clamp a number to a range.
 *
 * @param val  The value to clamp.
 * @param min  The lower bound of the range.  If <code>val</code> is less than
 *             <code>min</code>, <code>min</code> will be returned.  Pass
 *             <code>NaN</code> if the range has no lower bound.
 * @param max  The upper bound of the range.  If <code>val</code> is greater
 *             than <code>max</code>, <code>max</code> will be returned.  Pass
 *             <code>NaN</code> if the range has no upper bound.
 * @return  The clamped value.
 */
public function clamp(val:Number, min:Number, max:Number):Number
{
    return val < min ? min : (val > max ? max : val);
}
}
