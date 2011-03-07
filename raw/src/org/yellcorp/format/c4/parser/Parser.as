package org.yellcorp.format.c4.parser
{
import org.yellcorp.error.AssertError;
import org.yellcorp.format.c4.context.AbsoluteArg;
import org.yellcorp.format.c4.context.ConstantArg;
import org.yellcorp.format.c4.context.RelativeArg;
import org.yellcorp.format.c4.context.RenderContext;
import org.yellcorp.format.c4.errors.FormatStringError;
import org.yellcorp.format.c4.format.CommonFormatOptions;
import org.yellcorp.format.c4.format.FloatFormatOptions;
import org.yellcorp.format.c4.format.Format;
import org.yellcorp.format.c4.format.GeneralFormatOptions;
import org.yellcorp.format.c4.format.HexFloatFormatOptions;
import org.yellcorp.format.c4.format.IntegerFormatOptions;
import org.yellcorp.format.c4.format.SignSet;
import org.yellcorp.format.c4.lexer.Lexer;
import org.yellcorp.format.c4.lexer.Token;
import org.yellcorp.sequence.Set;
import org.yellcorp.string.StringBuilder;
import org.yellcorp.string.StringUtil;


public class Parser
{
    public static const ARG_PTR:int = 0;

    private var lexer:Lexer;
    private var code:Array;
    private var field:FieldProperties;
    private var output:StringBuilder;
    private var context:RenderContext;

    public function Parser()
    {
        lexer = new Lexer();
        field = new FieldProperties();
        output = new StringBuilder();
    }

    public function sprintf(format:String, ... args):String
    {
        context = new RenderContext(args);
        parse(format);
        return output.toString();
    }

    private function parse(text:String):Array
    {
        output.clear();
        lexer.start(text);

        while (!lexer.atEnd)
        {
            parseToken();
        }

        return code;
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

            field.arg = new AbsoluteArg(argPosition);
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
                    tokenError(char + " flag already set for this field", token.substr(i, 1));
                }
                else
                {
                    setFlags.add(char);

                    switch (char)
                    {
                        case '<' :
                            if (field.arg)
                            {
                                tokenError("< flag cannot be used with position specifier", token.substr(i, 1));
                            }
                            else
                            {
                                field.arg = new RelativeArg(-1);
                            }
                            break;
                        case '-' :
                            field.leftJustify.setValue(true, token.substr(i, 1));
                            break;
                        case '#' :
                            field.alternateForm.setValue(true, token.substr(i, 1));
                            break;
                        case '+' :
                            field.positivePrefix.setValue("+", token.substr(i, 1));
                            break;
                        case ' ' :
                            field.positivePrefix.setValue(" ", token.substr(i, 1));
                            break;
                        case '0' :
                            field.paddingChar.setValue("0", token.substr(i, 1));
                            break;
                        case ',' :
                            field.grouping.setValue(true, token.substr(i, 1));
                            break;
                        case '(' :
                            field.negativePrefix.setValue("(", token.substr(i, 1));
                            field.negativeSuffix.setValue(")", token.substr(i, 1));
                            break;
                        default :
                            AssertError.assert(false, "Unhandled flag char " + char);
                            break;
                    }
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
            field.width = new ConstantArg(width);
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
            field.precision = new ConstantArg(precision);
        }
    }

    private function parseConversion():void
    {
        var token:Token = lexer.nextToken();
        var convChar:String;

        if (!token.text)
        {
            tokenError("Encountered field without conversion specifier", token);
        }

        convChar = token.text.charAt(0);
        if (convChar == convChar.toUpperCase())
        {
            field.uppercase.setValue(true, token);
        }

        field.resolve(context);

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
                formatBoolean();
                break;

            case 's' :
            case 'S' :
                formatString();
                break;

            case 'c' :
            case 'C' :
                formatChar();
                break;

            case 'd' :
                formatSignedInt(10);
                break;

            case 'o' :
                formatUnsignedInt(8);
                break;

            case 'x' :
            case 'X' :
                formatUnsignedInt(16);
                break;

            case 'e' :
            case 'E' :
                formatExponential();
                break;

            case 'f' :
                formatFixed();
                break;

            case 'g' :
            case 'G' :
                formatAdaptiveFloat();
                break;

            case 'a' :
            case 'A' :
                formatHexFloat();
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

    private function formatBoolean():void
    {
        formatGeneral(field.arg.value ? "true" : "false");
    }

    private function formatString():void
    {
        formatGeneral(field.arg.value);
    }

    private function formatGeneral(text:String):void
    {
        var options:GeneralFormatOptions = new GeneralFormatOptions();

        options.minWidth = field.width.isSet ? int(field.width.value) : 0;
        options.maxWidth = field.precision.isSet ? int(field.precision.value) : -1;
        options.leftJustify = field.leftJustify.value;
        options.uppercase = field.uppercase.value;

        // not supported: positive*, negative*, zeroPad, grouping

        output.append(Format.formatGeneral(text, options));
    }

    private function formatChar():void
    {
        var options:CommonFormatOptions = new CommonFormatOptions();

        options.minWidth = field.width.isSet ? int(field.width.value) : 0;
        options.leftJustify = field.leftJustify.value;
        options.uppercase = field.uppercase.value;

        output.append(Format.formatChar(field.arg.value, options));
    }

    private function formatSignedInt(base:int):void
    {
        formatInteger(int(field.arg.value), base);
    }

    private function formatUnsignedInt(base:int):void
    {
        formatInteger(uint(field.arg.value), base);
    }

    private function formatInteger(value:Number, base:int):void
    {
        var options:IntegerFormatOptions = new IntegerFormatOptions();

        options.minWidth = field.width.isSet ? field.width.value : 0;

        // changed from java to c: support precision to mean 'minimum number
        // of digits to output'
        options.minDigits = field.precision.isSet ? field.precision.value : 0;

        if (field.alternateForm.value)
        {
            switch (base)
            {
                case 8 :
                    options.radixPrefix = "0";
                    break;

                case 16 :
                    options.radixPrefix = "0x";
                    break;

                default :
                    // TODO: error
                    break;
            }
        }

        options.paddingChar = field.paddingChar.value;
        options.grouping = field.grouping.value;

        options.signs = new SignSet(field.positivePrefix.value, "", field.negativePrefix.value, field.negativeSuffix.value);

        options.leftJustify = field.leftJustify.value;
        options.uppercase = field.uppercase.value;

        output.append(Format.formatInteger(value, options));
    }

    private function formatExponential():void
    {
        var options:FloatFormatOptions = new FloatFormatOptions();
        copyFloatFormatOptions(options);
        output.append(Format.formatExponential(field.arg.value, options));
    }

    private function formatFixed():void
    {
        var options:FloatFormatOptions = new FloatFormatOptions();
        copyFloatFormatOptions(options);
        output.append(Format.formatFixed(field.arg.value, options));
    }

    private function formatAdaptiveFloat():void
    {
        var options:FloatFormatOptions = new FloatFormatOptions();
        copyFloatFormatOptions(options);
        output.append(Format.formatAdaptiveFloat(field.arg.value, options));
    }

    private function formatHexFloat():void
    {
        var options:HexFloatFormatOptions = new HexFloatFormatOptions();
        copyFloatFormatOptions(options);
        output.append(Format.formatHexFloat(field.arg.value, options));
    }

    private function copyFloatFormatOptions(target:FloatFormatOptions):void
    {
        var options:FloatFormatOptions = new FloatFormatOptions();

        options.minWidth = field.width.isSet ? field.width.value : 0;
        options.fracWidth = field.precision.isSet ? field.precision.value : 6;
        options.forceDecimalSeparator = field.alternateForm.value;

        options.paddingChar = field.paddingChar.value;
        options.grouping = field.grouping.value;

        options.signs = new SignSet(field.positivePrefix.value, "", field.negativePrefix.value, field.negativeSuffix.value);

        options.leftJustify = field.leftJustify.value;
        options.uppercase = field.uppercase.value;
    }

    private function tokenError(message:String, token:Token):void
    {
        throw new FormatStringError(message, lexer.text, token.charIndex);
    }
}
}
