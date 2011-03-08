package org.yellcorp.format.printf.lexer
{
public class Lexer
{
    private static const tokenizer:RegExp = buildTokenExpression();

    private var _text:String;
    private var textTokens:Array;
    private var currentToken:int;
    private var _currentChar:int;

    public function Lexer()
    {
    }

    public function start(text:String):void
    {
        reset();
        _text = text;
        textTokens = text.split(tokenizer);
    }

    public function nextToken():Token
    {
        var currentText:String;
        var token:Token;

        if (currentToken >= textTokens.length)
        {
            token = makeToken("");
        }
        else
        {
            currentText = textTokens[currentToken];
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

    private static function buildTokenExpression():RegExp
    {
        // a sequence of digits, followed by $
        var positionArg:String = "(\\d+\\$)?";

        // flags. resolved: < is a flag. documentation showing
        // < before $ is wrong
        var flags:String =       "([-#+ 0,(<]+)?";
        var width:String =       "(\\d+)?";
        var precision:String =   "(\\.\\d+)?";

        var singleConversions:String = "[bBsScCdoxXeEfgGaAn%]";
        var datePrefix:String = "[tT]";
        var dateConversions:String = "[HIklMSLNpzZsQBbhAaCYyjmdeRTrDFc]";

        var expr:String =
            "(%)" +         // group 1
            positionArg +   // 2
            flags +            // 3
            width +         // 4
            precision +     // 5
            "(" +           // 6
                singleConversions +
            "|" +
                datePrefix +
                dateConversions +
            ")";

        return new RegExp(expr);
    }
}
}
