package org.yellcorp.format.printf.number
{
import org.yellcorp.error.AssertError;
import org.yellcorp.format.NativeNumberString;
import org.yellcorp.format.printf.options.FloatFormatOptions;


public class SplitNativeNumber implements SplitNumber
{
    private var options:FloatFormatOptions;

    private var number:NativeNumberString;

    public function SplitNativeNumber(numberString:String, options:FloatFormatOptions)
    {
        this.options = options;
        number = new NativeNumberString(numberString);

        AssertError.assert(number.isNumericString, "Not a valid number string");
    }

    public function get isNotANumber():Boolean
    {
        return number.isNotANumber;
    }

    public function get isFiniteNumber():Boolean
    {
        return number.isFiniteNumber;
    }

    public function get leadSign():String
    {
        return options.signs.getPair(number.isNegative).lead;
    }

    public function get basePrefix():String
    {
        return "";
    }

    public function get integerPart():String
    {
        return number.integerDigits;
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
        return number.fractionalDigits;
    }

    public function get fractionalWidth():Number
    {
        return options.fractionalWidth;
    }

    public function get exponentDelimiter():String
    {
        return options.exponentDelimiter;
    }

    public function get exponentLeadSign():String
    {
        return options.exponentSigns.getPair(number.isExponentNegative).lead;
    }

    public function get exponent():String
    {
        return number.exponentDigits;
    }

    public function get exponentTrailSign():String
    {
        return options.exponentSigns.getPair(number.isExponentNegative).trail;
    }

    public function get exponentWidth():Number
    {
        return options.exponentWidth;
    }

    public function get trailSign():String
    {
        return options.signs.getPair(number.isNegative).trail;
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
        return 10;
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
