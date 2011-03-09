package org.yellcorp.locale
{
public interface Locale
{
    function getMonthNameShort(month:Number):String;
    function getMonthName(month:Number):String;
    function getDayNameShort(weekday:Number):String;
    function getDayName(weekday:Number):String;
    function getDayHalf(hourOfDay:int):String;

    /**
     * Returns the ordinal suffix for a given number.
     *
     * @param number The number
     *
     * @return In English, one of "st", "nd", "rd" or "th" for
     * concatenation with the number.
     */
    function getOrdinalSuffix(number:Number):String;
}
}
