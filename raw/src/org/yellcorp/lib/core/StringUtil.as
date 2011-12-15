package org.yellcorp.lib.core
{
public class StringUtil
{
    public static const WHITESPACE:RegExp = /[\s\0]+/g;
    public static const LEADING_WHITESPACE:RegExp = /^[\s\0]+/;
    public static const TRAILING_WHITESPACE:RegExp = /[\s\0]+$/;
    public static const ENTIRELY_WHITESPACE:RegExp = /^[\s\0]+$/;


    /**
     * Returns <code>str</code> with contiguous leading whitespace removed.
     * @param str The string to trim.
     * @return    The trimmed string.
     */
    public static function trimLeft(str:String):String
    {
        return str.replace(LEADING_WHITESPACE, "");
    }


    /**
     * Returns <code>str</code> with contiguous trailing whitespace removed.
     * @param str The string to trim.
     * @return    The trimmed string.
     */
    public static function trimRight(str:String):String
    {
        return str.replace(TRAILING_WHITESPACE, "");
    }


    /**
     * Returns <code>str</code> with contiguous leading and trailing
     * whitespace removed.
     * @param str The string to trim.
     * @return    The trimmed string.
     */
    public static function trim(str:String):String
    {
        return trimLeft(trimRight(str));
    }


    /**
     * Returns a trimmed copy of <code>str</code> with interior whitespace
     * sequences each replaced with a single space.
     * @param str The string in which to condense whitespace.
     * @return    The string with whitespace condensed.
     */
    public static function condenseWhitespace(str:String):String
    {
        return trim(str).replace(WHITESPACE, " ");
    }


    /**
     * Repeats a string a given number of times.
     * @param sequence  The string to repeat. An empty string, null or
     *                  undefined will return an empty string.
     * @param n         The number of times to repeat the string. A value
     *                  less than or equal to zero will return an empty
     *                  string.
     * @return          A string composed of <code>n</code> repetitions of
     *                  <code>sequence</code>.
     */
    public static function repeat(sequence:String, n:int):String
    {
        var result:String = "";
        if (sequence && n > 0)
        {
            do {
                if (n & 1) result += sequence;
            } while ((n >>= 1) && (sequence += sequence));
        }
        return result;
    }


    public static function padLeft(value:*, totalWidth:int,
                                   padChar:String = " ",
                                   truncate:Boolean = false):String
    {
        var inStr:String = value;
        if (inStr.length >= totalWidth)
        {
            return truncate ? inStr.substr(inStr.length - totalWidth)
                            : inStr;
        }
        else
        {
            return repeat(padChar.charAt(0), totalWidth - inStr.length) + inStr;
        }
    }


    public static function padRight(value:*, totalWidth:int,
                                    padChar:String = " ",
                                    truncate:Boolean = false):String
    {
        var inStr:String = value;
        if (inStr.length >= totalWidth)
        {
            return truncate ? inStr.substr(0, totalWidth)
                            : inStr;
        }
        else
        {
            return inStr + repeat(padChar.charAt(0), totalWidth - inStr.length);
        }
    }


    public static function hasContent(query:String):Boolean
    {
        return Boolean(query) && !ENTIRELY_WHITESPACE.test(query);
    }


    public static function startsWith(query:String, start:String, caseSensitive:Boolean = true):Boolean
    {
        if (!caseSensitive)
        {
            query = query.toLocaleUpperCase();
            start = start.toLocaleUpperCase();
        }
        return query.slice(0, start.length) == start;
    }


    public static function endsWith(query:String, end:String, caseSensitive:Boolean = true):Boolean
    {
        if (!caseSensitive)
        {
            query = query.toLocaleUpperCase();
            end = end.toLocaleUpperCase();
        }
        return query.slice(-end.length) == end;
    }


    /**
     * Strips <code>sequence</code> from <code>str</code> if
     * <code>str</code> begins with <code>sequence</code>.
     */
    public static function stripStart(str:String, sequence:String, caseSensitive:Boolean = true):String
    {
        if (startsWith(str, sequence, caseSensitive))
        {
            return str.substr(sequence.length);
        }
        else
        {
            return str;
        }
    }


    /**
     * Strips <code>sequence</code> from <code>str</code> if
     * <code>str</code> ends with <code>sequence</code>.
     */
    public static function stripEnd(str:String, sequence:String, caseSensitive:Boolean = true):String
    {
        if (endsWith(str, sequence, caseSensitive))
        {
            return str.substr(0, str.length - sequence.length);
        }
        else
        {
            return str;
        }
    }
    
    
    /**
     * Replaces a range of characters in a string with another string. The range
     * can be zero-length to insert a string, or the replacement string call be 
     * <code>null</code> or empty to delete characters.
     */
    public static function splice(string:String, rangeStart:int, rangeEnd:int, 
            stringToInsert:String):String
    {
        return string.slice(0, rangeStart) + (stringToInsert || "") +
               string.slice(rangeEnd);
    }


    public static function delimiterJoin(first:String, second:String, delimeter:String, caseSensitive:Boolean = true):String
    {
        return stripEnd(first, delimeter, caseSensitive) +
               delimeter +
               stripStart(second, delimeter, caseSensitive);
    }


    public static function delimiterJoinArray(values:Array, delimeter:String, caseSensitive:Boolean = true):String
    {
        var filterValues:Array = new Array(values.length);
        var value:String;
        var i:int;
        var valuesLen:int = values.length;
        var lastValue:int = valuesLen - 1;

        for (i = 0; i < valuesLen; i++)
        {
            value = values[i];
            if (i > 0)
            {
                value = stripStart(value, delimeter, caseSensitive);
            }
            if (i < lastValue)
            {
                value = stripEnd(value, delimeter, caseSensitive);
            }
            filterValues[i] = value;
        }
        return filterValues.join(delimeter);
    }


    public static function isDigit(digit:String, base:int):Boolean
    {
        if (digit == "0")
        {
            return true;
        }
        else if (digit < "0")
        {
            return false;
        }
        else
        {
            var maxDigit:String = (base - 1).toString(base);

            if (digit == maxDigit)
            {
                return true;
            }
            else if (maxDigit <= "9")
            {
                return digit <= maxDigit;
            }
            else if (digit <= "9")
            {
                return true;
            }
            else
            {
                maxDigit = maxDigit.toLowerCase();
                digit = digit.toLowerCase();

                return digit >= 'a' && digit <= maxDigit;
            }
        }
    }
}
}
