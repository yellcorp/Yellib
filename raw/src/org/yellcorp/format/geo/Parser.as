package org.yellcorp.format.geo
{
import org.yellcorp.format.FormatStringError;
import org.yellcorp.format.geo.renderer.Literal;
import org.yellcorp.format.geo.renderer.NumberRenderer;
import org.yellcorp.format.geo.renderer.SignRenderer;
import org.yellcorp.format.relexer.Lexer;
import org.yellcorp.format.relexer.Token;


internal class Parser
{
    private static var lexer:Lexer = new Lexer(buildTokenExpression());
    private var renderers:Array;
    private var field:FieldProperties;

    public function Parser()
    {
        field = new FieldProperties();
    }

    public function parse(formatString:String):Array
    {
        var returnRenderers:Array;

        lexer.start(formatString);
        renderers = [ ];
        while (!lexer.atEnd)
        {
            parseToken();
        }
        returnRenderers = renderers.slice();
        renderers = null;
        return returnRenderers;
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
            renderers.push(new Literal(token.text));
        }
    }

    private function parseField():void
    {
        field.clear();
        parseWidth();
        parsePrecision();
        parseConversion();
    }

    private function parseWidth():void
    {
        var token:Token = lexer.nextToken();
        if (token.text)
        {
            if (token.text.charAt(0) == '0')
            {
                field.zeroPad = true;
            }
            field.minWidth = parseInt(token.text);
        }
    }

    private function parsePrecision():void
    {
        var token:Token = lexer.nextToken();

        if (token.text)
        {
            field.precision = parseInt(token.text.substr(1));
        }
    }

    private function parseConversion():void
    {
        var token:Token = lexer.nextToken();

        if (!token.text)
        {
            throw new FormatStringError(
                "Encountered field without conversion specifier",
                lexer.text, lexer.currentChar);
        }

        switch (token.text)
        {
        case 'd' :
            renderers.push(new NumberRenderer(field, 1, 0, true));
            break;

        case 'm' :
            renderers.push(new NumberRenderer(field, 60, 60, true));
            break;

        case 's' :
            renderers.push(new NumberRenderer(field, 3600, 60, false));
            break;

        case '-' :
            renderers.push(new SignRenderer("", "-"));
            break;

        case '+' :
            renderers.push(new SignRenderer("+", "-"));
            break;

        case 'o' :
            renderers.push(new SignRenderer("e", "w"));
            break;

        case 'O' :
            renderers.push(new SignRenderer("E", "W"));
            break;

        case 'a' :
            renderers.push(new SignRenderer("n", "s"));
            break;

        case 'A' :
            renderers.push(new SignRenderer("N", "S"));
            break;

        case '*' :
            renderers.push(new Literal(String.fromCharCode(0x00B0)));
            break;

        case "'" :
            renderers.push(new Literal(String.fromCharCode(0x2032)));
            break;

        case "''" :
            renderers.push(new Literal(String.fromCharCode(0x2033)));
            break;

        case '%' :
            renderers.push(new Literal("%"));
            break;
        }
    }

    private static function buildTokenExpression():RegExp
    {
        var width:String = "(\\d+)?";
        var precision:String = "(\\.\\d+)?";

        var singleConversions:String = "[dms\\-+oOaA*%]";
        var primeSequence:String = "''?";

        var expr:String =
            "(%)" +         // group 1
            width +         // 2
            precision +     // 3
            "(" +           // 4
                singleConversions +
            "|" +
                primeSequence +
            ")";

        return new RegExp(expr);
    }
}
}
