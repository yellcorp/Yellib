package org.yellcorp.lib.format.template
{
import org.yellcorp.lib.core.StringBuilder;
import org.yellcorp.lib.format.template.lexer.Lexer;
import org.yellcorp.lib.format.template.lexer.SpecificEscapeLexer;
import org.yellcorp.lib.format.template.lexer.Token;
import org.yellcorp.lib.format.template.lexer.UniversalEscapeLexer;
import org.yellcorp.lib.format.template.renderer.Field;
import org.yellcorp.lib.format.template.renderer.FieldChain;
import org.yellcorp.lib.format.template.renderer.Literal;


internal class Parser
{
    // parser characteristics
    private var _open:String;
    private var _close:String;
    private var _escapeChar:String;

    // parser state
    private var buffer:StringBuilder;
    private var currentState:Function;

    private var lexer:Lexer;

    // parse result
    private var renderers:Array;

    private var rendererCache:Object;

    public function Parser(open:String, close:String, escapeChar:String)
    {
        _open = open;
        _close = close;
        _escapeChar = escapeChar || "";

        buffer = new StringBuilder();

        validate();
        createTokenizer();
        clearCache();
    }

    public function clearCache():void
    {
        rendererCache = { };
    }

    private function validate():void
    {
        if (!_open || _open.length == 0)
        {
            throw new ArgumentError("open must be a non-empty String");
        }

        if (!_close || _close.length == 0)
        {
            throw new ArgumentError("close must be a non-empty String");
        }

        if (_escapeChar.length > 1)
        {
            throw new ArgumentError("escapeChar cannot contain more than 1 character");
        }
    }

    public function parse(formatString:String):Array
    {
        var currentToken:Token;
        var returnedRenderers:Array;

        returnedRenderers = rendererCache[formatString];

        if (!returnedRenderers)
        {
            reset();

            lexer.start(formatString);

            do
            {
                currentToken = lexer.nextToken();
                currentState(currentToken);
            }
            while (currentToken.type != Token.END);

            returnedRenderers = renderers;
            renderers = null;

            rendererCache[formatString] = returnedRenderers;
        }

        return returnedRenderers;
    }

    public function get open():String
    {
        return _open;
    }

    public function get close():String
    {
        return _close;
    }

    public function get escapeChar():String
    {
        return _escapeChar;
    }

    public function get hash():String
    {
        return getParserHash(_open, _close, _escapeChar);
    }

    public static function getParserHash(open:String, close:String, escapeChar:String):String
    {
        return open.length + open + close.length + close + escapeChar;
    }

    private function createTokenizer():void
    {
        if (_escapeChar.length == 0)
        {
            lexer = new SpecificEscapeLexer(_open, _close,
                    _open.charAt(0) + _open.charAt(0),
                    _close.charAt(0) + _close.charAt(0));
        }
        else if (_escapeChar == _open.charAt(0) || _escapeChar == _close.charAt(0))
        {
            lexer = new SpecificEscapeLexer(_open, _close,
                    _escapeChar + _open,
                    _escapeChar + _close);
        }
        else
        {
            lexer = new UniversalEscapeLexer(_open, _close, _escapeChar);
        }
    }

    private function reset():void
    {
        buffer.clear();
        currentState = stateText;
        renderers = [ ];
    }

    private function stateText(token:Token):void
    {
        switch (token.type)
        {
        case Token.TOGGLE :
        case Token.OPEN :
            pushLiteral();
            currentState = stateField;
            break;

        case Token.END :
            pushLiteral();
            currentState = null;
            break;

        default :
            buffer.append(token.text);
            break;
        }
    }

    private function stateField(token:Token):void
    {
        switch (token.type)
        {
        case Token.TOGGLE :
        case Token.CLOSE :
            pushField();
            currentState = stateText;
            break;

        case Token.END :
            parseError("Unclosed field");
            break;

        default :
            buffer.append(token.text);
            break;
        }
    }

    private function pushLiteral():void
    {
        var text:String = buffer.remove();

        if (text.length > 0)
        {
            renderers.push(new Literal(text));
        }
    }

    private function pushField():void
    {
        var field:String = buffer.remove();

        if (field.indexOf(".") >= 0)
        {
            renderers.push(new FieldChain(field.split(".")));
        }
        else
        {
            renderers.push(new Field(field));
        }
    }

    private function parseError(message:String):void
    {
        throw new TemplateFormatStringError(message, lexer.inputString, lexer.currentChar);
    }
}
}
