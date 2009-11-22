package org.yellcorp.math
{
public class UnitEase
{
    public static function cubic(t:Number):Number
    {
        // 3t^2 - 2t^3
        return 3*t*t-2*t*t*t;
    }
}
}
