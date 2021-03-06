package org.yellcorp.lib.format.printf.parser
{
import org.yellcorp.lib.core.StringBuilder;
import org.yellcorp.lib.date.DateUtil;
import org.yellcorp.lib.format.DateFormatUtil;
import org.yellcorp.lib.format.FormatStringError;
import org.yellcorp.lib.format.printf.Format;
import org.yellcorp.lib.format.printf.context.ContextError;
import org.yellcorp.lib.format.printf.context.RenderContext;
import org.yellcorp.lib.format.printf.options.CommonFormatOptions;
import org.yellcorp.lib.format.printf.options.FloatFormatOptions;
import org.yellcorp.lib.format.printf.options.GeneralFormatOptions;
import org.yellcorp.lib.format.printf.options.HexFloatFormatOptions;
import org.yellcorp.lib.format.printf.options.IntegerFormatOptions;
import org.yellcorp.lib.lex.split.SplitLexer;
import org.yellcorp.lib.lex.split.Token;
import org.yellcorp.lib.locale.Locale;
import org.yellcorp.lib.locale.Locale_en;


/**
 * @private
 */
public class PrintfParser
{
    private static var _tokenPattern:RegExp;

    private var field:PrintfFieldProperties;
    private var output:StringBuilder;
    private var context:RenderContext;
    private var lexer:SplitLexer;

    private var _locale:Locale;

    public function PrintfParser()
    {
        lexer = new SplitLexer(getTokenPattern(), true);
        field = new PrintfFieldProperties();
        output = new StringBuilder();
    }

    public function format(formatString:String, args:Array, locale:Locale = null):String
    {
        this.locale = locale;
        context = new RenderContext(args);

        try {
            parse(formatString);
        }
        catch (tokenError:FormatTokenError)
        {
            throw new FormatStringError(
                tokenError.message,
                formatString,
                tokenError.token ? tokenError.token.charIndex : -1);
        }
        return output.toString();
    }

    public function set locale(newLocale:Locale):void
    {
        _locale = newLocale;
    }

    public function get locale():Locale
    {
        if (!_locale) _locale = new Locale_en();
        return _locale;
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
            parseField();
        }
        else if (token.text)
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

        field.clear();

        parsePosition();
        parseFlags();
        parseWidth();

        precisionChar = lexer.currentChar;
        parsePrecision();

        conversionChar = lexer.currentChar;

        try {
            parseConversion();
        }
        catch (ce:ContextError)
        {
            throw new FormatStringError(ce.message, lexer.text, conversionChar);
        }
        catch (pe:PrecisionRangeError)
        {
            throw new FormatStringError(pe.message, lexer.text, precisionChar);
        }
    }

    private function parsePosition():void
    {
        var token:Token = lexer.nextToken();
        var argPosition:int;

        if (token.text)
        {
            argPosition = parseInt(token.text.slice(0, -1));

            if (argPosition == 0)
            {
                throw new FormatTokenError(
                    "Position is a 1-based value and therefore must be greater than zero",
                    token);
            }

            field.argValue.setAbsoluteIndexArg(argPosition - 1, token);
        }
    }

    private function parseFlags():void
    {
        var token:Token = lexer.nextToken();
        var setFlags:Object = { };
        var char:String;

        if (token.text)
        {
            for (var i:int = 0; i < token.text.length; i++)
            {
                char = token.text.charAt(i);
                if (setFlags[char])
                {
                    throw new FormatTokenError(
                        "Flag '" + char + "' already set for this field",
                        token.substr(i, 1));
                }
                else
                {
                    setFlags[char] = true;
                }

                switch (char)
                {
                case '<' :
                    if (field.argValue.isSet)
                    {
                        throw new FormatTokenError(
                            "Flag '<' cannot be used with position specifier",
                            token.substr(i, 1));
                    }
                    else
                    {
                        field.argValue.setLastArg(token.substr(i, 1));
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
                    throw new FormatTokenError(
                        "Interal error: Flag char not handled: " + char,
                        token.substr(i, 1));
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
                    "Number following '.' must be in the range 0,20 for exponential formatting");
            }
            break;

        case 'f' :
            try {
                output.append(formatFixed());
            }
            catch (re:RangeError)
            {
                throw new PrecisionRangeError(
                    "Number following '.' must be in the range 0,20 for fixed formatting");
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
                    "Number following '.' must be in the range 0,21 for precision formatting");
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
                locale.getDayHalf(dateValue.hours).toLocaleLowerCase()));
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
                locale.getMonthName(dateValue.month)));
            break;

        case 'b' :
        case 'h' :
            output.append(formatGeneral(
                locale.getMonthNameShort(dateValue.month)));
            break;

        case 'A' :
            output.append(formatGeneral(
                locale.getDayName(dateValue.day)));
            break;

        case 'a' :
            output.append(formatGeneral(
                locale.getDayNameShort(dateValue.day)));
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
                new PrintfParser().format("%tH:%<tM", [ dateValue ], locale)));
            break;

        case 'T' :
            output.append(formatGeneral(
                new PrintfParser().format("%tH:%<tM:%<tS", [ dateValue ], locale)));
            break;

        case 'r' :
            // "the location of %Tp may be locale-dependent"
            output.append(formatGeneral(
                new PrintfParser().format("%tI:%<tM:%<tS %<Tp", [ dateValue ], locale)));
            break;

        case 'D' :
            output.append(formatGeneral(
                new PrintfParser().format("%tm/%<td/%<ty", [ dateValue ], locale)));
            break;

        case 'F' :
            output.append(formatGeneral(
                new PrintfParser().format("%tY-%<tm-%<td", [ dateValue ], locale)));
            break;

        case 'c' :
            output.append(formatGeneral(
                new PrintfParser().format("%ta %<tb %<td %<tT %<tZ %<tY", [ dateValue ], locale)));
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
        options.setFromLocale(locale);
        options.setFromFlags(field);
        return Format.formatInteger(int(field.argValue.getValue()), options);
    }

    private function formatUnsignedInt(base:int):String
    {
        var options:IntegerFormatOptions = new IntegerFormatOptions();
        options.base = base;
        field.resolve(context, true);
        options.setFromLocale(locale);
        options.setFromFlags(field);
        return Format.formatInteger(uint(field.argValue.getValue()), options);
    }

    private function formatExponential():String
    {
        var options:FloatFormatOptions = new FloatFormatOptions();
        field.resolve(context, true);
        options.setFromLocale(locale);
        options.setFromFlags(field);
        return Format.formatExponential(field.argValue.getValue(), options);
    }

    private function formatFixed():String
    {
        var options:FloatFormatOptions = new FloatFormatOptions();
        field.resolve(context, true);
        options.setFromLocale(locale);
        options.setFromFlags(field);
        return Format.formatFixed(field.argValue.getValue(), options);
    }

    private function formatPrecision():String
    {
        var options:FloatFormatOptions = new FloatFormatOptions();
        field.resolve(context, true);
        options.setFromLocale(locale);
        options.setFromFlags(field);
        return Format.formatPrecision(field.argValue.getValue(), options);
    }

    private function formatHexFloat():String
    {
        var options:HexFloatFormatOptions = new HexFloatFormatOptions();
        field.resolve(context, true);
        options.setFromLocale(locale);
        options.setFromFlags(field);
        return Format.formatHexFloat(field.argValue.getValue(), options);
    }

    private static function getTokenPattern():RegExp
    {
        if (!_tokenPattern)
        {
            _tokenPattern = buildTokenPattern();
        }
        return _tokenPattern;
    }

    private static function buildTokenPattern():RegExp
    {
        // a sequence of digits, followed by $
        var positionArg:String = "(\\d+\\$)?";

        // flags. resolved: < is a flag. java documentation showing
        // < before $ is wrong
        var flags:String =       "([-#+ 0,(<]+)?";
        var width:String =       "(\\d+)?";
        var precision:String =   "(\\.\\d+)?";

        var singleConversions:String = "[bBsScCdoxXeEfgGaAn%]";
        var datePrefix:String = "[tT]";
        var dateConversions:String = "[HIklMSLNpzZsQBbhAaCYyjmdeRTrDFc]";

        var expr:String =
            "(%)" +         // group 1
            positionArg +   // 2
            flags +            // 3
            width +         // 4
            precision +     // 5
            "(" +           // 6
                singleConversions +
            "|" +
                datePrefix +
                dateConversions +
            ")";

        return new RegExp(expr);
    }
}
}
