package org.yellcorp.format.printf.parser
{
import org.yellcorp.date.DateUtil;
import org.yellcorp.error.AssertError;
import org.yellcorp.format.DateFormatUtil;
import org.yellcorp.format.printf.FormatError;
import org.yellcorp.format.printf.context.ContextError;
import org.yellcorp.format.printf.context.RenderContext;
import org.yellcorp.format.printf.format.CommonFormatOptions;
import org.yellcorp.format.printf.format.FloatFormatOptions;
import org.yellcorp.format.printf.format.Format;
import org.yellcorp.format.printf.format.GeneralFormatOptions;
import org.yellcorp.format.printf.format.HexFloatFormatOptions;
import org.yellcorp.format.printf.format.IntegerFormatOptions;
import org.yellcorp.format.printf.lexer.Lexer;
import org.yellcorp.format.printf.lexer.Token;
import org.yellcorp.locale.Locale;
import org.yellcorp.locale.Locale_en;
import org.yellcorp.sequence.Set;
import org.yellcorp.string.StringBuilder;


public class Parser
{
    private var lexer:Lexer;
    private var field:FieldProperties;
    private var output:StringBuilder;
    private var context:RenderContext;

    private var _locale:Locale;

    public function Parser()
    {
        lexer = new Lexer();
        field = new FieldProperties();
        output = new StringBuilder();
    }

    public function format(formatString:String, args:Array, locale:Locale = null):String
    {
        _locale = locale;
        context = new RenderContext(args);

        try {
            parse(formatString);
        }
        catch (tokenError:FormatTokenError)
        {
            throw new FormatError(
                tokenError.message,
                formatString,
                tokenError.token ? tokenError.token.charIndex : -1);
        }
        return output.toString();
    }

    private function parse(text:String):void
    {
        output.clear();
        lexer.start(text);

        while (!lexer.atEnd)
        {
            parseToken();
        }
    }

    private function parseToken():void
    {
        var token:Token = lexer.nextToken();

        if (token.text == "%")
        {
            field.clear();
            parseField();
        }
        else
        {
            var percent:int = token.text.indexOf("%");
            if (percent >= 0)
            {
                throw new FormatTokenError("Malformed field specifier",
                    token.substr(percent, 1));
            }
            output.append(token.text);
        }
    }

    private function parseField():void
    {
        var precisionChar:int;
        var conversionChar:int;

        parsePosition();
        parseFlags();
        parseWidth();

        precisionChar = lexer.currentChar + 1;
        parsePrecision();

        conversionChar = lexer.currentChar + 1;

        try {
            parseConversion();
        }
        catch (ce:ContextError)
        {
            throw new FormatError(ce.message, lexer.text, conversionChar);
        }
        catch (pe:PrecisionRangeError)
        {
            throw new FormatError(pe.message, lexer.text, precisionChar);
        }
    }

    private function parsePosition():void
    {
        var token:Token = lexer.nextToken();
        var argPosition:int;

        if (token.text)
        {
            AssertError.assert(/\$$/.test(token.text),
                "Position token doesn't end with $");

            argPosition = parseInt(token.text.slice(0, -1));

            field.argValue.setAbsoluteIndexArg(argPosition, token);
        }
    }

    private function parseFlags():void
    {
        var token:Token = lexer.nextToken();
        var setFlags:Set = new Set();
        var char:String;

        if (token.text)
        {
            for (var i:int = 0; i < token.text.length; i++)
            {
                char = token.text.charAt(i);
                if (setFlags.contains(char))
                {
                    throw new FormatTokenError(
                        char + " flag already set for this field",
                        token.substr(i, 1));
                }
                setFlags.add(char);

                switch (char)
                {
                case '<' :
                    if (field.argValue.isSet)
                    {
                        throw new FormatTokenError(
                            "< flag cannot be used with position specifier",
                            token.substr(i, 1));
                    }
                    else
                    {
                        field.argValue.setRelativeIndexArg(-1,
                            token.substr(i, 1));
                    }
                    break;

                case '-' :
                    field.leftJustify = true;
                    break;

                case '#' :
                    field.alternateForm = true;
                    break;

                case '+' :
                    field.positivePlus = true;
                    break;

                case ' ' :
                    field.positiveSpace = true;
                    break;

                case '0' :
                    field.zeroPad = true;
                    break;

                case ',' :
                    field.grouping = true;
                    break;

                case '(' :
                    field.negativeParens = true;
                    break;

                default :
                    AssertError.assert(false, "Unhandled flag char " + char);
                    break;
                }
            }
        }
    }

    private function parseWidth():void
    {
        var token:Token = lexer.nextToken();
        var width:Number;

        if (token.text)
        {
            width = parseInt(token.text);
            field.widthValue.setConstantValue(width, token);
        }
    }

    private function parsePrecision():void
    {
        var token:Token = lexer.nextToken();
        var precision:Number;

        if (token.text)
        {
            AssertError.assert(/^\./.test(token.text),
                "Precision token doesn't begin with .");

            precision = parseInt(token.text.substr(1));
            field.precisionValue.setConstantValue(precision, token);
        }
    }

    private function parseConversion():void
    {
        var token:Token = lexer.nextToken();
        var convChar:String;

        if (!token.text)
        {
            throw new FormatTokenError(
                "Encountered field without conversion specifier",
                token);
        }

        convChar = token.text.charAt(0);
        if (convChar == convChar.toUpperCase())
        {
            field.uppercase = true;
        }

        switch (convChar)
        {
        case '%' :
            output.append(formatPercent());
            break;

        case 'n' :
            output.append("\n");
            break;

        case 'b' :
        case 'B' :
            output.append(formatBoolean());
            break;

        case 's' :
        case 'S' :
            output.append(formatString());
            break;

        case 'c' :
        case 'C' :
            output.append(formatChar());
            break;

        case 'd' :
            output.append(formatSignedInt(10));
            break;

        case 'o' :
            output.append(formatUnsignedInt(8));
            break;

        case 'x' :
        case 'X' :
            output.append(formatUnsignedInt(16));
            break;

        case 'e' :
        case 'E' :
            try {
                output.append(formatExponential());
            }
            catch (re:RangeError)
            {
                throw new PrecisionRangeError(
                    "Number following . must be in the range 0,20 for exponential formatting");
            }
            break;

        case 'f' :
            try {
                output.append(formatFixed());
            }
            catch (re:RangeError)
            {
                throw new PrecisionRangeError(
                    "Number following . must be in the range 0,20 for fixed formatting");
            }
            break;

        case 'g' :
        case 'G' :
            try {
                output.append(formatPrecision());
            }
            catch (re:RangeError)
            {
                throw new PrecisionRangeError(
                    "Number following . must be in the range 0,21 for precision formatting");
            }
            break;

        case 'a' :
        case 'A' :
            output.append(formatHexFloat());
            break;

        case 't' :
        case 'T' :
            parseDateConversion(token);
            break;
        }
    }

    private function parseDateConversion(token:Token):void
    {
        var dateChar:String;
        var dateValue:Date;

        AssertError.assert(/^t.$/i.test(token.text),
            "Date conversion token doesn't match /^t.$/");

        dateChar = token.text.charAt(1);
        field.resolve(context, true);

        dateValue = field.argValue.getValue() as Date;

        if (dateValue === null)
        {
            throw new ContextError("Field requires a Date");
        }

        switch (dateChar)
        {
        case 'H' :
            output.append(formatGeneral(
                Format.padNumber(dateValue.hours, 2)));
            break;

        case 'I' :
            output.append(formatGeneral(Format.padNumber(
                DateFormatUtil.getHours1to12(dateValue.hours), 2)));
            break;

        case 'k' :
            output.append(formatGeneral(dateValue.hours));
            break;

        case 'l' :
            output.append(formatGeneral(
                DateFormatUtil.getHours1to12(dateValue.hours)));
            break;

        case 'M' :
            output.append(formatGeneral(
                Format.padNumber(dateValue.minutes, 2)));
            break;

        case 'S' :
            output.append(formatGeneral(Format.padNumber(dateValue.seconds, 2)));
            break;

        case 'L' :
            output.append(formatGeneral(
                Format.padNumber(dateValue.milliseconds, 3)));
            break;

        case 'N' :
            output.append(formatGeneral(
                Format.padNumber(dateValue.milliseconds * 1e6, 9)));
            break;

        case 'p' :
            output.append(formatGeneral(
                getLocale().getDayHalf(dateValue.hours).toLocaleLowerCase()));
            break;

        case 'z' :
        case 'Z' :
            output.append(formatGeneral(
                DateFormatUtil.formatTimezoneOffset(dateValue.timezoneOffset)));
            break;

        case 's' :
            output.append(formatGeneral(
                Math.round(dateValue.time / 1000)));
            break;

        case 'Q' :
            output.append(formatGeneral(dateValue.time));
            break;

        //// Dates

        case 'B' :
            output.append(formatGeneral(
                getLocale().getMonthName(dateValue.month)));
            break;

        case 'b' :
        case 'h' :
            output.append(formatGeneral(
                getLocale().getMonthNameShort(dateValue.month)));
            break;

        case 'A' :
            output.append(formatGeneral(
                getLocale().getDayName(dateValue.day)));
            break;

        case 'a' :
            output.append(formatGeneral(
                getLocale().getDayNameShort(dateValue.day)));
            break;

        case 'C' :
            output.append(formatGeneral(Format.padNumber(
                Math.floor(dateValue.fullYear / 100), 2)));
            break;

        case 'Y' :
            output.append(formatGeneral(Format.padNumber(
                dateValue.fullYear, 4)));
            break;

        case 'y' :
            // % is potentially problematic for negative years
            output.append(formatGeneral(Format.padNumber(
                dateValue.fullYear % 100, 2)));
            break;

        case 'j' :
            output.append(formatGeneral(Format.padNumber(
                DateUtil.getDayOfYear(dateValue), 3)));
            break;

        case 'm' :
            output.append(formatGeneral(
                Format.padNumber(dateValue.month + 1, 2)));
            break;

        case 'd' :
            output.append(formatGeneral(
                Format.padNumber(dateValue.date, 2)));
            break;

        case 'e' :
            output.append(formatGeneral(dateValue.date));
            break;

        //// convenience

        case 'R' :
            output.append(formatGeneral(
                new Parser().format("%tH:%<tM", [ dateValue ], getLocale())));
            break;

        case 'T' :
            output.append(formatGeneral(
                new Parser().format("%tH:%<tM:%<tS", [ dateValue ], getLocale())));
            break;

        case 'r' :
            // "the location of %Tp may be locale-dependent"
            output.append(formatGeneral(
                new Parser().format("%tI:%<tM:%<tS %<Tp", [ dateValue ], getLocale())));
            break;

        case 'D' :
            output.append(formatGeneral(
                new Parser().format("%tm/%<td/%<ty", [ dateValue ], getLocale())));
            break;

        case 'F' :
            output.append(formatGeneral(
                new Parser().format("%tY-%<tm-%<td", [ dateValue ], getLocale())));
            break;

        case 'c' :
            output.append(formatGeneral(
                new Parser().format("%ta %<tb %<td %<tT %<tZ %<tY", [ dateValue ], getLocale())));
            break;
        }
    }

    private function formatPercent():String
    {
        field.resolve(context, false);
        return formatGeneral("%");
    }

    private function formatBoolean():String
    {
        field.resolve(context, true);
        return formatGeneral(field.argValue.getValue() ? "true" : "false");
    }

    private function formatString():String
    {
        field.resolve(context, true);
        return formatGeneral(field.argValue.getValue());
    }

    private function formatGeneral(text:*):String
    {
        var options:GeneralFormatOptions = new GeneralFormatOptions();
        options.setFromFlags(field);
        return Format.formatGeneral(text, options);
    }

    private function formatChar():String
    {
        var options:CommonFormatOptions = new CommonFormatOptions();
        field.resolve(context, true);
        options.setFromFlags(field);
        return Format.formatChar(field.argValue.getValue(), options);
    }

    private function formatSignedInt(base:int):String
    {
        var options:IntegerFormatOptions = new IntegerFormatOptions();
        options.base = base;
        field.resolve(context, true);
        options.setFromFlags(field);
        return Format.formatInteger(int(field.argValue.getValue()), options);
    }

    private function formatUnsignedInt(base:int):String
    {
        var options:IntegerFormatOptions = new IntegerFormatOptions();
        options.base = base;
        field.resolve(context, true);
        options.setFromFlags(field);
        return Format.formatInteger(uint(field.argValue.getValue()), options);
    }

    private function formatExponential():String
    {
        var options:FloatFormatOptions = new FloatFormatOptions();
        field.resolve(context, true);
        options.setFromFlags(field);
        return Format.formatExponential(field.argValue.getValue(), options);
    }

    private function formatFixed():String
    {
        var options:FloatFormatOptions = new FloatFormatOptions();
        field.resolve(context, true);
        options.setFromFlags(field);
        return Format.formatFixed(field.argValue.getValue(), options);
    }

    private function formatPrecision():String
    {
        var options:FloatFormatOptions = new FloatFormatOptions();
        field.resolve(context, true);
        options.setFromFlags(field);
        return Format.formatPrecision(field.argValue.getValue(), options);
    }

    private function formatHexFloat():String
    {
        var options:HexFloatFormatOptions = new HexFloatFormatOptions();
        field.resolve(context, true);
        options.setFromFlags(field);
        return Format.formatHexFloat(field.argValue.getValue(), options);
    }

    public function getLocale():Locale
    {
        if (!_locale) _locale = new Locale_en();
        return _locale;
    }
}
}
