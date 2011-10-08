package org.yellcorp.lib.string.retokenizer
{
import org.yellcorp.lib.core.RegExpUtil;
import org.yellcorp.lib.core.StringUtil;


public class Tokenizer
{
    private var _regex:RegExp;

    private var _text:String;
    private var _returnUnmatched:Boolean;
    private var _returnWhitespace:Boolean;

    private var cursor:int;
    private var nextMatch:Object;

    public function Tokenizer(regex:RegExp, text:String,
            returnUnmatched:Boolean = true,
            returnWhitespace:Boolean = true)
    {
        _regex = RegExpUtil.changeFlags(regex, { g : true });
        _text = text;
        _returnUnmatched = returnUnmatched;
        _returnWhitespace = returnWhitespace;

        cursor = 0;
    }

    public function get text():String
    {
        return _text;
    }

    public function get returnWhitespace():Boolean
    {
        return _returnWhitespace;
    }

    public function get atEnd():Boolean
    {
        return cursor >= _text.length;
    }

    public function reset():void
    {
        cursor = 0;
        _regex.lastIndex = 0;
    }

    public function next():Token
    {
        var lastCursor:int = cursor;
        var token:Token;

        if (cursor >= _text.length)
        {
            return null;
        }

        if (!nextMatch)
        {
            nextMatch = _regex.exec(_text);
        }

        if (nextMatch)
        {
            if (cursor == nextMatch.index)
            {
                cursor = _regex.lastIndex;
                token = Token.newFromMatch(nextMatch);
                nextMatch = null;
            }
            else
            {
                cursor = nextMatch.index;
                token = checkUnmatchedSubstring(lastCursor, cursor);
            }
        }
        else
        {
            cursor = _text.length;
            token = checkUnmatchedSubstring(lastCursor, cursor);
        }
        return token;
    }

    private function checkUnmatchedSubstring(start:int, end:int):Token
    {
        var substring:String = _text.substring(start, end);
        if (_returnWhitespace || StringUtil.hasContent(substring))
        {
            return Token.newFromString(substring, start);
        }
        else
        {
            return next();
        }
    }
}
}
