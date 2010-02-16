package org.yellcorp.math
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
        var inVals:Array = values.slice();
        var outVals:Array;
        var inWeights:Array = weights ? weights.slice() : [ ];
        var outWeights:Array;

        var weight1:Number;
        var weight2:Number;

        var i:uint;
        var j:uint;
        var lastOdd:uint;
        var oddBalance:Boolean = false;

        if (inVals.length == 1)
        {
            return inVals[0];
        }

        while (inVals.length > 1)
        {
            outVals = new Array();
            outWeights = new Array();
            j = 0;
            lastOdd = inVals.length - 1;
            for (i = 0;i < inVals.length; i += 2)
            {
                weight1 = i < inWeights.length ? inWeights[i] : 1;
                if (i == lastOdd)
                {
                    if (oddBalance)
                    {
                        outVals.push(inVals[i]);
                        outWeights.push(weight1);
                    }
                    else
                    {
                        outVals.unshift(inVals[i]);
                        outWeights.unshift(weight1);
                    }
                    oddBalance = !oddBalance;
                }
                else
                {
                    weight2 = (i + 1) < inWeights.length ? inWeights[i + 1] : 1;
                    outVals.push(inVals[i] + inVals[i + 1]);
                    outWeights.push(weight1 + weight2);
                }
            }
            inVals = outVals;
            inWeights = outWeights;
        }

        return inVals[0] / inWeights[0];
    }

    public static function variance(values:Array, weights:Array = null):Number
    {
        var valueMean:Number = mean(values, weights);
        var diffSquared:Array = new Array(values.length);
        var i:int;

        for (i = 0;i < values.length; i++)
        {
            diffSquared[i] = values[i] - valueMean;
            diffSquared[i] *= diffSquared[i];
        }

        return mean(diffSquared, weights);
    }

    public static function standardDeviation(values:Array, weights:Array = null):Number
    {
        return Math.sqrt(variance(values, weights));
    }
}
}
