package org.yellcorp.format.printf.number
{
import org.yellcorp.binary.NumberInfo;
import org.yellcorp.format.printf.format.HexFloatFormatOptions;
import org.yellcorp.string.StringBuilder;


public class SplitHexFloat implements SplitNumber
{
    private var value:Number;
    private var _valueInfo:NumberInfo;
    private var options:HexFloatFormatOptions;
    private var _fractionalPart:String = null;

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

    public function get radixPrefix():String
    {
        return options.radixPrefix;
    }

    public function get integerPart():String
    {
        return getValueInfo().subnormal ? "0" : "1";
    }

    public function get integerGrouping():Boolean
    {
        return options.grouping;
    }

    public function get integerWidth():Number
    {
        return 1;
    }

    public function get forceFractionalSeparator():Boolean
    {
        return options.forceDecimalSeparator;
    }

    public function get fractionalPart():String
    {
        var builder:StringBuilder;

        if (_fractionalPart === null)
        {
            builder = new StringBuilder();
            for (var f:int = 0; f < options.fracWidth && f < getValueInfo().mantissaLength; f++)
            {
                builder.append(getValueInfo().getMantissaHalfByte(f).toString(16));
            }
            _fractionalPart = builder.toString();
        }
        return _fractionalPart;
    }

    public function get fractionalWidth():Number
    {
        return options.fracWidth;
    }

    public function get exponentDelimiter():String
    {
        return options.exponentDelimiter;
    }

    public function get exponentLeadSign():String
    {
        return options.signs.getPair(getValueInfo().exponent < 0).lead;
    }

    public function get exponent():String
    {
        return Math.abs(getValueInfo().exponent).toString(10);
    }

    public function get exponentTrailSign():String
    {
        return options.signs.getPair(getValueInfo().exponent < 0).trail;
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
        return options.paddingChar;
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

    private function getValueInfo():NumberInfo
    {
        if (!_valueInfo)
        {
            _valueInfo = new NumberInfo(value);
        }
        return _valueInfo;
    }
}
}
