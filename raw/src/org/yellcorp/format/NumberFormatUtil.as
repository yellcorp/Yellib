package org.yellcorp.format
{
import org.yellcorp.string.StringBuilder;


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
    public static function groupNumber(number:*, radixChar:String = ".",
        groupChar:String = ",", groupSize:int = 3):String
    {
        var numberString:NativeNumberString =
            new NativeNumberString(String(number));

        var result:StringBuilder;

        if (groupChar && groupSize > 0 && numberString.isNumericString &&
            numberString.isFiniteNumber)
        {
            result = new StringBuilder(numberString.sign);

            result.append(intersperse(numberString.integerDigits,
                groupChar, -groupSize));

            if (numberString.hasFractionalDigits)
            {
                result.append(radixChar);
                result.append(numberString.fractionalDigits);
            }
            result.append(numberString.exponent);
            return result.toString();
        }
        else
        {
            return numberString.string;
        }
    }

    /**
     * Intersperses a delimiter string within another string at regular
     * intervals.
     *
     * @example
     * <listing version="3.0">
     * trace(NumberFormatUtil.intersperse("ABCDEFGH", " ", 3);
     * // traces "ABC DEF GH"
     *
     * trace(NumberFormatUtil.intersperse("ABCDEFGH", " ", -3);
     * // traces "AB CDE FGH"
     * </listing>
     *
     * @param string The string in which to inserts the delimiter string.
     * @param delimiter The delimiter string. If this string is empty, the
     *                  original string will be returned unchanged.
     * @param interval The number of characters from <code>string</code>
     *                 that will appear between copies of
     *                 <code>delimiter</code>. If this number is positive,
     *                 the interval will be counted from the start of the
     *                 string.  If negative, it will be counted from the
     *                 end.  If its absolute value is zero or greater than
     *                 the length of <code>string</code>, the original
     *                 string will be returned unchanged.
     */
    public static function intersperse(string:String, delimiter:String,
        interval:int):String
    {
        var result:StringBuilder;
        var i:int;
        var max:int;
        var fromEnd:Boolean = interval < 0;

        if (fromEnd)
        {
            interval = -interval;
        }

        if (interval == 0 || !delimiter || string.length <= interval)
        {
            return string;
        }
        else if (fromEnd)
        {
            result = new StringBuilder();
            for (i = string.length - interval; i > 0; i -= interval)
            {
                result.prepend(string.substr(i, interval));
                result.prepend(delimiter);
            }
            result.prepend(string.substr(0, interval + i));
            return result.toString();
        }
        else
        {
            result = new StringBuilder();
            max = string.length - interval;
            for (i = 0; i < max; i += interval)
            {
                result.append(string.substr(i, interval));
                result.append(delimiter);
            }
            result.append(string.substr(i));
            return result.toString();
        }
    }
}
}
