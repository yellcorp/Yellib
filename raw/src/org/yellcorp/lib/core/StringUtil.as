package org.yellcorp.lib.core
{
public class StringUtil
{
    public static const TRIM_LEFT:RegExp = /^[\s\0]+/;
    public static const TRIM_RIGHT:RegExp = /[\s\0]+$/;
    public static const ALL_WHITESPACE:RegExp = /^[\s\0]+$/;


    public static function trimLeft(str:String):String
    {
        return str.replace(TRIM_LEFT, "");
    }


    public static function trimRight(str:String):String
    {
        return str.replace(TRIM_RIGHT, "");
    }


    public static function trim(str:String):String
    {
        return trimLeft(trimRight(str));
    }


    public static function repeat(str:String, times:int):String
    {
        var result:String = "";
        if (times > 0)
        {
            do
            {
                if (times & 1) result += str;
            } while ((times >>= 1) && (str += str));
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
        return Boolean(query) && !ALL_WHITESPACE.test(query);
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
