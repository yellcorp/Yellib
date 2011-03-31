package org.yellcorp.lib.core
{
public class ReflectUtil
{
    private static const CLASS_NAME_DELIMITER:RegExp = /(::|\.)[^:.]+$/;

    public static function splitClassName(className:String):Array
    {
        var match:Object = CLASS_NAME_DELIMITER.exec(className);

        if (match)
        {
            return [
                className.substr(0, match.index),
                className.substr(match.index + match[1].length)
            ];
        }
        else
        {
            return [ className ];
        }
    }

    public static function getShortClassName(className:String):String
    {
        var split:Array = splitClassName(className);
        return split[1] || split[0];
    }

    public static function classInDotNotation(className:String):String
    {
        return replaceLast(className, "::", ".");
    }

    public static function classInColonNotation(className:String):String
    {
        return replaceLast(className, ".", "::");
    }

    private static function replaceLast(string:String, from:String, to:String):String
    {
        var delim:int = string.lastIndexOf(from);
        if (delim >= 0)
        {
            return string.substr(0, delim) + to +
                   string.substr(delim + from.length);
        }
        else
        {
            return string;
        }
    }
}
}
