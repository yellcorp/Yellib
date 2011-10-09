package org.yellcorp.lib.format.geo
{
import org.yellcorp.lib.error.AssertError;
import org.yellcorp.lib.format.geo.renderer.Literal;
import org.yellcorp.lib.format.geo.renderer.NumberRenderer;
import org.yellcorp.lib.format.geo.renderer.Renderer;
import org.yellcorp.lib.format.geo.renderer.SignRenderer;
import org.yellcorp.lib.string.retokenizer.Token;
import org.yellcorp.lib.string.retokenizer.Tokenizer;


internal class GeoParser
{
    private static var tokenizer:Tokenizer;

    // token names
    private static const PERCENT:String = "per";
    private static const WIDTH:String = "w";
    private static const PRECISION:String = "pre";
    private static const PRIME_SPEC:String = "p";
    private static const NUMERIC_SPEC:String = "n";
    private static const NON_NUMERIC_SPEC:String = "nn";

    private var renderers:Array;
    private var state:Function;

    private var fieldProperties:GeoFieldProperties;

    public function GeoParser()
    {
    }

    public function parse(formatString:String):Array
    {
        if (!tokenizer)
        {
            tokenizer = buildTokenizer();
        }
        tokenizer.start(formatString);
        state = startState;
        renderers = [ ];
        while (!tokenizer.atEnd)
        {
            state(tokenizer.next());
        }
        var returnRenderers:Array = renderers;
        renderers = null;
        return returnRenderers;
    }

    private function startState(token:Token):void
    {
        switch (token.type)
        {
        case Token.END:
            break;
        case PERCENT:
            fieldProperties = new GeoFieldProperties();
            state = fieldStart;
            break;
        default:
            renderers.push(new Literal(token.text));
            break;
        }
    }

    private function fieldStart(token:Token):void
    {
        switch (token.type)
        {
        case WIDTH:
            setFieldWidth(token);
            state = precisionOrNumSpec;
            break;
        case PRECISION:
            setFieldPrecision(token);
            state = numSpec;
            break;
        case PERCENT:
        case PRIME_SPEC:
        case NUMERIC_SPEC:
        case NON_NUMERIC_SPEC:
            createRenderer(token);
            state = startState;
            break;
        case Token.END:
            incompleteError(token);
        default:
            tokenError("Invalid character following %: $c", token);
        }
    }

    private function precisionOrNumSpec(token:Token):void
    {
        switch (token.type)
        {
        case PRECISION:
            setFieldPrecision(token);
            state = numSpec;
            break;
        case NUMERIC_SPEC:
            createRenderer(token);
            state = startState;
            break;
        case Token.END:
            incompleteError(token);
        case PERCENT:
        case PRIME_SPEC:
        case NON_NUMERIC_SPEC:
            tokenError("Specifier $c doesn't support width", token);
        default:
            tokenError("Invalid character following width: $c", token);
        }
    }

    private function numSpec(token:Token):void
    {
        switch (token.type)
        {
        case NUMERIC_SPEC:
            createRenderer(token);
            state = startState;
            break;
        case Token.END:
            incompleteError(token);
        case PERCENT:
        case PRIME_SPEC:
        case NON_NUMERIC_SPEC:
            tokenError("Specifier $c doesn't support precision", token);
        default:
            tokenError("Invalid character following precision: $c", token);
        }
    }

    private function incompleteError(token:Token):void
    {
        throw new GeoFormatError("Incomplete field", token.index);
    }

    private function tokenError(message:String, token:Token):void
    {
        message = message.replace("$c", token.text.charAt(0));
        throw new GeoFormatError(message, token.index);
    }

    private function setFieldWidth(token:Token):void
    {
        fieldProperties.zeroPad = token.text.charAt() == '0';
        fieldProperties.minWidth = parseInt(token.text, 10);
    }

    private function setFieldPrecision(token:Token):void
    {
        fieldProperties.precision = parseInt(token.text.substr(1), 10);
    }

    private function createRenderer(token:Token):void
    {
        var renderer:Renderer;

        switch (token.text)
        {
        case 'd' :
            renderer = new NumberRenderer(fieldProperties, 1, 0, true);
            break;
        case 'm' :
            renderer = new NumberRenderer(fieldProperties, 60, 60, true);
            break;
        case 's' :
            renderer = new NumberRenderer(fieldProperties, 3600, 60, false);
            break;
        case '-' :
            renderer = new SignRenderer("", "-");
            break;
        case '+' :
            renderer = new SignRenderer("+", "-");
            break;
        case 'o' :
            renderer = new SignRenderer("e", "w");
            break;
        case 'O' :
            renderer = new SignRenderer("E", "W");
            break;
        case 'a' :
            renderer = new SignRenderer("n", "s");
            break;
        case 'A' :
            renderer = new SignRenderer("N", "S");
            break;
        case '*' :
            renderer = new Literal(String.fromCharCode(0x00B0));
            break;
        case "'" :
            renderer = new Literal(String.fromCharCode(0x2032));
            break;
        case "''" :
            renderer = new Literal(String.fromCharCode(0x2033));
            break;
        case '%' :
            renderer = new Literal("%");
            break;
        default:
            AssertError.assert(false, "RegExp match an unhandled conversion specifier");
        }
        renderers.push(renderer);
    }

    private static function buildTokenizer():Tokenizer
    {
        var toker:Tokenizer = new Tokenizer(true, true);
        toker.addRule(PERCENT, /%/);
        toker.addRule(PRECISION, /\.\d+/);
        toker.addRule(WIDTH, /\d+/);
        toker.addRule(PRIME_SPEC, /''?/);
        toker.addRule(NUMERIC_SPEC, /[dms]/);
        toker.addRule(NON_NUMERIC_SPEC, /[+oOaA*-]/);
        return toker;
    }
}
}
