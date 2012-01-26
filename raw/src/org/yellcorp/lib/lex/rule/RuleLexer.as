package org.yellcorp.lib.lex.rule
{
import org.yellcorp.lib.core.StringUtil;
import org.yellcorp.lib.error.assert;


public class RuleLexer
{
    private var names:Array;
    private var patterns:Array;
    private var compositePattern:RegExp;

    private var _text:String;
    private var cursor:int;
    private var nextMatch:Object;

    private var _returnUnmatched:Boolean;
    private var _returnWhitespace:Boolean;

    public function RuleLexer(returnUnmatched:Boolean = true, returnWhitespace:Boolean = true)
    {
        patterns = [];
        names = [ "" ];    // make names index 1-based

        _returnUnmatched = returnUnmatched;
        _returnWhitespace = returnWhitespace;
    }

    public function get returnUnmatched():Boolean
    {
        return _returnUnmatched;
    }

    public function get returnWhitespace():Boolean
    {
        return _returnWhitespace;
    }

    public function get atEnd():Boolean
    {
        return cursor >= _text.length;
    }

    public function addRule(name:String, pattern:RegExp):void
    {
        patterns.push(pattern);
        names.push(name);
    }

    public function start(text:String):void
    {
        _text = text;
        cursor = 0;
        if (!compositePattern) compositePattern = buildRegex();
        compositePattern.lastIndex = 0;
    }

    public function next():Token
    {
        var lastCursor:int = cursor;

        if (cursor >= _text.length)
        {
            return endToken();
        }

        if (!nextMatch)
        {
            nextMatch = compositePattern.exec(_text);
        }

        if (nextMatch)
        {
            if (cursor == nextMatch.index)
            {
                cursor = compositePattern.lastIndex;
                return createTokenFromNextMatch();
            }
            else
            {
                cursor = nextMatch.index;
                return createTokenFromUnmatched(lastCursor, cursor);
            }
        }
        else
        {
            cursor = _text.length;
            return createTokenFromUnmatched(lastCursor, cursor);
        }
    }

    private function endToken():Token
    {
        var token:Token = new Token();
        token.index = _text.length;
        token.text = "";
        token.type = Token.END;
        return token;
    }

    private function createTokenFromNextMatch():Token
    {
        var token:Token = new Token();
        var match:Object = nextMatch;

        token.text = match[0];
        token.index = cursor;

        for (var i:int = 1; i < names.length; i++)
        {
            if (match[i] !== undefined)
            {
                token.type = names[i];
                break;
            }
        }

        assert(token.type !== null, "All capturing groups were undefined");

        nextMatch = null;
        return token;
    }

    private function createTokenFromUnmatched(start:int, end:int):Token
    {
        if (!_returnUnmatched)
        {
            return next();
        }
        else
        {
            var text:String = _text.substring(start, end);

            if (_returnWhitespace || StringUtil.hasContent(text))
            {
                var token:Token = new Token();
                token.text = text;
                token.index = start;
                token.type = Token.UNMATCHED;
                return token;
            }
            else
            {
                return next();
            }
        }
    }

    private function buildRegex():RegExp
    {
        var groups:Array = patterns.map(patternToCaptureGroup);
        var source:String = groups.join("|");
        return new RegExp(source, "g");
    }

    private function patternToCaptureGroup(pattern:RegExp, i:*, a:*):String
    {
        var inlineFlags:String = "";
        if (pattern.ignoreCase) inlineFlags += "i";
        if (pattern.extended) inlineFlags += "x";
        if (inlineFlags) inlineFlags = "(?" + inlineFlags + ")";
        return "(" + inlineFlags + pattern.source + ")";
    }
}
}
