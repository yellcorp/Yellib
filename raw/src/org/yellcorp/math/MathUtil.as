package org.yellcorp.math
{
public class MathUtil
{
    public static const DEG_TO_RAD:Number = Math.PI / 180;
    public static const RAD_TO_DEG:Number = 180 / Math.PI;

    public static function log2(number:Number):Number
    {
        return Math.log(number) / Math.LN2;
    }

    public static function log10(number:Number):Number
    {
        return Math.log(number) / Math.LN10;
    }

    public static function logBase(number:Number, base:Number):Number
    {
        return Math.log(number) / Math.log(base);
    }

    public static function clamp(inVal:Number, min:Number, max:Number):Number
    {
        return inVal < min ? min : (inVal > max ? max : inVal);
    }

    public static function positiveMod(dividend:Number, divisor:Number):Number
    {
        var modResult:Number = dividend % divisor;

        if (modResult < 0) modResult += divisor;

        return modResult;
    }

    public static  function roundToMultiple(number:Number, multiple:Number):Number
    {
        return Math.round(number / multiple) * multiple;
    }
}
}
