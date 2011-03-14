package org.yellcorp.lib.core
{
/**
 * The Statistics class groups static methods for
 * basic statistical calculations.
 *
 */
public class Statistics
{
    /**
     * Returns the maximum value in an <code>Array</code>.  Similar to
     * <code>Math.max</code>, but takes a single array argument instead
     * of a variable number of arguments.
     *
     * @param values An array of Numbers, ints, or uints
     * @return The maximum value.
     * @see Math.max
     */
    public static function max(values:Array):Number
    {
        return Math.max.apply(Math, values);
    }

    /**
     * Returns the minimum value in an <code>Array</code>.  Similar to
     * <code>Math.min</code>, but takes a single array argument instead
     * of a variable number of arguments.
     *
     * @param values An array of Numbers, ints, or uints
     * @return The maximum value.
     * @see Math.min
     */
    public static function min(values:Array):Number
    {
        return Math.min.apply(Math, values);
    }

    public static function mean(values:Array, weights:Array = null):Number
    {
        var valueSum:Number = 0;
        var weightSum:Number = 0;

        if (!values || values.length == 0)
        {
            return Number.NaN;
        }
        else if (!weights)
        {
            for each (var n:Number in values)
            {
                valueSum += n;
            }
            return valueSum / values.length;
        }
        else
        {
            if (values.length != weights.length)
            {
                throw new ArgumentError("If weights argument is specified, it must have the same length as values");
            }

            for (var i:int = values.length; i >= 0; i--)
            {
                valueSum += values[i] * weights[i];
                weightSum += weights[i];
            }
            return valueSum / weightSum;
        }
    }

    public static function variance(values:Array, weights:Array = null):Number
    {
        var valueMean:Number = mean(values, weights);
        var meanDiff:Number;
        var diffSquared:Array = new Array(values.length);

        for (var i:int = 0;i < values.length; i++)
        {
            meanDiff = values[i] - valueMean;
            diffSquared[i] = meanDiff * meanDiff;
        }

        return mean(diffSquared, weights);
    }

    public static function standardDeviation(values:Array, weights:Array = null):Number
    {
        return Math.sqrt(variance(values, weights));
    }
}
}
