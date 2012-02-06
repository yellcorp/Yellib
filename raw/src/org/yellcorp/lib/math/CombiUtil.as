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
