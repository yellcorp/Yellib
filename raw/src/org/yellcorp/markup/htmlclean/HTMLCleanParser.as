package org.yellcorp.markup.htmlclean
{
import org.yellcorp.markup.html.HTMLReference;
import org.yellcorp.markup.html.HTMLToken;
import org.yellcorp.sequence.Set;


public class HTMLCleanParser
{
    private var tokenStack:Array;
    private var tokenStream:Array;

    private var dispatch:Object;
    private var seenAttrs:Set;

    public function HTMLCleanParser()
    {
        dispatch = { };
        dispatch[HTMLToken.TEXT] = parseText;
        dispatch[HTMLToken.TAG_OPEN_START] = parseTagOpenStart;
        dispatch[HTMLToken.TAG_ATTR] = parseTagAttr;
        dispatch[HTMLToken.TAG_OPEN_END] = parseTagOpenEnd;
        dispatch[HTMLToken.TAG_OPEN_END_CLOSE] = parseTagOpenEndClose;
        dispatch[HTMLToken.TAG_CLOSE] = parseTagClose;
        dispatch[HTMLToken.CDATA] = parseCData;
        dispatch[HTMLToken.COMMENT] = parseComment;
        dispatch[HTMLToken.DECLARATION] = parseDeclaration;
        dispatch[HTMLToken.PROC_INSTR] = parseProcInstr;
    }

    public function parse(lexTokenStream:Array):String
    {
        return parseToStream(lexTokenStream).map(
            function (token:HTMLToken, ... ignored):String
            {
                return token.text;
            }
        ).join("");
    }

    public function parseToStream(lexTokenStream:Array):Array
    {
        var tokenStreamReturn:Array;

        tokenStack = [ ];
        tokenStream = [ ];

        for (var i:int = 0; i < lexTokenStream.length; i++)
        {
            parse1(lexTokenStream[i]);
        }

        while (tokenStack.length > 0)
        {
            closeTopTag();
        }

        tokenStreamReturn = tokenStream;
        tokenStream = [ ];
        return tokenStreamReturn;
    }

    private function parse1(token:HTMLToken):void
    {
        dispatch[token.type](token);
    }

    private function parseText(token:HTMLToken):void
    {
        closeTopTagIfEmpty();
        emit(token);
    }

    private function parseTagOpenStart(token:HTMLToken):void
    {
        closeTopTagIfEmpty();
        var top:HTMLToken = getTopTag();
        if (top && HTMLReference.instance.isTagClosedBy(top.name, token.name))
        {
            closeTopTag();
            parseTagOpenStart(token);
        }
        else
        {
            pushTag(token);
            seenAttrs = new Set();
            emit(token);
        }
    }

    private function parseTagAttr(token:HTMLToken):void
    {
        var spacer:HTMLToken;
        if (!seenAttrs.contains(token.name))
        {
            seenAttrs.add(token.name);
            emit(token);
        }
        else
        {
            spacer = new HTMLToken();
            spacer.type = HTMLToken.TAG_ATTR;
            spacer.text = " ";
            emit(spacer);
        }
    }

    private function parseTagOpenEnd(token:HTMLToken):void
    {
        emit(token);
    }

    private function parseTagOpenEndClose(token:HTMLToken):void
    {
        popTag();
        emit(token);
    }

    private function parseTagClose(token:HTMLToken):void
    {
        if (getTopTag().name == token.name)
        {
            popTag();
            emit(token);
        }
        else
        {
            parseUnmatchedTagClose(token);
        }
    }

    private function parseUnmatchedTagClose(token:HTMLToken):void
    {
        var closedToken:HTMLToken;
        if (stackContains(token.name))
        {
            do
            {
                closedToken = closeTopTag();
            }
            while (closedToken.name != token.name);
        }
        // else just ignore it if it was never opened
    }

    private function stackContains(tagType:String):Boolean
    {
        for (var i:int = tokenStack.length - 1; i >= 0; i--)
        {
            if (HTMLToken(tokenStack[i]).name == tagType) return true;
        }
        return false;
    }

    private function parseCData(token:HTMLToken):void
    {
        closeTopTagIfEmpty();
        emit(token);
    }

    private function parseComment(token:HTMLToken):void
    {
        emit(token);
    }

    private function parseDeclaration(token:HTMLToken):void
    {
        // ignore
    }

    private function parseProcInstr(token:HTMLToken):void
    {
        // squash it
    }

    private function getTopTag():HTMLToken
    {
        return tokenStack.length > 0 ? tokenStack[tokenStack.length - 1] : null;
    }

    private function closeTopTag():HTMLToken
    {
        var tag:HTMLToken = popTag();

        if (!tag) return null;

        var close:HTMLToken = new HTMLToken();

        close.type = HTMLToken.TAG_CLOSE;
        close.name = tag.name;
        close.text = "</" + close.name + ">";

        emit(close);
        return close;
    }

    private function closeTopTagIfEmpty():HTMLToken
    {
        var topTag:HTMLToken = getTopTag();
        if (topTag && HTMLReference.instance.isEmptyTag(getTopTag().name))
        {
            return closeTopTag();
        }
        else
        {
            return null;
        }
    }

    private function pushTag(token:HTMLToken):void
    {
        tokenStack.push(token);
    }

    private function popTag():HTMLToken
    {
        if (tokenStack.length == 0)
        {
            trace("popTag: tokenStack empty");
            return null;
        }
        else
        {
            return tokenStack.pop();
        }
    }

    private function emit(token:HTMLToken):void
    {
        tokenStream.push(token);
    }
}
}
