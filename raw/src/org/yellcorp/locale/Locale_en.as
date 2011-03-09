package org.yellcorp.locale
{
public class Locale_en implements Locale
{
    private static const WEEKDAY_NAME:Array =
        ["Sunday", "Monday", "Tuesday", "Wednesday",
         "Thursday", "Friday", "Saturday"];

    private static const WEEKDAY_SHORTNAME:Array =
        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    private static const MONTH_NAME:Array =
        ["January", "February", "March", "April", "May", "June",
         "July", "August", "September", "October", "November", "December"];

    private static const MONTH_SHORTNAME:Array =
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    public function getMonthNameShort(month:Number):String
    {
        return MONTH_SHORTNAME[month];
    }

    public function getMonthName(month:Number):String
    {
        return MONTH_NAME[month];
    }

    public function getDayNameShort(weekday:Number):String
    {
        return WEEKDAY_SHORTNAME[weekday];
    }

    public function getDayName(weekday:Number):String
    {
        return WEEKDAY_NAME[weekday];
    }

    public function getDayHalf(i:int):String
    {
        return i < 12 ? "AM" : "PM";
    }

    public function getOrdinalSuffix(number:Number):String
    {
        var tens:int = number % 100;

        if (tens < 4 || tens > 20)
        {
            switch(tens % 10)
            {
                case 1:
                    return "st";
                case 2:
                    return "nd";
                case 3:
                    return "rd";
                default :
                    return "th";
            }
        }
        return "th";
    }
}
}
