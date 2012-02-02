package org.yellcorp.lib.core
{
import flash.geom.Point;


/**
 * Functions for basic statistical calculations.
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

    /**
     * Returns the arithmetic mean (average) of numbers in an Array. An
     * optional weighting array can be provided.
     *
     * @param values  An array of numbers to average.
     * @param weights An array of weights. If not provided, all elements in
     *                the <code>values</code> are considered equally
     *                weighted. If provided, it must have the same number
     *                of elements as <code>values</code>.
     *
     * @return The arithmetic mean.
     * @throws ArgumentError If a weights array is passed and it does not
     *                have the same number of elements as the values array.
     */
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

    /**
     * Calculates the parameters of a least-squares regression line through a
     * set of points.
     *
     * @param xValues  An Array or Vector.<Number> of x (independent) sample
     *                 values.
     * @param yValues  An Array or Vector.<Number> of y (dependent) sample
     *                 values. Must have the same number of elements as xValues.
     * @param out      An optional existing object in which to store the
     *                 result. If it is provided, it must have settable x and y
     *                 properties.  If none is provided, a Point will be
     *                 constructed.
     * @return  The result stored in the object passed in out, or a new Point if
     *          out is not provided.  The x property will contain m, the
     *          factor of x representing the slope of a line.  The y property
     *          will contain b, the y-axis intercept.
     */
    public static function linearRegression(xValues:*, yValues:*, out:* = null):*
    {
        if (xValues.length != yValues.length)
        {
            throw new ArgumentError("Arrays must be of equal length");
        }
        if (!out) out = new Point();

        var sumx:Number = 0;
        var sumy:Number = 0;
        var sumxx:Number = 0;
        var sumxy:Number = 0;

        var n:Number = xValues.length;
        var x:Number;
        var y:Number;

        for (var i:int = 0; i < n; i++)
        {
            x = xValues[i];  y = yValues[i];
            sumx += x;
            sumy += y;
            sumxx += x * x;
            sumxy += x * y;
        }

        var m:Number = (n * sumxy - sumx * sumy) / (n * sumxx - sumx * sumx);

        out.x = m;
        out.y = (sumy - m * sumx) / n;

        return out;
    }
}
}
