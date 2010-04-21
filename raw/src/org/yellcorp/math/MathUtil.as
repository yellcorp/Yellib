package org.yellcorp.math
{
public class MathUtil
{
    /**
     * Constant factor representing PI / 180, the number of radians in a
     * degree, approximately 0.0174532.  Multiply a quantity in degrees
     * by this number to get the equivalent quantity in radians.
     */
    public static const DEG_TO_RAD:Number = Math.PI / 180;

    /**
     * Constant factor representing 180 / PI, the number of degrees in a
     * radian, approximately 57.295780.  Multiply a quantity in radians
     * by this number to get the equivalent quantity in degrees.
     */
    public static const RAD_TO_DEG:Number = 180 / Math.PI;

    /**
     * Convenience function to calculate the base-2 logarithm of a number.
     */
    public static function log2(number:Number):Number
    {
        return Math.log(number) / Math.LN2;
    }

    /**
     * Convenience function to calculate the base-10 logarithm of a number.
     */
    public static function log10(number:Number):Number
    {
        return Math.log(number) / Math.LN10;
    }

    /**
     * Convenience function to calculate an arbitrary base logarithm of a
     * number.
     */
    public static function logBase(number:Number, base:Number):Number
    {
        return Math.log(number) / Math.log(base);
    }

    /**
     * Clamp a number to a given range.  If <code>inVal</code> &lt;
     * <code>min</code>, return <code>min</code>.  If <code>inVal</code>
     * &gt; <code>max</code>, return <code>max</code>.  Otherwise, return
     * inVal unchanged.
     */
    public static function clamp(inVal:Number, min:Number, max:Number):Number
    {
        return inVal < min ? min : (inVal > max ? max : inVal);
    }

    /**
     * Calculate the positive modulo of a division.
     */
    public static function positiveMod(dividend:Number, divisor:Number):Number
    {
        var modResult:Number = dividend % divisor;
        return modResult < 0 ? modResult + divisor : modResult;
    }

    /**
     * Rounds a number to the nearest arbitrary multiple.
     */
    public static function roundToMultiple(number:Number, multiple:Number):Number
    {
        return Math.round(number / multiple) * multiple;
    }
}
}
