package org.yellcorp.lib.core
{
public class BooleanUtil
{
    public static function parseBoolean(boolString:String, defaultValue:Boolean):Boolean
    {
        if (!boolString) return false;
        boolString = boolString.toLowerCase();
        switch (boolString)
        {
        case "t":
        case "true":
        case "y":
        case "yes":
        case "1":
        case "on":
        case "enabled":
            return true;

        case "f":
        case "false":
        case "n":
        case "no":
        case "0":
        case "off":
        case "disabled":
            return false;

        default :
            return defaultValue;
        }
    }
}
}
