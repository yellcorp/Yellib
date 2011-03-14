package org.yellcorp.lib.format.template.lexer
{
import org.yellcorp.lib.core.RegExpUtil;


public class UniversalEscapeLexer implements Lexer
{
    private var _open:String;
    private var _close:String;
    private var _escapeChar:String;

    private var tokenizer:RegExp;

    private var _inputString:String;
    private var tokens:Array;
    private var currentToken:int;
    private var _currentChar:int;
    private var openTokenType:String;

    public function UniversalEscapeLexer(open:String, close:String, escapeChar:String)
    {
        _open = open;
        _close = close;
        _escapeChar = escapeChar;
        validate();
        createTokenizer();
    }

    public function start(string:String):void
    {
        _inputString = string;
        tokens = _inputString.split(tokenizer);
        currentToken = 0;
    }

    public function nextToken():Token
    {
        var text:String;

        if (currentToken < tokens.length)
        {
            text = tokens[currentToken++];
            _currentChar += text.length;

            if (text == "")
            {
                return nextToken();
            }
            else if (text.charAt(0) == _escapeChar)
            {
                return new Token(Token.TEXT, text.substr(1));
            }
            else if (text == _open)
            {
                return new Token(openTokenType, text);
            }
            else if (text == _close)
            {
                return new Token(Token.CLOSE, text);
            }
            else
            {
                return new Token(Token.TEXT, text);
            }
        }
        else
        {
            return new Token(Token.END);
        }
    }

    public function get currentChar():int
    {
        return _currentChar;
    }

    public function get inputString():String
    {
        return _inputString;
    }

    private function validate():void
    {
        if (!_escapeChar || _escapeChar.length != 1)
        {
            throw new ArgumentError("escapeChar must be a String of length 1");
        }

        if (_open.charAt(0) == _escapeChar || _close.charAt(0) == _escapeChar)
        {
            throw new ArgumentError("UniversalEscapeLexer doesn't support an escapeChar that also begins the open or close sequence");
        }
    }

    private function createTokenizer():void
    {
        var alternates:Array = [ ];
        var expr:String;

        // escape token has to capture the character it escapes as well,
        // otherwise the split will still match open or close sequence
        alternates.push(RegExpUtil.escapeRegExp(_escapeChar) + ".");

        alternates.push(RegExpUtil.escapeRegExp(_open));
        if (_open != _close)
        {
            alternates.push(RegExpUtil.escapeRegExp(_close));
        }

        expr = "(" + alternates.join("|") + ")";

        tokenizer = new RegExp(expr);

        openTokenType = _open == _close ? Token.TOGGLE : Token.OPEN;
    }
}
}
