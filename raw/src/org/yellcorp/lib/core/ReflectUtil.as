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
        var colons:int = className.lastIndexOf("::");
        if (colons >= 0)
        {
            return className.substr(0, colons) + "." +
                   className.substr(colons + 2);
        }
        else
        {
            return className;
        }
    }

    public static function classInColonNotation(className:String):String
    {
        var dot:int = className.lastIndexOf(".");
        if (dot >= 0)
        {
            return className.substr(0, dot) + "::" +
                   className.substr(dot + 1);
        }
        else
        {
            return className;
        }
    }
}
}
