package org.yellcorp.format
{
/**
 * %d   - absolute degrees
 * %m   - absolute minutes
 * %.#s - absolute seconds
 * %-   - sign, only if negative
 * %+   - sign if + or -
 * %o   - longitudinal sign (E/W)
 * %a   - latitudinal sign (N/S)
 * %%   - literal percent
 */
public class GeoFormatUtil
{
    private static var cache:Object = { };
    private static var parser:Parser;

    public static function format(template:String, degrees:Number):String
    {
        var sequence:Array;
        sequence = cache[template];
        if (!sequence)
        {
            sequence = cache[template] = getParser().parse(template);
        }
        return formatSequence(sequence, degrees);
    }

    public static function clearCache():void
    {
        cache = { };
    }

    private static function formatSequence(sequence:Array, degrees:Number):String
    {
        var value:Base60Value = new Base60Value(degrees);

        function format1(token:*, i:int, a:Array):String
        {
            if (token is Token)
            {
                return Token(token).format(value);
            }
            else
            {
                return token;
            }
        }

        return sequence.map(format1).join("");
    }

    private static function getParser():Parser
    {
        if (!parser)
        {
            parser = new Parser();
        }
        return parser;
    }
}
}
import org.yellcorp.string.StringUtil;


internal class Base60Value
{
    public var sign:int;
    public var d:Number;
    public var m:Number;
    public var s:Number;

    public function Base60Value(number:Number)
    {
        sign = number == 0 ? 0 : (number > 0 ? 1 : -1);
        number = Math.abs(number);
        d = number;
        m = (d * 60) % 60;
        s = (m * 60) % 60;
    }
}

internal class Parser
{
    private var template:String;
    private var sequence:Array;
    private var index:int;

    private var zeroPad:Number;
    private var decimal:Number;
    private var field:String;

    public function parse(newTemplate:String):Array
    {
        var tokenIndex:int;

        reset(newTemplate);

        while (index < template.length)
        {
            tokenIndex = template.indexOf("%", index);
            if (tokenIndex >= 0)
            {
                if (index < tokenIndex)
                {
                    sequence.push(template.substring(index, tokenIndex));
                }
                index = tokenIndex;
                parseToken();
            }
            else
            {
                sequence.push(template.substr(index));
                break;
            }
        }
        return sequence;
    }

    private function reset(newTemplate:String):void
    {
        template = newTemplate;
        sequence = [ ];
        index = 0;
    }

    private function parseToken():void
    {
        var chr:String;
        var failIndex:int = index + 1;
        if (template.charAt(index) != "%")
        {
            throw new Error("Internal error: not pointing to %");
        }
        index++; // advance past the %
        chr = template.charAt(index);
        switch (chr)
        {
            case '-' :
            case '+' :
            case 'o' :
            case 'O' :
            case 'a' :
            case 'A' :
                sequence.push(new SignToken(chr));
                index++;
                return;
            case '%' :
                sequence.push("%");
                index++;
                return;
            default :
                if (parseNumericToken())
                {
                    sequence.push(new NumberToken(field, decimal, zeroPad));
                }
                else
                {
                    sequence.push("%");
                    index = failIndex;
                }
                return;
        }
    }

    private function parseNumericToken():Boolean
    {
        zeroPad = -1;
        decimal = -1;
        field = "";

        switch (template.charAt(index))
        {
            case '0' :
                return parseZeroPad();
                break;
            case '.' :
                return parseDecimal();
                break;
            default :
                return parseField();
                break;
        }
    }

    private function parseZeroPad():Boolean
    {
        if (template.charAt(index) != "0")
        {
            throw new Error("Internal error: not pointing to 0");
        }
        index++;
        zeroPad = parseInteger();
        if (!isFinite(zeroPad))
        {
            return false;
            parseError("Expected number after zero pad specifier", index);
        }
        switch (template.charAt(index))
        {
            case '.' :
                return parseDecimal();
                break;
            default :
                return parseField();
                break;
        }
    }

    private function parseDecimal():Boolean
    {
        if (template.charAt(index) != ".")
        {
            throw new Error("Internal error: not pointing to .");
        }
        index++;
        decimal = parseInteger();
        if (!isFinite(decimal))
        {
            return false;
            parseError("Expected number after precision specifier", index);
        }
        else
        {
            return parseField();
        }
    }

    private function parseField():Boolean
    {
        var chr:String = template.charAt(index);

        switch (chr)
        {
            case 'd' :
            case 'm' :
            case 's' :
                index++;
                field = chr;
                return true;
        }
        parseError("Unrecognized field", index);
        return false;
    }

    private function parseInteger():Number
    {
        var chr:String;
        var numStr:String = "";

        while ((chr = template.charAt(index)))
        {
            if (chr >= '0' && chr <= '9')
            {
                numStr += chr;
                index++;
            }
            else
            {
                break;
            }
        }
        return numStr.length == 0 ? Number.NaN : parseInt(numStr);
    }

    private function parseError(message:String, errorIndex:int):void
    {
        trace("Parse error: " + message + " at " + errorIndex);
    }
}

internal interface Token
{
    function format(value:Base60Value):String;
}

internal class SignToken implements Token
{
    private var pos:String;
    private var neg:String;

    public function SignToken(chr:String)
    {
        switch (chr)
        {
            case '-' :
                pos = ""; neg = "-";
                break;
            case '+' :
                pos = "+"; neg = "-";
                break;
            case 'o' :
                pos = "e"; neg = "w";
                break;
            case 'O' :
                pos = "E"; neg = "W";
                break;
            case 'a' :
                pos = "n"; neg = "s";
                break;
            case 'A' :
                pos = "N"; neg = "S";
                break;
            default :
                throw new Error("Internal error: Invalid char");
        }
    }
    public function format(value:Base60Value):String
    {
        return value.sign > 0 ? pos : neg;
    }
}

internal class NumberToken implements Token
{
    private var unit:String;
    private var decimal:int;
    private var zeroPad:int;

    public function NumberToken(newUnit:String, newDecimal:int, newZeroPad:int)
    {
        unit = newUnit;
        decimal = Math.min(newDecimal, 20);
        zeroPad = newZeroPad;
    }

    public function format(value:Base60Value):String
    {
        var result:String;
        var quantity:Number = value[unit];

        if (decimal >= 0)
        {
            result = quantity.toFixed(decimal);
        }
        else
        {
            result = int(quantity).toString();
        }

        if (zeroPad >= 0)
        {
            return StringUtil.padLeft(result, zeroPad, "0");
        }
        else
        {
            return result;
        }
    }
}
