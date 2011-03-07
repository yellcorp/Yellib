package org.yellcorp.format.c4.format
{
import org.yellcorp.error.AssertError;


public class SplitNativeNumber implements SplitNumber
{
    public static const NATIVE_NUMBER:RegExp =
        /(NaN|(-)?(Infinity|(\d+)(\.(\d+))?(e([+-]?)(\d+))?))/i;
    //   |    |   |         |    |  |      | |      |
    //   |    |   |         |    |  |      | |      9: Exponent magnitude
    //   |    |   |         |    |  |      | 8: Exponent sign
    //   |    |   |         |    |  |      7: Entire exponent
    //   |    |   |         |    |  6: Fractional digits
    //   |    |   |         |    5: Fractional part
    //   |    |   |         4: Integral part
    //   |    |   3: 'Infinity' or entire number
    //   |    2: Negative sign
    //   1: 'NaN' or entire number

    private static const NAN:uint = 1;
    private static const SIGN:uint = 2;
    private static const NUMBER:uint = 3;
    private static const INTEGER:uint = 4;
    private static const DECIMAL:uint = 5;
    private static const DECIMAL_DIGITS:uint = 6;
    private static const EXPONENT:uint = 7;
    private static const EXP_SIGN:uint = 8;
    private static const EXP_DIGITS:uint = 9;

    private static const NAN_STRING:String = "NaN";
    private static const INF_STRING:String = "Infinity";

    private var groups:Object;
    private var options:FloatFormatOptions;

    private var _isNaN:Boolean;
    private var _isFinite:Boolean;
    private var _isNegative:Boolean;
    private var _isNegativeExponent:Boolean;

    public function SplitNativeNumber(numberString:String, options:FloatFormatOptions)
    {
        this.options = options;
        groups = NATIVE_NUMBER.exec(numberString);

        AssertError.assert(groups != null, "Regex didn't match numberString");

        _isNaN = groups[NAN] == NAN_STRING;
        _isFinite = !_isNaN && groups[NUMBER] != INF_STRING;
        _isNegative = groups[SIGN] == "-";
        _isNegativeExponent = groups[EXP_SIGN] == "-";
    }

    public function get isNotANumber():Boolean
    {
        return _isNaN;
    }

    public function get isFiniteNumber():Boolean
    {
        return _isFinite;
    }

    public function get leadSign():String
    {
        return options.signs.getPair(_isNegative).lead;
    }

    public function get radixPrefix():String
    {
        return "";
    }

    public function get integerPart():String
    {
        return groups[INTEGER];
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
        return groups[DECIMAL_DIGITS];
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
        return options.exponentSigns.getPair(_isNegativeExponent).lead;
    }

    public function get exponent():String
    {
        return groups[EXP_DIGITS];
    }

    public function get exponentTrailSign():String
    {
        return options.exponentSigns.getPair(_isNegativeExponent).lead;
    }

    public function get exponentWidth():Number
    {
        return options.exponentWidth;
    }

    public function get trailSign():String
    {
        return options.signs.getPair(_isNegative).trail;
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
        return 10;
    }

    public function get uppercase():Boolean
    {
        return options.uppercase;
    }
}
}
