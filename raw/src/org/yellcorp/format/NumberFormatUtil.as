package org.yellcorp.format
{
/**
 * Static methods for basic formatting of numbers.
 */
public class NumberFormatUtil
{
    /**
     * Separates the integer part of a number into groups of digits.
     * The decimal point can optionally be replaced with another character
     * - this is useful when using "." as the group separator.
     *
     * @example
     * <listing version="3.0">
     * trace(NumberFormatUtil.groupNumber(1234567);
     * // traces "1,234,567"
     *
     * // European style delimeters
     * trace(NumberFormatUtil.groupNumber(123456789.1234, ",", ".");
     * // traces "123.456.789,1234"
     *
     * // Japanese style grouping
     * trace(NumberFormatUtil.groupNumber(100000000.123, ".", ",", 4);
     * // traces "1,0000,0000.123"
     * </listing>
     *
     * @param number The number to format
     * @param radixChar The character to use as the decimal point.
     * @param groupChar The character to use as the group separator.
     * @param groupSize The group size.  If 0 or less, no group separators
     *                  are inserted.
     * @return          The formatted number as a <code>String</code>.
     */
    public static function groupNumber(
        number:Number,
        radixChar:String = ".",
        groupChar:String = ",",
        groupSize:int = 3):String
    {
        return groupNumberStr(number.toString(), radixChar, groupChar, groupSize);
    }

    /**
     * Identical to <code>groupNumber</code>, but accepts the number as a
     * <code>String</code>
     *
     * @see #groupNumber()
     */
    public static function groupNumberStr(
        numString:String,
        radixChar:String = ".",
        groupChar:String = ",",
        groupSize:int = 3):String
    {
        var intPart:String;
        var point:int;
        var intResult:String = "";
        var fracPart:String;
        var isNegative:Boolean;

        var i:int;

        if (numString == "") return "";

        isNegative = numString.charAt(0) == "-";
        point = numString.indexOf(".");

        if (point >= 0)
        {
            intPart = numString.substring(isNegative ? 1 : 0, point);
            fracPart = numString.substr(point + 1);
        }
        else
        {
            intPart = isNegative ? numString.substr(1)
                                 : numString;
        }

        if (groupSize > 0 && intPart.length > groupSize)
        {
            i = intPart.length % groupSize;
            if (i > 0)
            {
                intResult = intPart.substr(0, i);
            }
            while (i < intPart.length)
            {
                intResult += (intResult == "" ? "" : groupChar) +
                             intPart.substr(i, groupSize);

                i += groupSize;
            }
        }
        else
        {
            intResult = intPart;
        }

        if (point >= 0)
        {
            intResult += radixChar + fracPart;
        }

        return isNegative ? ("-" + intResult) : intResult;
    }

    public static function localizeNumberSeparators(
        number:Number,
        radixChar:String = ".",
        groupChar:String = ","):String
    {
        return localizeNumberSeparatorsStr(number.toString(), radixChar, groupChar);
    }

    public static function localizeNumberSeparatorsStr(
        floatStr:String,
        radixChar:String = ".",
        groupChar:String = ","):String
    {
        var intPart:String;
        var fracPart:String;
        var intSep:int;

        if (groupChar == "," && radixChar == ".") return floatStr;

        intSep = floatStr.indexOf(".");

        if (intSep < 0)
        {
            return floatStr.replace(",", groupChar);
        }
        else
        {
            intPart = floatStr.substr(0, intSep);
            fracPart = floatStr.substr(intSep + 1);

            return intPart.replace(",", groupChar) + radixChar + fracPart;
        }
    }
}
}
