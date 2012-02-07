package org.yellcorp.lib.math
{
import flash.utils.ByteArray;
import flash.utils.Endian;


public class CombiUtil
{
    public static function factorial(n:int):Number
    {
        var lookup:Array = getFactorialLookup();
        if (n >= lookup.length)
        {
            return Number.POSITIVE_INFINITY;
        }
        else
        {
            return lookup[n];
        }
    }

    public static function get maxFiniteFactorialArgument():int
    {
        return getFactorialLookup().length - 1;
    }

    /**
     * Returns the binomial coefficient nCk, the number of different unordered
     * subsets of length k, from an unordered set of length n.
     * Equal to n! / (k! * (n - k)!)
     */
    public static function nCk(n:int, k:int):Number
    {
        if (k == 0 || k == n)
        {
            return 1;
        }
        else if (k < 0 || k > n)
        {
            return 0;
        }
        else
        {
            return nPk(n, k) / factorial(k);
        }
    }

    /**
     * Returns the number of different ordered subsets of length k, from a set
     * of length n.  Equal to n! / (n - k)!
     */
    public static function nPk(n:int, k:int):Number
    {
        if (k == 0)
        {
            return 1;
        }
        else if (k < 0 || k > n)
        {
            return 0;
        }
        else if (k == n)
        {
            return factorial(n);
        }
        else
        {
            var result:int = n;
            while (--k > 0)
            {
                result *= --n;
            }
            return result;
        }
    }

    [Embed(source="factorial-lookup", mimeType="application/octet-stream")]
    private static var _factorialLookupData:Class;
    private static var _factorialLookup:Array;

    private static function getFactorialLookup():Array
    {
        if (!_factorialLookup)
        {
            _factorialLookup = [ ];
            var factorialBytes:ByteArray = new _factorialLookupData();
            factorialBytes.endian = Endian.LITTLE_ENDIAN;
            while (factorialBytes.bytesAvailable > 0)
            {
                _factorialLookup.push(factorialBytes.readDouble());
            }
        }
        return _factorialLookup;
    }
}
}
