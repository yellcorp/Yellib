package org.yellcorp.format.printf.parser
{
import org.yellcorp.error.AssertError;
import org.yellcorp.format.printf.FormatError;
import org.yellcorp.format.printf.context.RenderContext;
import org.yellcorp.format.printf.format.CommonFormatOptions;
import org.yellcorp.format.printf.format.FloatFormatOptions;
import org.yellcorp.format.printf.format.Format;
import org.yellcorp.format.printf.format.GeneralFormatOptions;
import org.yellcorp.format.printf.format.HexFloatFormatOptions;
import org.yellcorp.format.printf.format.IntegerFormatOptions;
import org.yellcorp.format.printf.lexer.Lexer;
import org.yellcorp.format.printf.lexer.Token;
import org.yellcorp.sequence.Set;
import org.yellcorp.string.StringBuilder;
import org.yellcorp.string.StringUtil;


public class Parser
{
    private var lexer:Lexer;
    private var field:FieldProperties;
    private var output:StringBuilder;
    private var context:RenderContext;

    public function Parser()
    {
        lexer = new Lexer();
        output = new StringBuilder();
    }

    public function format(formatString:String, args:Array):String
    {
        context = new RenderContext(args);

        try {
            parse(formatString);
        }
        catch (tokenError:FormatTokenError)
        {
            throw new FormatError(
                tokenError.message,
                formatString,
                tokenError.token.charIndex);
        }
        return output.toString();
    }

    private function parse(text:String):void
    {
        output.clear();
        lexer.start(text);
        field = new FieldProperties();

        while (!lexer.atEnd)
        {
            parseToken();
        }
    }

    private function parseToken():void
    {
        var token:Token = lexer.nextToken();

        field.clear();

        if (token.text == "%")
        {
            parseField();
        }
        else
        {
            output.append(token.text);
        }
    }

    private function parseField():void
    {
        parsePosition();
        parseFlags();
        parseWidth();
        parsePrecision();
        parseConversion();
    }

    private function parsePosition():void
    {
        var token:Token = lexer.nextToken();
        var argPosition:int;

        if (token.text)
        {
            AssertError.assert(StringUtil.endsWith(token.text, "$"),
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
            AssertError.assert(StringUtil.startsWith(token.text, "."),
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
            output.append("%");
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
            output.append(formatExponential());
            break;

        case 'f' :
            output.append(formatFixed());
            break;

        case 'g' :
        case 'G' :
            output.append(formatAdaptiveFloat());
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

    private function formatGeneral(text:String):String
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
        return Format.formatExponential(uint(field.argValue.getValue()), options);
    }

    private function formatFixed():String
    {
        var options:FloatFormatOptions = new FloatFormatOptions();
        field.resolve(context, true);
        options.setFromFlags(field);
        return Format.formatFixed(field.argValue.getValue(), options);
    }

    private function formatAdaptiveFloat():String
    {
        var options:FloatFormatOptions = new FloatFormatOptions();
        field.resolve(context, true);
        options.setFromFlags(field);
        return Format.formatAdaptiveFloat(field.argValue.getValue(), options);
    }

    private function formatHexFloat():String
    {
        var options:HexFloatFormatOptions = new HexFloatFormatOptions();
        field.resolve(context, true);
        options.setFromFlags(field);
        return Format.formatHexFloat(field.argValue.getValue(), options);
    }
}
}
