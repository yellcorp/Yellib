package org.yellcorp.format.c4.format
{
import org.yellcorp.binary.NumberInfo;
import org.yellcorp.format.NumberFormatUtil;
import org.yellcorp.string.StringBuilder;
import org.yellcorp.string.StringUtil;


public class Format
{
    private static const ADAPTIVE_FIXED_MINIMUM:Number = 10e-4;

    // make this variable
    private static const LOCALE_GROUPING_SIZE:int = 3;

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

    public static function formatGeneral(
        value:*,
        options:GeneralFormatOptions):String
    {
        var text:String =
            value === undefined ? "undefined"
                                : String(value);

        if (options.maxWidth >= 0 && text.length > options.maxWidth)
        {
            text = options.leftJustify ? text.substr(0, options.maxWidth)
                                       : text.slice(-options.maxWidth);
        }

        if (options.minWidth >= 0 && text.length < options.minWidth)
        {
            text = options.leftJustify ?
                    StringUtil.padRight(text, options.minWidth, " ")
                    : StringUtil.padLeft(text, options.minWidth, " ");
        }

        return options.uppercase ? text.toLocaleUpperCase() : text;
    }

    public static function formatChar(value:*, options:CommonFormatOptions):String
    {
        var gOpts:GeneralFormatOptions = new GeneralFormatOptions(options);
        gOpts.maxWidth = 1;

        if (value === null || value === undefined)
        {
            return formatGeneral("?", gOpts);
        }
        else if (value is Number || value is int || value is uint)
        {
            return formatGeneral(String.fromCharCode(value), gOpts);
        }
        else
        {
            return formatGeneral(value, gOpts);
        }
    }

    public static function formatInteger(value:*, options:IntegerFormatOptions):String
    {
        var numValue:Number = Math.round(value);
        var negative:Boolean;

        if (numValue < 0)
        {
            negative = true;
            numValue = -numValue;
        }

        return buildNumberString(isNaN(numValue), isFinite(numValue),
            negative, options.signs, options.radixPrefix,
            numValue.toString(options.base),
            options.grouping,
            false, "", 0, "", false, null, "", 0,
            options.minWidth, options.paddingChar, options.leftJustify,
            options.base, options.uppercase);
    }

    public static function formatExponential(value:*, options:FloatFormatOptions):String
    {
        var numValue:Number = value;
        var text:String = numValue.toExponential(options.fracWidth);

        return formatNumberString(text, options);
    }

    public static function formatFixed(value:*, options:FloatFormatOptions):String
    {
        var numValue:Number = value;
        var text:String = numValue.toFixed(options.fracWidth);

        return formatNumberString(text, options);
    }

    public static function formatAdaptiveFloat(value:*, options:FloatFormatOptions):String
    {
        var numValue:Number = value;
        var precision:int = options.fracWidth;
        var text:String;

        if (isFinite(numValue))
        {
            options = new FloatFormatOptions(options);

            if (options.fracWidth > 1)
            {
                options.fracWidth -= 1;
            }
            else
            {
                options.fracWidth = 1;
            }

            if (numValue < ADAPTIVE_FIXED_MINIMUM || numValue >= Math.pow(10, precision))
            {
                text = numValue.toExponential(options.fracWidth);
            }
            else
            {
                text = numValue.toFixed(options.fracWidth);
            }
        }

        return formatNumberString(text, options);
    }

    public static function formatNumberString(numberString:String, options:FloatFormatOptions):String
    {
        var match:Object = NATIVE_NUMBER.exec(numberString);

        var nan:Boolean = match[1] && match[1] == "NaN";
        var infinite:Boolean = match[3] && match[3] == "Infinity";
        var finite:Boolean = !(nan || infinite);

        return buildNumberString(
            nan,
            finite,
            match[2] == "-",
            options.signs,
            "",
            match[4],
            options.grouping,
            options.forceDecimalSeparator,
            match[6],
            options.fracWidth,
            options.exponentDelimiter,
            match[8] == "-",
            options.exponentSigns,
            match[9],
            options.exponentWidth,
            options.minWidth,
            options.paddingChar,
            options.leftJustify,
            10,
            options.uppercase);
    }

    private static function buildNumberString(
        nan:Boolean,
        finite:Boolean,
        negative:Boolean,
        signs:SignSet,
        radixPrefix:String,
        integerPart:String,
        grouping:Boolean,
        forcePoint:Boolean,
        fracPart:String,
        fracWidth:uint,
        exponentDelimiter:String,
        exponentNegative:Boolean,
        exponentSigns:SignSet,
        exponent:String,
        exponentWidth:uint,
        minWidth:Number,
        paddingChar:String,
        leftJustify:Boolean,
        base:int,
        uppercase:Boolean):String
    {
        var beforeString:StringBuilder = new StringBuilder();
        var beforeInteger:StringBuilder = new StringBuilder();
        var rest:StringBuilder = new StringBuilder();

        //                                                                   forceFracSep
        //           |--!nan--| |--!finite--| |---!finite----|               |-| |---fraction---| |-------exponent-------| |--!nan---|
        // [leadPad] [leadSign] [radixPrefix] [integerPadding] [integerPart] [.] [fractionalPart] [e] [expSign] [exponent] [trailSign] [trailPad]

        // leading sign
        if (!nan)
        {
            beforeInteger.append(signs.getPair(negative).lead);
        }

        // radix prefix
        beforeInteger.append(radixPrefix);

        // integer
        if (nan)
        {
            rest.append("NaN");
        }
        else if (!finite)
        {
            rest.append("Infinity");
        }
        else if (grouping)
        {
            rest.append(NumberFormatUtil.groupNumberStr(integerPart, ".", ",", LOCALE_GROUPING_SIZE));
        }
        else
        {
            rest.append(integerPart);
        }

        // point
        if (fracPart || forcePoint)
        {
            rest.append(".");
        }

        // frac part
        if (fracPart)
        {
            rest.append(StringUtil.padRight(fracPart, fracWidth, "0", true));
        }

        if (exponent)
        {
            rest.append(exponentDelimiter);
            rest.append(exponentSigns.getPair(exponentNegative).lead);
            rest.append(StringUtil.padLeft(exponent, exponentWidth, "0"));
            rest.append(exponentSigns.getPair(exponentNegative).trail);
        }

        if (!nan && negative)
        {
            rest.append(signs.getPair(negative).trail);
        }

        var remainingChars:int = minWidth - beforeInteger.length - rest.length;

        if (remainingChars > 0)
        {
            // truth table for padding to full width

            // isDigit(paddingChar)   finite    leftJusify   THEN
            //       true              true        true       A
            //       true              false       true       A
            //       true              true        false      B
            //       true              false       false      B
            //       false             true        true       C
            //       false             true        false      D
            //       false             false       true       E
            //       false             false       false      E

            // A beforeString.append(repeat(paddingChar))
            // B rest.append(repeat(paddingChar))
            // C beforeString.append(repeat(" "))
            // D rest.append(repeat(" "))
            // E beforeInteger.append(repeat(paddingChar))


            if (StringUtil.isDigit(paddingChar, base))
            {
                if (finite)
                {
                    beforeInteger.append(StringUtil.repeat(paddingChar, remainingChars));
                }
                else if (leftJustify)
                {
                    rest.append(StringUtil.repeat(" ", remainingChars));
                }
                else
                {
                    beforeString.append(StringUtil.repeat(" ", remainingChars));
                }
            }
            else
            {
                if (leftJustify)
                {
                    rest.append(StringUtil.repeat(paddingChar, remainingChars));
                }
                else
                {
                    beforeString.append(StringUtil.repeat(paddingChar, remainingChars));
                }
            }
        }

        var result:String = beforeString.toString() + beforeInteger.toString() + rest.toString();

        return uppercase ? result.toUpperCase() : result;
    }

    public static function formatHexFloat(value:*, options:HexFloatFormatOptions):String
    {
        var numValue:Number = value;

        if (isFinite(numValue) && numValue != 0)
        {
            return formatHexFloatFinite(numValue, options);
        }
        else
        {
            return formatHexFloatQuick(numValue, options);
        }
    }

    private static function formatHexFloatQuick(numValue:Number, options:HexFloatFormatOptions):String
    {
        return buildNumberString(isNaN(numValue), isFinite(numValue), numValue < 0,
            options.signs, "0x", "0", options.grouping,
            options.forceDecimalSeparator, "0", options.fracWidth,
            options.exponentDelimiter, false, options.exponentSigns, "0",
            options.exponentWidth, options.minWidth, options.paddingChar,
            options.leftJustify, 16, options.uppercase);
    }

    private static function formatHexFloatFinite(numValue:Number, options:HexFloatFormatOptions):String
    {
        var numberInfo:NumberInfo = new NumberInfo(numValue);
        var integerPart:String;
        var fracPart:StringBuilder = new StringBuilder();

        integerPart = numberInfo.subnormal ? "0" : "1";

        for (var f:int = 0; f < options.fracWidth && f < numberInfo.mantissaLength; f++)
        {
            fracPart.append(numberInfo.getMantissaHalfByte(f).toString(16));
        }

        var exponentNegative:Boolean = numberInfo.exponent < 0;
        var exponent:String = (exponentNegative ? -numberInfo.exponent : numberInfo.exponent).toString(10);

        return buildNumberString(isNaN(numValue), isFinite(numValue), numValue < 0,
            options.signs, "0x", integerPart, options.grouping,
            options.forceDecimalSeparator, fracPart.toString(),
            options.fracWidth, options.exponentDelimiter, exponentNegative,
            options.exponentSigns, exponent, options.exponentWidth,
            options.minWidth, options.paddingChar, options.leftJustify,
            16, options.uppercase);
    }
}
}
