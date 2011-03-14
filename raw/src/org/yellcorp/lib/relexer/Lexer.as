package org.yellcorp.lib.relexer
{
public class Lexer
{
    private var _text:String;
    private var _tokenizer:RegExp;
    private var textTokens:Array;
    private var currentToken:int;
    private var _currentChar:int;

    public function Lexer(tokenizer:RegExp)
    {
        _tokenizer = tokenizer;
    }

    public function start(text:String):void
    {
        reset();
        _text = text;
        textTokens = text.split(_tokenizer);
    }

    public function nextToken():Token
    {
        var token:Token;

        if (currentToken >= textTokens.length)
        {
            token = makeToken("");
        }
        else
        {
            token = makeToken(textTokens[currentToken]);
            currentToken++;
        }
        _currentChar += token.text.length;

        return token;
    }

    public function get text():String
    {
        return _text;
    }

    public function get currentChar():int
    {
        return _currentChar;
    }

    public function get atEnd():Boolean
    {
        return _currentChar >= _text.length;
    }

    private function reset():void
    {
        _text = null;
        textTokens = null;
        currentToken = 0;
        _currentChar = 0;
    }

    private function makeToken(text:String):Token
    {
        return new Token(text, _currentChar);
    }
}
}
