package org.yellcorp.lib.lex.split
{
public class SplitLexer
{
    private var _text:String;
    private var _tokenizer:RegExp;
    private var textTokens:Array;
    private var currentToken:int;
    private var _currentChar:int;
    private var keepNulls:Boolean;

    public function SplitLexer(tokenizer:RegExp, keepNulls:Boolean = false)
    {
        _tokenizer = tokenizer;
        this.keepNulls = keepNulls;
    }

    public function start(text:String):void
    {
        reset();
        _text = text;

        if (keepNulls)
        {
            textTokens = text.split(_tokenizer).map(normalizeNulls);
        }
        else
        {
            textTokens = text.split(_tokenizer).filter(removeNulls);
        }
    }

    private function removeNulls(s:String, i:*, a:*):Boolean
    {
        return s && s.length > 0;
    }

    private function normalizeNulls(s:String, i:*, a:*):String
    {
        return s || "";
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
