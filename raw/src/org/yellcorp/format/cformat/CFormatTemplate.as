package org.yellcorp.format.cformat
{
import org.yellcorp.string.StringUtil;


public class CFormatTemplate
{
    public static var localeGroupingSymbol:String = ",";
    public static var localeGroupingSize:int = 3;
    public static var localeRadixSymbol:String = ".";

    private var tokens:Array;

    public function CFormatTemplate(tokens:Array)
    {
        this.tokens = tokens;
    }

    public function format(args:Array):String
    {
        var i:int;
        var result:String = "";

        var argReader:ArrayReader = new ArrayReader(args);

        for (i = 0; i < tokens.length; i++)
        {
            if (tokens[i] is CFormatToken)
            {
                result += formatToken(tokens[i], argReader);
            }
            else
            {
                result += tokens[i];
            }
        }

        return result;
    }

    public static function formatToken(token:CFormatToken, args:ArrayReader):String
    {
        var value:*;

        var width:int = -1;
        var precision:int = -1;

        var positiveSign:String = "";

        var group:Boolean;
        var zeroPad:Boolean;
        var alignLeft:Boolean;
        var alternateForm:Boolean;
        var caps:Boolean;

        var result:String;

        value = token.index >= 0 ? args.getUntyped(token.index) : args.getUntyped();

        if (token.widthMeta)
        {
            width = token.widthMetaArg >= 0 ? args.getNumber(token.widthMetaArg) : args.getNumber();
        }
        else
        {
            width = token.width;
        }

        if (token.precisionMeta)
        {
            precision = token.precisionMetaArg >= 0 ? args.getNumber(token.precisionMetaArg) : args.getNumber();
        }
        else
        {
            precision = token.precision;
        }

        group = token.group;
        zeroPad = token.zeroPad && !token.alignLeft;
        alignLeft = token.alignLeft;
        positiveSign = token.positiveSign;
        alternateForm = token.alternateForm;
        caps = token.caps;

        switch (token.type)
        {
            case CFormatToken.TYPE_UNSIGNED_INT :
                result = formatInteger(uint(value), 10, group, zeroPad, "", "", width, precision, false);
                break;

            case CFormatToken.TYPE_DECIMAL_INT :
                result = formatInteger(int(value), 10, group, zeroPad, positiveSign, "", width, precision, false);
                break;

            case CFormatToken.TYPE_OCTAL_INT :
                result = formatInteger(uint(value), 8, false, zeroPad, "", (alternateForm ? "0" : ""), width, precision, false);
                break;

            case CFormatToken.TYPE_HEX_INT :
                result = formatInteger(uint(value), 16, false, zeroPad, "", (alternateForm ? "0x" : ""), width, precision, caps);
                break;

            case CFormatToken.TYPE_FIX_FLOAT :
                result = formatFixed(value, group, zeroPad, positiveSign, alternateForm, width, precision, true, caps);
                break;

            case CFormatToken.TYPE_EXP_FLOAT :
                result = formatExponential(value, group, zeroPad, positiveSign, alternateForm, width, precision, true, caps);
                break;

            case CFormatToken.TYPE_VAR_FLOAT :
                result = formatAdaptiveFloat(value, group, zeroPad, positiveSign, alternateForm, width, precision, caps);
                break;

            case CFormatToken.TYPE_HEX_FLOAT :
                // TODO
                result = "[TODO CFormatToken.TYPE_HEX_FLOAT]";
                break;

            case CFormatToken.TYPE_CHAR :
                result = formatChar(value);
                break;

            case CFormatToken.TYPE_STRING :
                result = formatString(value, precision);
                break;

            default :
                throw new Error("Internal error: type " + token.type + " not handled");
                result = "";
                break;
        }

        if (result.length < width)
        {
            if (alignLeft)
            {
                result = StringUtil.padRight(result, width, " ", false);
            }
            else
            {
                result = StringUtil.padLeft(result, width, " ", false);
            }
        }

        return result;
    }

    public static function formatFixed(value:*,
                                        group:Boolean = false,
                                        zeroPad:Boolean = false,
                                        positiveSign:String = "",
                                        forceIntegralRadix:Boolean = false,
                                        width:int = -1,
                                        precision:int = -1,
                                        keepTrailingZeros:Boolean = false,
                                        caps:Boolean = false):String
    {
        var numVal:Number = Number(value);
        var sign:String = positiveSign;
        var result:String;

        if (isFinite(numVal))
        {
            if (numVal < 0)
            {
                numVal = -numVal;
                sign = "-";
            }

            if (precision < 0) precision = 6;

            result = numVal.toFixed(precision);

            result = commonFormatDecimal(result, group, precision, forceIntegralRadix, keepTrailingZeros);

            if (zeroPad && width >= 0)
            {
                result = addLeadingZeros(result, width - sign.length);
            }

            result = sign + result;
        }
        else
        {
            result = numVal.toString();
        }

        return caps ? result.toUpperCase() : result;
    }

    public static function formatExponential(value:*,
                                              group:Boolean = false,
                                              zeroPad:Boolean = false,
                                              positiveSign:String = "",
                                              forceIntegralRadix:Boolean = false,
                                              width:int = -1,
                                              precision:int = -1,
                                              keepTrailingZeros:Boolean = false,
                                              caps:Boolean = false):String
    {
        var numVal:Number = Number(value);
        var sign:String = positiveSign;
        var result:String;

        var ePos:int;
        var expSign:String;
        var expValue:String;

        if (isFinite(numVal))
        {
            if (numVal < 0)
            {
                numVal = -numVal;
                sign = "-";
            }

            if (precision < 0) precision = 6;

            result = numVal.toExponential(precision);
            ePos = result.indexOf("e");

            // toExponential doesn't guarantee an e
            if (ePos >= 0)
            {
                expSign = result.substr(ePos + 1, 1);
                expValue = result.substr(ePos + 2);
                result = result.substr(0, ePos);

                expValue = addLeadingZeros(expValue, 2);
            }
            else
            {
                expSign = "+";
                expValue = "00";
            }

            result = commonFormatDecimal(result, group, precision, forceIntegralRadix, keepTrailingZeros);

            if (zeroPad && width >= 0)
            {
                result = addLeadingZeros(result, width - sign.length - expValue.length - 2);
            }

            result = sign + result + "e" + expSign + expValue;
        }
        else
        {
            result = numVal.toString();
        }

        return caps ? result.toUpperCase() : result;
    }

    public static function formatAdaptiveFloat(value:*,
                                                group:Boolean = false,
                                                zeroPad:Boolean = false,
                                                positiveSign:String = "",
                                                forceIntegralRadix:Boolean = false,
                                                width:int = -1,
                                                precision:int = -1,
                                                caps:Boolean = false):String
    {
        var numVal:Number = Number(value);
        var absVal:Number = Math.abs(numVal);

        if (precision == 0)
        {
            precision = 1;
        }
        else if (precision < 0)
        {
            precision = 6;
        }

        if (absVal < 1e-3 || absVal >= Math.pow(10, precision))
        {
            return formatExponential(value, group, zeroPad, positiveSign, forceIntegralRadix, width, precision, false, caps);
        }
        else
        {
            return formatFixed(value, group, zeroPad, positiveSign, forceIntegralRadix, width, precision, false, caps);
        }
    }

    public static function formatInteger(value:*,
                                          radix:int = 10,
                                          group:Boolean = false,
                                          zeroPad:Boolean = false,
                                          positiveSign:String = "",
                                          radixPrefix:String = "",
                                          width:int = -1,
                                          minDigits:int = -1,
                                          caps:Boolean = false):String
    {
        var result:String;
        var sign:String = positiveSign;

        if (value is Number || value is int)
        {
            if (value > 0)
            {
                result = int(value).toString(radix);
            }
            else
            {
                result = int(-value).toString(radix);
                sign = "-";
            }
        }
        else if (value is uint)
        {
            result = value.toString(radix);
        }
        else
        {
            return "";
        }

        // special case for octal
        if (radixPrefix == "0" && value == 0)
            radixPrefix = "";

        if (group)
        {
            result = localizeSeparators(groupNumberString(result));
        }

        if (minDigits >= 0)
        {
            // this option cancels zeroPad
            result = addLeadingZeros(result, minDigits);
        }
        else if (zeroPad && width >= 0)
        {
            result = addLeadingZeros(result, width - radixPrefix.length - sign.length);
        }

        result = sign + radixPrefix + result;

        return caps ? result.toUpperCase() : result;
    }

    public static function formatString(value:*, maxLength:int = -1):String
    {
        var result:String;

        if (value is String)
        {
            result = value;
        }
        else if (value.toString)
        {
            result = value.toString();
        }
        else
        {
            result = String(value);
        }

        if (maxLength >= 0)
        {
            return result.substr(0, maxLength);
        }
        else
        {
            return result;
        }
    }

    public static function formatChar(value:*):String
    {
        if (value is String)
        {
            return (value as String).charAt(0);
        }
        else if (value is uint)
        {
            return String.fromCharCode(value);
        }
        else if (value is Number || value is int)
        {
            return String.fromCharCode(uint(value));
        }
        else
        {
            return value.toString().charAt(0);
        }
    }

    internal static function commonFormatDecimal(result:String, group:Boolean, precision:int, forceIntegralRadix:Boolean, keepTrailingZeros:Boolean):String
    {
        if (precision == 0 && forceIntegralRadix)
        {
            result += ".";
        }
        else if (precision > 0 && keepTrailingZeros)
        {
            result = forceMinPrecision(result, precision);
        }

        if (group)
            result = groupNumberString(result);

        return localizeSeparators(result);
    }

    internal static function forceMinPrecision(numString:String, precision:int):String
    {
        var point:int;

        point = numString.indexOf(".");

        if (point < 0)
        {
            return numString + "." + StringUtil.repeat("0", precision);
        }
        else
        {
            return StringUtil.padRight(numString, point + precision + 1, "0", false);
        }
    }

    internal static function groupNumberString(numString:String):String
    {
        var intPart:String;
        var point:int;
        var intResult:String = "";
        var fracPart:String;

        var groupSize:int = localeGroupingSize;
        var i:int;

        if (numString == "") return "";

        point = numString.indexOf(".");

        if (point >= 0)
        {
            intPart = numString.substr(0, point);
            fracPart = numString.substr(point + 1);
        }
        else
        {
            intPart = numString;
        }

        if (intPart.length > groupSize)
        {
            i = intPart.length % groupSize;
            if (i > 0)
            {
                intResult = intPart.substr(0, i);
            }
            while (i < intPart.length)
            {
                intResult += (intResult == "" ? "" : ",") +
                             intPart.substr(i, groupSize);

                i += groupSize;
            }
        }
        else
        {
            intResult = intPart;
        }

        if (point >= 0)
        {
            intResult += "." + fracPart;
        }

        return intResult;
    }

    internal static function addLeadingZeros(numString:String, minWidth:int):String
    {
        if (minWidth <= numString.length)
        {
            return numString;
        }
        else
        {
            return StringUtil.padLeft(numString, minWidth, "0", false);
        }
    }

    internal static function localizeSeparators(floatStr:String):String
    {
        var intPart:String;
        var fracPart:String;
        var intSep:int;

        if (localeGroupingSymbol == "," && localeRadixSymbol == ".") return floatStr;

        intSep = floatStr.indexOf(".");

        if (intSep < 0)
        {
            return floatStr.replace(",", localeGroupingSymbol);
        }
        else
        {
            intPart = floatStr.substr(0, intSep);
            fracPart = floatStr.substr(intSep + 1);

            return intPart.replace(",", localeGroupingSymbol) + localeRadixSymbol + fracPart;
        }
    }
}
}

internal class ArrayReader
{
    private var _array:Array;
    private var _pointer:int;

    public function ArrayReader(array:Array)
    {
        setSource(array);
    }

    public function setSource(array:Array):void
    {
        _array = array;
        _pointer = 0;
    }

    public function getNumber(index:int = -1):Number
    {
        return Number(getUntyped(index));
    }

    public function getUntyped(index:int = -1):*
    {
        if (index < 0)
        {
            index = _pointer++;
        }
        else
        {
            _pointer = index + 1;
        }
        if (index > _array.length)
        {
            trace("CFormatTemplate.format: Warning: Insufficient arguments. Using null.");
        }
        return _array[index];
    }
}
