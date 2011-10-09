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
        textTokens = text.split(_tokenizer).filter(removeNull);
    }

    private function removeNull(s:String, i:*, a:*):Boolean
    {
        return s && s.length > 0;
    }

    public function nextToken():Token
    {
        var token:Token;

        if (currentToken < textTokens.length)
        {
            token = new Token(textTokens[currentToken], _currentChar);
            _currentChar += token.text.length;
            currentToken++;
        }
        else
        {
            token = new Token("", _text.length);
        }

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
        return currentToken >= textTokens.length;
    }

    private function reset():void
    {
        _text = null;
        textTokens = null;
        currentToken = 0;
        _currentChar = 0;
    }
}
}
