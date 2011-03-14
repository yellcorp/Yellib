package org.yellcorp.lib.markup.htmlclean
{
import org.yellcorp.lib.core.Set;
import org.yellcorp.lib.markup.html.HTMLReference;
import org.yellcorp.lib.markup.html.HTMLToken;


/**
 * This class is responsible for structural analysis of an HTML
 * document and its conversion into XML.  It makes sure tags are
 * balanced, using HTMLReference to judge whether a tag should be left
 * empty or automatically closed.  It also strips duplicate attributes
 * in open tags.
 *
 */
public class HTMLCleanParser
{
    // a stack of current open tags.  tags are pushed when opened and
    // popped when closed.  a close tag should have the same name as the
    // top-most tag on this stack, otherwise there's some correction to be
    // done.
    private var tokenStack:Array;

    // the output token stream
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
        // convenience function - gets the parsed output stream,
        // then joins all their .text properties into a final
        // output string.  This can be then (hopefully) cast to XML

        return parseToStream(lexTokenStream).map(
            function (token:HTMLToken, ... ignored):String
            {
                return token.text;
            }
        ).join("");
    }

    public function parseToStream(lexTokenStream:Array):Array
    {
        // main function: calls the parse routine for each tag
        // in the input stream
        var tokenStreamReturn:Array;

        tokenStack = [ ];
        tokenStream = [ ];

        for (var i:int = 0; i < lexTokenStream.length; i++)
        {
            parse1(lexTokenStream[i]);
        }

        // close any tags left on the stack
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
        // HTMLToken.TEXT: a text node
        closeTopTagIfEmpty();
        emit(token);
    }

    private function parseTagOpenStart(token:HTMLToken):void
    {
        // HTMLToken.TAG_OPEN_START: The beginning of an open tag.

        // open tags are split into multiple tokens so their attributes
        // can be analyzed

        closeTopTagIfEmpty();
        var top:HTMLToken = getTopTag();

        // In HTML, (as opposed to XHTML) some tags e.g. <li> or <td>
        // don't need to be closed.  The HTML DTD specifies a list of
        // allowable child tags for each parent tag.  If a child tag is
        // not allowed in a parent tag then the parent should be
        // automatically closed
        if (top && !HTMLReference.instance.isTagAllowedInTag(top.name, token.name))
        {
            closeTopTag();

            // recurse -- auto-close as many times as needed
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
        // HTMLToken.TAG_ATTR: Open tag attributes.  Duplicates should
        // be eliminated as they choke the XML parser
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
        // HTMLToken.TAG_OPEN_END: Usually just a > capping off the
        // opening tag
        emit(token);
    }

    private function parseTagOpenEndClose(token:HTMLToken):void
    {
        // HTMLToken.TAG_OPEN_END_CLOSE: End of an empty tag
        // i.e. a /> sequence.
        popTag();
        emit(token);
    }

    private function parseTagClose(token:HTMLToken):void
    {
        // HTMLToken.TAG_CLOSE: closing tag
        if (getTopTag().name == token.name)
        {
            // if it matches the top tag, then it's simple
            popTag();
            emit(token);
        }
        else
        {
            // otherwise hand it off to this function
            parseUnmatchedTagClose(token);
        }
    }

    private function parseUnmatchedTagClose(token:HTMLToken):void
    {
        var closedToken:HTMLToken;

        // if there's a possible match in the stack - close all the
        // intermediate tags as well.  this for example turns:
        //
        // <table><tr><td>text</table>
        //
        // into:
        //
        // <table><tr><td>text</td></tr></table>

        if (stackContains(token.name))
        {
            do
            {
                closedToken = closeTopTag();
            }
            while (closedToken.name != token.name);
        }
        // otherwise just ignore it if it was never opened
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
        // ignore it
    }

    private function parseProcInstr(token:HTMLToken):void
    {
        // ignore it
    }

    private function getTopTag():HTMLToken
    {
        return tokenStack.length > 0 ? tokenStack[tokenStack.length - 1] : null;
    }

    private function closeTopTag():HTMLToken
    {
        // pop the tag stack, generate a close token with
        // its name, and emit it
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
        // checks the tag on the top of the stack and closes it if
        // HTML defines it as empty.  Examples of empty tags are <img>,
        // <meta>, <input>
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
