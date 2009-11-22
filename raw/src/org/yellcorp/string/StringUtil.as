package org.yellcorp.string
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


    public static function repeat(str:String, times:uint):String
    {
        var result:String = "";
        do
        {
            if (times & 1) result += str;
        } while ((times >>= 1) && (str += str));

        return result;
    }


    public static function padLeft(inStr:String, totalWidth:uint,
                                   padChar:String = " ",
                                   truncate:Boolean = false):String
    {
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


    public static function padRight(inStr:String, totalWidth:uint,
                                    padChar:String = " ",
                                    truncate:Boolean = false):String
    {
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
        return (!!query) && !ALL_WHITESPACE.test(query);
        //        ^^^^^ both null and empty string cast to boolean as false
    }


    // these can be handy for making E4X expressions a little more succinct
    public static function beginsWith(query:String, begin:String, caseSensitive:Boolean = true):Boolean
    {
        if (caseSensitive)
        {
            return query.substr(0, begin.length) == begin;
        }
        else
        {
            // do this here because toLocaleUpperCase could potentially change
            // the length of the string, i.e. German ß --> SS
            begin = begin.toLocaleUpperCase();
            return query.toLocaleUpperCase().substr(0, begin.length) == begin;
        }
    }


    public static function endsWith(query:String, end:String, caseSensitive:Boolean = true):Boolean
    {
        if (caseSensitive)
        {
            return query.substr(query.length-end.length) == end;
        }
        else
        {
            end = end.toLocaleUpperCase();
            query = query.toLocaleUpperCase();
            return query.substr(query.length-end.length) == end;
        }
    }
}
}
