package org.yellcorp.format.template.lexer
{
import org.yellcorp.regexp.RegExpUtil;


public class SpecificEscapeLexer implements Lexer
{
    private var _open:String;
    private var _close:String;

    private var _escapedOpen:String;
    private var _escapedClose:String;

    private var tokenizer:RegExp;

    private var _inputString:String;
    private var tokens:Array;
    private var currentToken:int;
    private var _currentChar:int;
    private var openTokenType:String;

    public function SpecificEscapeLexer(open:String, close:String, escapedOpen:String, escapedClose:String)
    {
        _open = open;
        _close = close;
        _escapedOpen = escapedOpen;
        _escapedClose = escapedClose;
        validate();
        createTokenizer();
    }

    public function start(string:String):void
    {
        _inputString = string;
        tokens = _inputString.split(tokenizer);
        currentToken = 0;
        _currentChar = 0;
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
            else if (text == _escapedOpen || text == _escapedClose)
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
        if (_escapedOpen == _open)
        {
            ambiguousError("open", "escapedOpen");
        }
        else if (_escapedOpen == _close)
        {
            ambiguousError("close", "escapedOpen");
        }
        else if (_escapedClose == _open)
        {
            ambiguousError("open", "escapedClose");
        }
        else if (_escapedClose == _close)
        {
            ambiguousError("close", "escapedClose");
        }
    }

    private function createTokenizer():void
    {
        var alternates:Array = [ _escapedOpen, _open ];

        if (_open != _close)
        {
            // escapes have to come first
            alternates.unshift(_escapedClose);
            alternates.push(_close);
        }

        tokenizer = RegExpUtil.createAlternates(alternates, true);

        openTokenType = _open == _close ? Token.TOGGLE : Token.OPEN;
    }

    private static function ambiguousError(a:String, b:String):void
    {
        throw new ArgumentError("Ambiguous token: " + a + " and " + b + " must be different");
    }
}
}
