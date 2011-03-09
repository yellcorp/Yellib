package org.yellcorp.format.printf.format
{
import org.yellcorp.format.NumberFormatUtil;
import org.yellcorp.format.printf.number.SplitHexFloat;
import org.yellcorp.format.printf.number.SplitInteger;
import org.yellcorp.format.printf.number.SplitNativeNumber;
import org.yellcorp.format.printf.number.SplitNumber;
import org.yellcorp.string.StringBuilder;
import org.yellcorp.string.StringUtil;


public class Format
{
    private static const PRECISION_FIXED_MINIMUM:Number = 10e-4;

    // TODO: make this variable
    private static const LOCALE_GROUPING_SIZE:int = 3;

    public static function formatGeneral(value:*, options:GeneralFormatOptions):String
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
            return formatGeneral(String(value).charAt(0), gOpts);
        }
    }

    public static function formatInteger(value:*, options:IntegerFormatOptions):String
    {
        return buildNumberString(new SplitInteger(value, options));
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

    public static function formatPrecision(value:*, options:FloatFormatOptions):String
    {
        var numValue:Number = value;
        var modOptions:FloatFormatOptions;
        var text:String;

        modOptions = new FloatFormatOptions(options);
        if (numValue < Format.PRECISION_FIXED_MINIMUM)
        {
            modOptions.fracWidth--;
            return formatExponential(numValue, modOptions);
        }
        else
        {
            if (modOptions.fracWidth < 1)
            {
                modOptions.fracWidth = 1;
            }

            text = numValue.toPrecision(modOptions.fracWidth);

            modOptions.fracWidth = Number.NaN;
            return formatNumberString(text, modOptions);
        }
    }

    private static function formatNumberString(numberString:String, options:FloatFormatOptions):String
    {
        return buildNumberString(new SplitNativeNumber(numberString, options));
    }

    public static function formatHexFloat(value:*, options:HexFloatFormatOptions):String
    {
        return buildNumberString(new SplitHexFloat(value, options));
    }

    private static function buildNumberString(number:SplitNumber):String
    {
        var beforeString:StringBuilder = new StringBuilder();
        var beforeInteger:StringBuilder = new StringBuilder();
        var rest:StringBuilder = new StringBuilder();

        var intString:String;

        //                                                                   forceFracSep
        //           |--!nan--| |--finite---| |----finite----|               |-| |---fraction---| |-------exponent-------| |--!nan---|
        // [leadPad] [leadSign] [radixPrefix] [integerPadding] [integerPart] [.] [fractionalPart] [e] [expSign] [exponent] [trailSign] [trailPad]

        // leading sign
        if (!number.isNotANumber)
        {
            beforeInteger.append(number.leadSign);
        }

        // integer
        if (number.isNotANumber)
        {
            rest.append("NaN");
        }
        else if (!number.isFiniteNumber)
        {
            rest.append("Infinity");
        }
        else
        {
            if (number.integerGrouping)
            {
                intString = NumberFormatUtil.groupNumberStr(number.integerPart, ".", ",", LOCALE_GROUPING_SIZE);
            }
            else
            {
                intString = number.integerPart;
            }

            // render the intString first to know whether to insert the
            // radix prefix. this a general solution to specifically
            // stop '0' in octal rendering as '00'
            if (number.radixPrefix &&
                !StringUtil.startsWith(intString, number.radixPrefix))
            {
                beforeInteger.append(number.radixPrefix);
            }

            if (isFinite(number.integerWidth))
            {
                intString = StringUtil.padLeft(intString, number.integerWidth, "0");
            }
            rest.append(intString);

            // point
            if (number.fractionalPart || number.forceFractionalSeparator)
            {
                rest.append(".");
            }

            // frac part
            if (number.fractionalPart)
            {
                if (isFinite(number.fractionalWidth))
                {
                    rest.append(StringUtil.padRight(number.fractionalPart, number.fractionalWidth, "0", true));
                }
                else
                {
                    rest.append(number.fractionalPart);
                }
            }

            if (number.exponent)
            {
                rest.append(number.exponentDelimiter);
                rest.append(number.exponentLeadSign);

                if (isFinite(number.exponentWidth))
                {
                    rest.append(StringUtil.padLeft(number.exponent, number.exponentWidth, "0"));
                }
                else
                {
                    rest.append(number.exponent);
                }

                rest.append(number.exponentTrailSign);
            }
        }

        if (!number.isNotANumber)
        {
            rest.append(number.trailSign);
        }

        var remainingChars:int = number.minWidth - beforeInteger.length - rest.length;

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

            if (StringUtil.isDigit(number.paddingCharacter, number.base))
            {
                if (number.isFiniteNumber)
                {
                    // never left-justify numeric padding. put it before integer part
                    beforeInteger.append(StringUtil.repeat(number.paddingCharacter, remainingChars));
                }
                // don't pad "NaN" or "Infinity" with a numeric character
                // fall back to space
                else if (number.leftJustify)
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
                if (number.leftJustify)
                {
                    rest.append(StringUtil.repeat(number.paddingCharacter, remainingChars));
                }
                else
                {
                    beforeString.append(StringUtil.repeat(number.paddingCharacter, remainingChars));
                }
            }
        }

        var result:String = beforeString.toString() + beforeInteger.toString() + rest.toString();

        return number.uppercase ? result.toUpperCase() : result;
    }

    public static function padNumber(number:Number, digits:int):String
    {
        var negative:Boolean;
        var paddedString:String;

        if (!isFinite(number))
        {
            return number.toString();
        }

        if (number < 0)
        {
            negative = true;
            number = -number;
        }

        paddedString = number.toString();
        if (paddedString.length < digits)
        {
            return (negative ? "-" : "") +
                StringUtil.repeat("0", digits - paddedString.length) +
                paddedString;
        }
        else
        {
            return (negative ? "-" : "") + paddedString;
        }
    }
}
}
