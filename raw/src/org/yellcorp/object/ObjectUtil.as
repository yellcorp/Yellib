package org.yellcorp.object
{
public class ObjectUtil
{
    public static function firstNonNull(... args):*
    {
        for (var i:int = 0; i < args.length; i++)
        {
            if (args[i]) return args[i];
        }
        return null;
    }

    public static function firstFinite(... numbers):Number
    {
        for (var i:int = 0; i < numbers.length; i++)
        {
            if (isFinite(numbers[i])) return numbers[i];
        }
        return Number.NaN;
    }

    public static function getProperty(object:Object, property:*, noPropertyValue:* = null, noObjectValue:* = null):*
    {
        if (object)
        {
            if (object.hasOwnProperty(property))
            {
                return object[property];
            }
            else
            {
                return noPropertyValue;
            }
        }
        else
        {
            return noObjectValue;
        }
    }
}
}
