package org.yellcorp.lib.format.printf.number
{
import org.yellcorp.lib.core.StringUtil;
import org.yellcorp.lib.format.printf.options.HexFloatFormatOptions;
import org.yellcorp.lib.number.NumberInfo;


/**
 * @private
 */
public class SplitHexFloat implements SplitNumber
{
    private var value:Number;
    private var _valueInfo:NumberInfo;
    private var options:HexFloatFormatOptions;

    public function SplitHexFloat(value:*, options:HexFloatFormatOptions)
    {
        this.value = value;
        this.options = options;
    }

    public function get isNotANumber():Boolean
    {
        return isNaN(value);
    }

    public function get isFiniteNumber():Boolean
    {
        return isFinite(value);
    }

    public function get leadSign():String
    {
        return options.signs.getPair(value < 0).lead;
    }

    public function get basePrefix():String
    {
        return options.basePrefix;
    }

    public function get integerPart():String
    {
        return valueInfo.getIntegerString();
    }

    public function get groupingCharacter():String
    {
        return options.groupingCharacter;
    }

    public function get integerWidth():Number
    {
        return 1;
    }

    public function get forceRadixPoint():Boolean
    {
        return options.forceRadixPoint;
    }

    public function get fractionalPart():String
    {
        var frac:String = valueInfo.getFractionalString();

        if (isFinite(options.fractionalWidth))
        {
            return StringUtil.padRight(frac, options.fractionalWidth, "0", true);
        }
        else
        {
            return frac;
        }
    }

    public function get fractionalWidth():Number
    {
        // TODO: Limit max 13
        return options.fractionalWidth;
    }

    public function get exponentDelimiter():String
    {
        return options.exponentDelimiter;
    }

    public function get exponentLeadSign():String
    {
        return options.exponentSigns.getPair(valueInfo.getExponentSign() == "-").lead;
    }

    public function get exponent():String
    {
        if (valueInfo.zero)
        {
            return "0";
        }
        else if (valueInfo.subnormal)
        {
            return "1022";
        }
        else
        {
            return Math.abs(valueInfo.exponent).toString(10);
        }
    }

    public function get exponentTrailSign():String
    {
        return options.exponentSigns.getPair(valueInfo.getExponentSign() == "-").trail;
    }

    public function get exponentWidth():Number
    {
        return options.exponentWidth;
    }

    public function get trailSign():String
    {
        return options.signs.getPair(value < 0).trail;
    }

    public function get minWidth():uint
    {
        return options.minWidth;
    }

    public function get paddingCharacter():String
    {
        return options.paddingCharacter;
    }

    public function get leftJustify():Boolean
    {
        return options.leftJustify;
    }

    public function get base():uint
    {
        return 16;
    }

    public function get uppercase():Boolean
    {
        return options.uppercase;
    }

    private function get valueInfo():NumberInfo
    {
        if (!_valueInfo)
        {
            _valueInfo = new NumberInfo(value);
        }
        return _valueInfo;
    }

    public function get groupingSize():int
    {
        return options.groupingSize;
    }
}
}
