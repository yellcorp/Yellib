package org.yellcorp.lib.serial
{
import org.yellcorp.lib.serial.error.ParseError;


public class ParseUtil
{
    public static const HEX_INTEGER:RegExp =
        /^(?:0x|#)([0-9a-f]+)$/i ;

    public static function parseBoolean(value:*):Boolean
    {
        var asString:String;

        if (value === undefined || value === null ||
            value is Number || value is int || value is uint ||
            value is Boolean || value is Array)
        {
            return Boolean(value);
        }
        else
        {
            asString = String(value);
            switch (asString)
            {
            case "t":
            case "true":
            case "y":
            case "yes":
            case "1":
            case "-1":
            case "on":
            case "enabled":
                return true;

            case "":
            case "f":
            case "false":
            case "n":
            case "no":
            case "0":
            case "nan":
            case "off":
            case "disabled":
                return false;
            }
        }
        return Boolean(value);
    }

    public static function parseInteger(value:*):int
    {
        return int(parseIntegralType(value, int.MIN_VALUE, int.MAX_VALUE));
    }

    public static function parseUInteger(value:*):uint
    {
        return uint(parseIntegralType(value, uint.MIN_VALUE, uint.MAX_VALUE));
    }

    public static function parseNumber(value:*):Number
    {
        var result:Number;

        if (value is Number || value is int || value is uint)
        {
            result = value;
        }
        else
        {
            result = parseFloat(String(value));
        }

        if (isNaN(result))
        {
            throw new ArgumentError("Value is not a number: " + value);
        }
        return result;
    }

    private static function parseIntegralType(value:*, minValue:Number, maxValue:Number):Number
    {
        var result:Number;
        var hexMatch:Object;

        if (value is Number)
        {
            result = Math.round(value);
            if (result !== value)
            {
                throw new ParseError("Value is a non-integral number: " + value);
            }
        }
        else
        {
            value = String(value);
            hexMatch = HEX_INTEGER.exec(value);
            if (hexMatch)
            {
                result = parseInt(hexMatch[1], 16);
            }
            else
            {
                result = parseInt(value, 10);
            }
        }

        if (isNaN(result))
        {
            throw new ParseError("Value is not a number: " + value);
        }
        else if (result > maxValue)
        {
            throw new ParseError("Value greater than maximum allowed value: " + maxValue);
        }
        else if (result < minValue)
        {
            throw new ParseError("Value less than minimum allowed value: " + minValue);
        }
        return result;
    }

    public static function parseString(value:*):String
    {
        return String(value);
    }

    public static function parseXML(value:*):XML
    {
        return XML(value);
    }
}
}
