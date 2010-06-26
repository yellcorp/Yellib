package org.yellcorp.string
{
import org.yellcorp.date.TimeUnits;


public class ParseUtil
{
    private static const MEM_UNITS:Object = {
        b: 1,
        k: 1024,
        m: Math.pow(1024, 2),
        g: Math.pow(1024, 3),
        t: Math.pow(1024, 4),
        p: Math.pow(1024, 5)
    };

    private static const TIME_UNITS:Object = {
        s: TimeUnits.SECOND,
        m: TimeUnits.MINUTE,
        h: TimeUnits.HOUR
    };

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

    public static function parseTime(timeString:String):Number
    {
        var msec:Number;
        var lastQuantity:Number;
        var unitFactor:Number;
        var tokenMatch:Object;
        var timeToken:RegExp =
            /([0-9]+)|([a-z]+)/g;

        timeString = StringUtil.trim(timeString).toLowerCase();

        msec = 0;
        timeToken.lastIndex = 0;
        tokenMatch = timeToken.exec(timeString);
        while (tokenMatch)
        {
            if (tokenMatch[1])
            {
                lastQuantity = parseFloat(tokenMatch[1]);
            }
            else
            {
                unitFactor = TIME_UNITS[tokenMatch[2].charAt(0)];
                msec += lastQuantity * unitFactor;
                lastQuantity = 0;
            }
            tokenMatch = timeToken.exec(timeString);
        }

        return msec;
    }

    public static function parseMemory(memString:String):Number
    {
        var quantUnits:Array;
        var quantity:Number;
        var unitFactor:Number;

        memString = StringUtil.trim(memString);
        quantUnits = memString.split(/\s+/, 2);

        quantity = parseFloat(quantUnits[0]);
        unitFactor = parseMemUnits(quantUnits[1]);

        return quantity * unitFactor;
    }

    private static function parseMemUnits(units:String):Number
    {
        if (!units) return 1;
        return MEM_UNITS[units.charAt(0).toLowerCase()];
    }
}
}
