package org.yellcorp.math
{
public class InterpUtil
{
    public static function lerp(inMin:Number, inMax:Number, t:Number):Number
    {
        return inMin + t * (inMax - inMin);
    }

    /**
     * Assuming inVal is on a range of inMin to inMax, scales it so it is in
     * proportion to outMin and outMax
     *
     * Will accept out-of-range values no probs
     *
     * @param    inVal    The value to be scaled
     * @param    inMin    The value's lower range
     * @param    inMax    The value's higher range
     * @param    outMin    The new lower range
     * @param    outMax    The new higher range
     * @return            The value scaled to the new range.
     */
    public static function lerpRange(inVal:Number, inMin:Number, inMax:Number, outMin:Number, outMax:Number):Number
    {
        var outVal:Number;
        outVal = outMin + (outMax - outMin) * (inVal - inMin) / (inMax - inMin);
        return outVal;
    }

    public static function lerp2d(v00:Number, v01:Number,
                                  v10:Number, v11:Number,
                                  x:Number, y:Number):Number
    {
        var v0x:Number = v00 + x * (v01 - v00);
        var v1x:Number = v10 + x * (v11 - v10);

        return v0x + y * (v1x - v0x);
    }

    public static function clerp(v0:Number, v1:Number, v2:Number, v3:Number, x:Number):Number
    {
        var P:Number = (v3 - v2) - (v0 - v1);
        var Q:Number = (v0 - v1) - P;
        var R:Number = v2 - v0;
        var S:Number = v1;

        return ((P * x + Q) * x + R) * x + S;
    }
}
}
