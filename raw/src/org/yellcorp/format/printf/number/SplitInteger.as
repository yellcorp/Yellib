package org.yellcorp.format.printf.number
{
import org.yellcorp.format.printf.options.IntegerFormatOptions;


public class SplitInteger implements SplitNumber
{
    private var value:Number;
    private var options:IntegerFormatOptions;

    public function SplitInteger(value:*, options:IntegerFormatOptions)
    {
        this.value = Math.round(value);
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
        return Math.abs(value).toString(options.base);
    }

    public function get groupingCharacter():String
    {
        return options.groupingCharacter;
    }

    public function get integerWidth():Number
    {
        return options.minDigits;
    }

    public function get forceRadixPoint():Boolean
    {
        return false;
    }

    public function get fractionalPart():String
    {
        return "";
    }

    public function get fractionalWidth():Number
    {
        return 0;
    }

    public function get exponentDelimiter():String
    {
        return "";
    }

    public function get exponentLeadSign():String
    {
        return "";
    }

    public function get exponent():String
    {
        return "";
    }

    public function get exponentTrailSign():String
    {
        return "";
    }

    public function get exponentWidth():Number
    {
        return 0;
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
        return options.base;
    }

    public function get uppercase():Boolean
    {
        return options.uppercase;
    }

    public function get groupingSize():int
    {
        return options.groupingSize;
    }
}
}
