package org.yellcorp.format
{

public class DateFormatUtil
{
    public static function getHours1to24(hours:Number):Number
    {
        return hours == 0 ? 24 : hours;
    }

    public static function getHours0to11(hours:Number):Number
    {
        return hours >= 12 ? hours - 12
                           : hours;
    }

    public static function getHours1to12(hours:Number):Number
    {
        if (hours == 0)
            return 12;
        else if (hours > 12)
            return hours - 12;
        else
            return hours;
    }
}
}
