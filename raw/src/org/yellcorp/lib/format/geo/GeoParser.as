package org.yellcorp.lib.format.geo
{
import org.yellcorp.lib.format.geo.renderer.Literal;
import org.yellcorp.lib.format.geo.renderer.NumberRenderer;
import org.yellcorp.lib.format.geo.renderer.Renderer;
import org.yellcorp.lib.format.geo.renderer.SignRenderer;
import org.yellcorp.lib.string.retokenizer.Token;
import org.yellcorp.lib.string.retokenizer.Tokenizer;


internal class GeoParser
{
    private static var tokenRegex:RegExp;

    private var renderers:Array;
    private var tokenizer:Tokenizer;

    public function GeoParser()
    {
    }

    public function parse(formatString:String):Array
    {
        if (!tokenRegex)
        {
            tokenRegex = buildTokenRegex();
        }
        tokenizer = new Tokenizer(tokenRegex, formatString);
        renderers = [ ];
        while (!tokenizer.atEnd)
        {
            parseToken();
        }

        var returnRenderers:Array = renderers;
        renderers = null;
        return returnRenderers;
    }

    private function parseToken():void
    {
        var token:Token = tokenizer.next();

        if (!token)
        {
            return;
        }
        else if (!token.matched)
        {
            renderers.push(new Literal(token.text));
        }
        else
        {
            renderers.push(createRendererFromToken(token));
        }
    }

    private function createRendererFromToken(token:Token):Renderer
    {
        var width:String = token.getGroup(1);
        var precision:String = token.getGroup(2);
        var specifier:String = token.getGroup(3);

        var field:GeoFieldProperties = new GeoFieldProperties();

        if (width)
        {
            if (width.charAt(0) == '0')
            {
                field.zeroPad = true;
            }
            field.minWidth = parseInt(width, 10);
        }

        if (precision)
        {
            field.precision = parseInt(precision.substr(1), 10);
        }

        return createRendererFromSpecifier(specifier, field);
    }

    private function createRendererFromSpecifier(specifier:String, field:GeoFieldProperties):Renderer
    {
        switch (specifier)
        {
        case 'd' :
            return new NumberRenderer(field, 1, 0, true);
        case 'm' :
            return new NumberRenderer(field, 60, 60, true);
        case 's' :
            return new NumberRenderer(field, 3600, 60, false);
        case '-' :
            return new SignRenderer("", "-");
        case '+' :
            return new SignRenderer("+", "-");
        case 'o' :
            return new SignRenderer("e", "w");
        case 'O' :
            return new SignRenderer("E", "W");
        case 'a' :
            return new SignRenderer("n", "s");
        case 'A' :
            return new SignRenderer("N", "S");
        case '*' :
            return new Literal(String.fromCharCode(0x00B0));
        case "'" :
            return new Literal(String.fromCharCode(0x2032));
        case "''" :
            return new Literal(String.fromCharCode(0x2033));
        case '%' :
            return new Literal("%");
        default:
            throw new Error("Internal error: RegExp match an unhandled conversion specifier");
        }
    }

    private static function buildTokenRegex():RegExp
    {
        var width:String = "(\\d+)?";
        var precision:String = "(\\.\\d+)?";

        var singleCharSpecifiers:String = "[dms\\-+oOaA*%]";
        var primeSequence:String = "''?";

        var expr:String =
            "%" +
            width +         // 1
            precision +     // 2
            "(" +           // 3
                singleCharSpecifiers +
            "|" +
                primeSequence +
            ")";

        return new RegExp(expr);
    }
}
}
