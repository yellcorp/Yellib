package org.yellcorp.format
{
import org.yellcorp.string.StringUtil;


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

    public static function formatTimezoneOffset(offsetMinutes:Number):String
    {
        var laterThanUTC:Boolean;
        var modMinutes:int;
        var hours:int;

        if (offsetMinutes < 0)
        {
            laterThanUTC = true;
            offsetMinutes = -offsetMinutes;
        }

        modMinutes = offsetMinutes % 60;
        hours = Math.floor(offsetMinutes / 60);

        // note the sign will be flipped wrt offsetMinutes
        return (laterThanUTC ? "+" : "-") +
               StringUtil.padLeft(hours, 2, "0") +
               StringUtil.padLeft(modMinutes, 2, "0");
    }
}
}
