package org.yellcorp.format.c4.format
{
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

    public function get radixPrefix():String
    {
        return options.radixPrefix;
    }

    public function get integerPart():String
    {
        return value.toString(options.base);
    }

    public function get integerGrouping():Boolean
    {
        return options.grouping;
    }

    public function get forceFractionalSeparator():Boolean
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
        return options.paddingChar;
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
}
}
