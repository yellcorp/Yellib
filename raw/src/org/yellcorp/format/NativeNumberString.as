package org.yellcorp.format
{
public class NativeNumberString
{
    public static const NATIVE_NUMBER_PATTERN:RegExp =
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

    private var _numberString:String;
    private var match:Object;

    public function NativeNumberString(numberString:String)
    {
        this.string = numberString;
    }

    public function get string():String
    {
        return _numberString;
    }

    public function set string(numberString:String):void
    {
        _numberString = numberString;
        if (_numberString)
        {
            match = NATIVE_NUMBER_PATTERN.exec(_numberString);
        }
    }

    public function get isNumericString():Boolean
    {
        return match != null;
    }

    public function get isNotANumber():Boolean
    {
        return match ? match[NAN] == NAN_STRING : true;
    }

    public function get isNegative():Boolean
    {
        return match ? match[SIGN] == "-" : false;
    }

    public function get sign():String
    {
        // the use of ?: is to provide an empty string in case
        // the match var is null.  the use of || is to provide
        // an empty string if the match var is present, but
        // if the requested property is set to null/undefined
        return match ? match[SIGN] || "" : "";
    }

    public function get isFiniteNumber():Boolean
    {
        return match ? match[NAN] != NAN_STRING && match[NUMBER] != INF_STRING : false;
    }

    public function get integerDigits():String
    {
        return match ? match[INTEGER] || "" : "";
    }

    public function get hasFractionalDigits():Boolean
    {
        return match ? match[DECIMAL] != null : false;
    }

    public function get fractionalDigits():String
    {
        return match ? match[DECIMAL_DIGITS] || "" : "";
    }

    public function get exponent():String
    {
        return match ? match[EXPONENT] || "" : "";
    }

    public function get isExponentNegative():Boolean
    {
        return match ? match[EXP_SIGN] == "-" : false;
    }

    public function get exponentSign():String
    {
        return match ? match[EXP_SIGN] || "" : "";
    }

    public function get exponentDigits():String
    {
        return match ? match[EXP_DIGITS] || "" : "";
    }
}
}
