package org.yellcorp.lib.format.geo
{
import org.yellcorp.lib.format.FormatStringError;
import org.yellcorp.lib.format.geo.renderer.Literal;
import org.yellcorp.lib.format.geo.renderer.NumberRenderer;
import org.yellcorp.lib.format.geo.renderer.Renderer;
import org.yellcorp.lib.format.geo.renderer.SignRenderer;
import org.yellcorp.lib.lex.split.SplitLexer;
import org.yellcorp.lib.lex.split.Token;


internal class GeoParser
{
    private static var lexer:SplitLexer = new SplitLexer(buildTokenExpression());

    private var renderers:Array;
    private var field:GeoFieldProperties;
    private var state:Function;

    public function GeoParser()
    {
        field = new GeoFieldProperties();
    }

    public function parse(formatString:String):Array
    {
        var returnRenderers:Array;

        lexer.start(formatString);
        renderers = [ ];
        state = startState;
        while (!lexer.atEnd)
        {
            state(lexer.nextToken());
        }
        returnRenderers = renderers.slice();
        renderers = null;
        return returnRenderers;
    }

    private function startState(token:Token):void
    {
        if (token.text == "%")
        {
            field.clear();
            state = beginFieldState;
        }
        else if (token.text)
        {
            renderers.push(new Literal(token.text));
        }
    }

    private function beginFieldState(token:Token):void
    {
        var initial:String = token.text.charAt(0);
        if (initial == '0')
        {
            field.zeroPad = true;
            setWidth(token);
            state = afterWidth;
        }
        else if (initial >= '1' && initial <= '9')
        {
            setWidth(token);
            state = afterWidth;
        }
        else if (initial == ".")
        {
            setPrecision(token);
            state = afterPrecision;
        }
        else
        {
            createRenderer(token);
            state = startState;
        }
    }

    private function afterWidth(token:Token):void
    {
        var initial:String = token.text.charAt(0);
        if (initial == ".")
        {
            setPrecision(token);
            state = afterPrecision;
        }
        else
        {
            createRenderer(token);
            state = startState;
        }
    }

    private function afterPrecision(token:Token):void
    {
        createRenderer(token);
        state = startState;
    }

    private function setWidth(token:Token):void
    {
        field.minWidth = parseInt(token.text, 10);
    }

    private function setPrecision(token:Token):void
    {
        field.precision = parseInt(token.text.substr(1), 10);
    }

    private function createRenderer(token:Token):void
    {
        if (!token.text)
        {
            throw new FormatStringError(
                "Encountered field without conversion specifier",
                lexer.text, lexer.currentChar);
        }
        renderers.push(createRendererFromSpecifier(token.text));
    }

    private function createRendererFromSpecifier(text:String):Renderer
    {
        switch (text)
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
            return new Literal("\u00B0");
        case "'" :
            return new Literal("\u2032");
        case "''" :
            return new Literal("\u2033");
        case '%' :
            return new Literal("%");
        default :
            return null;
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
