package org.yellcorp.lib.lex
{
public class ParseUtil
{
    /**
     * Returns a RegExp that will match a numeric literal.
     *
     * The RegExp returned is a transcription of the ECMA-262 ToNumber grammar,
     * without the allowance for leading or trailing whitespace.  It is up to
     * the caller to trim the string they are matching against if necessary.
     *
     * This function returns a new instance of the same RegExp each time, so
     * a caller can (and should) keep a reference to it if they will be using
     * it repeatedly.
     */
    public static function getNumberPattern():RegExp
    {
        return new RegExp(
            "^(?:"  +
                "[+-]?"  +
                "(?:"  +
                    "Infinity"  +
                    "|"  +
                    "(?:"  +
                        "\\d+\\.\\d*"  +
                        "|"  +
                        "\\.\\d+"  +
                        "|"  +
                        "\\d+"  +
                    ")"  +
                    "(?:"  +
                        "e[+-]?\\d+"  +
                    ")?"  +
                ")"  +
                "|"  +
                "0x[0-9a-f]+"  +
            ")$",
            "i"
        );
    }

    /**
     * Returns a RegExp that will match a hexadecimal literal.
     *
     * The RegExp returned is case-insensitive, and allows a prefix of
     * '0x', '0X', or '#'.  It has one named capturing group, 'digits', that
     * will contain the digits of a successful match, without any prefix.
     */
    public static function getHexIntegerPattern():RegExp
    {
        return new RegExp(
            "^"  +
                "(?:"  +
                    "0x"  +
                    "|"  +
                    "#"  +
                ")"  +
                "(?P<digits>"  +
                    "[0-9a-f]+"  +
                ")"  +
            "$",
            "i"
        );
    }

    // keep a copy for ourselves
    private static const HEX_INTEGER:RegExp = getHexIntegerPattern();

    public static function parseBoolean(value:*):Boolean
    {
        var asString:String;

        if (value === undefined || value === null ||
            value is Number || value is int || value is uint ||
            value is Boolean)
        {
            return Boolean(value);
        }
        else if (value is Array || value is Vector)
        {
            return value.length > 0;
        }
        else
        {
            asString = String(value).toLowerCase();
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
            throw new ParseError("Value is not a number: " + value);
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
                result = parseInt(hexMatch.digits, 16);
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
