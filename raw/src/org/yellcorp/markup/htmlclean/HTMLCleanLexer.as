package org.yellcorp.markup.htmlclean
{
import org.yellcorp.markup.html.HTMLReference;
import org.yellcorp.markup.html.HTMLToken;
import org.yellcorp.markup.htmlclean.errors.HTMLCleanLexError;
import org.yellcorp.markup.htmlclean.errors.HTMLCleanSyntaxError;


public class HTMLCleanLexer
{
    private static const TEXT:int = 0;
    private static const TAG_START:int = 1;
    private static const TAG_OPEN:int = 2;
    private static const TAG_EXCL:int = 3;
    private static const TAG_OPEN_TRAILER:int = 4;
    private static const TAG_ATTR_NAME:int = 5;
    private static const TAG_ATTR_EQUALS:int = 6;
    private static const TAG_ATTR_QUOTED_VALUE:int = 7;
    private static const TAG_ATTR_BARE_VALUE:int = 8;
    private static const TAG_CLOSE:int = 9;
    private static const TAG_CLOSE_TRAILER:int = 10;
    private static const CDATA_CONTENT:int = 11;  // <![CDATA[
    private static const COMMENT:int = 12;          // <!--
    private static const COMMENT_CLOSE:int = 13;  // -->
    private static const DECLARATION:int = 14;    // <!
    private static const PROC_INSTR:int = 15;     // <?

    private static const EMIT_NAME:int = 1;
    private static const EMIT_VALUE:int = 2;
    private static const EMIT_TEXT:int = 4;

    private static const RETRY_COMMENT_CLOSE:String = "RETRY_COMMENT_CLOSE";
    private static const RETRY_PI_CLOSE:String = "RETRY_PI_CLOSE";

    private var source:String;
    private var cursor:int;
    private var sourceLen:int;
    private var state:int;
    private var dispatch:Array;

    private var quote:String;
    private var stateStack:Array;

    private var currentToken:HTMLToken;
    private var tokenStream:Array;

    private var _errorHistory:Array;

    public function HTMLCleanLexer()
    {
        dispatch = [];
        dispatch[TEXT] = lexTextChar;
        dispatch[TAG_START] = lexTagStart;
        dispatch[TAG_OPEN] = lexTagOpen;
        dispatch[TAG_EXCL] = lexTagExcl;
        dispatch[TAG_OPEN_TRAILER] = lexTagOpenTrailer;
        dispatch[TAG_ATTR_NAME] = lexTagAttrName;
        dispatch[TAG_ATTR_EQUALS] = lexTagAttrEquals;
        dispatch[TAG_ATTR_QUOTED_VALUE] = lexTagAttrQuotedValue;
        dispatch[TAG_ATTR_BARE_VALUE] = lexTagAttrBareValue;
        dispatch[TAG_CLOSE] = lexTagClose;
        dispatch[TAG_CLOSE_TRAILER] = lexTagCloseTrailer;
        dispatch[CDATA_CONTENT] = lexCDataContent;
        dispatch[COMMENT] = lexComment;
        dispatch[COMMENT_CLOSE] = lexCommentClose;
        dispatch[DECLARATION] = lexDeclaration;
        dispatch[PROC_INSTR] = lexProcInstr;
    }

    public function lex(dirtyHTML:String):Array
    {
        var tokenStreamReturn:Array;

        stateStack = [ ];
        tokenStream = [ ];
        _errorHistory = [ ];
        source = dirtyHTML;
        sourceLen = dirtyHTML.length;
        cursor = 0;
        state = TEXT;
        currentToken = new HTMLToken();

        // note: the following <= is deliberate; we want the parser
        // routines to detect the end of the text stream
        while (cursor <= sourceLen)
        {
            try {
                dispatch[state]();
            }
            catch (se:HTMLCleanSyntaxError)
            {
                _errorHistory.push(se);
                popState();
            }
        }

        tokenStreamReturn = tokenStream;
        tokenStream = [ ];
        stateStack = [ ];
        return tokenStreamReturn;
    }

    public function get errorHistory():Array
    {
        return _errorHistory.slice();
    }

    private function lexTextChar():void
    {
        var char:String = getch();

        if (char == "<")
        {
            // could be literal <
            pushState(getEntityRepr(char));

            pushToken(HTMLToken.TEXT);
            emit(char);
            state = TAG_START;
        }
        else if (char == "&")
        {
            // could be literal &
            pushState(getEntityRepr(char));

            putback();
            emit(getEntity());
        }
        else if (getEntityRepr(char))
        {
            emit(getEntityRepr(char));
        }
        else if (char == "")
        {
            pushToken(HTMLToken.TEXT);
        }
        else
        {
            emit(char);
        }
    }

    private function lexTagStart():void
    {
        skipWhiteSpace();
        var char:String = getch();

        if (isNameStartChar(char))
        {
            putback();
            state = TAG_OPEN;
        }
        else if (char == "/")
        {
            emit(char);
            state = TAG_CLOSE;
        }
        else if (char == "!")
        {
            emit(char);
            state = TAG_EXCL;
        }
        else if (char == "?")
        {
            emit(char);
            state = PROC_INSTR;
        }
        else
        {
            fail("Illegal character following opening tag delimeter <");
        }
    }

    private function lexTagOpen():void
    {
        skipWhiteSpace();
        var tagName:String = getName().toLowerCase();
        emit(tagName, EMIT_TEXT | EMIT_NAME);
        pushToken(HTMLToken.TAG_OPEN_START);
        state = TAG_OPEN_TRAILER;

        // could be a tag missing a closing > without attributes.
        // this attempt will take precedence over the previous
        // alternate, which is to try changing < to &lt;
        // use isAttrOptionalTag to see which is more likely.
        if (HTMLReference.instance.isAttrOptionalTag(tagName))
        {
            pushState(">");
        }
    }

    private function lexTagClose():void
    {
        skipWhiteSpace();
        var tagName:String = getName().toLowerCase();
        emit(tagName, EMIT_TEXT | EMIT_NAME);
        state = TAG_CLOSE_TRAILER;
    }

    private function lexTagCloseTrailer():void
    {
        skipWhiteSpace();
        var char:String = getch();

        if (char != ">")
            putback();

        emit(">");
        pushToken(HTMLToken.TAG_CLOSE);
        state = TEXT;
    }

    private function lexTagOpenTrailer():void
    {
        var char:String = getch();
        if (isSpace(char))
        {
            emit(char);
            state = TAG_ATTR_NAME;
        }
        else if (char == "/")
        {
            if (getch() == ">")
            {
                emit("/>");
                pushToken(HTMLToken.TAG_OPEN_END_CLOSE);
                state = TEXT;
            }
            else
            {
                fail("/ in tag not followed by >");
            }
        }
        else if (char == ">")
        {
            emit(char);
            pushToken(HTMLToken.TAG_OPEN_END);
            state = TEXT;
        }
        else
        {
            fail("Illegal character following tag name");
        }
    }

    private function lexTagAttrName():void
    {
        skipWhiteSpace();
        var char:String = getch();

        if (isNameStartChar(char))
        {
            putback();
            emit(getName().toLowerCase(), EMIT_TEXT | EMIT_NAME);
            state = TAG_ATTR_EQUALS;
        }
        else if (char == ">")
        {
            emit(char);
            pushToken(HTMLToken.TAG_OPEN_END);
            state = TEXT;
        }
        else if (char == "")
        {
            emit(">");
            pushToken(HTMLToken.TAG_OPEN_END);
            state = TEXT;
        }
        else if (char == "/")
        {
            if (getch() == ">")
            {
                emit("/>");
                pushToken(HTMLToken.TAG_OPEN_END_CLOSE);
                state = TEXT;
            }
            else
            {
                fail("/ in tag not followed by >");
            }
        }
        else
        {
            fail("Illegal character in attribute name");
        }
    }

    private function lexTagAttrEquals():void
    {
        skipWhiteSpace();
        var char:String = getch();
        if (char == "=")
        {
            emit(char);
            skipWhiteSpace();
            char = getch();
            if (char == '"' || char == "'")
            {
                emit(char);
                quote = char;
                state = TAG_ATTR_QUOTED_VALUE;
            }
            else
            {
                putback();
                emit('"');
                quote = '"';
                state = TAG_ATTR_BARE_VALUE;
            }
        }
        else
        {
            putback();

            emit('="true"', EMIT_TEXT);
            emit("true", EMIT_VALUE);

            pushToken(HTMLToken.TAG_ATTR);
            state = TAG_ATTR_NAME;
        }
    }

    private function lexTagAttrQuotedValue():void
    {
        var char:String = getch();
        var entity:String;

        if (char == quote)
        {
            // could be close quote without close tag
            pushState(quote + ">");

            // could be quote-within-quote
            // more likely, so push this last
            pushState(getEntityRepr(char));

            emit(char);
            pushToken(HTMLToken.TAG_ATTR);
            state = TAG_ATTR_NAME;
        }
        else if (char == "")
        {
            emit(quote);
            pushToken(HTMLToken.TAG_ATTR);
            state = TAG_ATTR_NAME;
        }
        else if (char == ">")
        {
            // could be close tag without close quote
            pushState(quote + ">");

            emit(getEntityRepr(char), EMIT_TEXT | EMIT_VALUE);
        }
        else if (char == "&")
        {
            // could be literal &
            pushState(getEntityRepr(char));

            putback();
            entity = getEntity();
            emit(entity, EMIT_TEXT | EMIT_VALUE);
        }
        else if (getEntityRepr(char))
        {
            emit(getEntityRepr(char), EMIT_TEXT | EMIT_VALUE);
        }
        else
        {
            emit(char, EMIT_TEXT | EMIT_VALUE);
        }
    }

    private function lexTagAttrBareValue():void
    {
        var char:String = getch();
        var entity:String;

        if (isSpace(char))
        {
            putback();
            emit(quote);
            pushToken(HTMLToken.TAG_ATTR);
            state = TAG_ATTR_NAME;
        }
        else if (char == "&")
        {
            pushState(getEntityRepr(char));
            putback();
            entity = getEntity();
            emit(entity, EMIT_TEXT | EMIT_VALUE);
        }
        else if (char == ">")
        {
            pushState(getEntityRepr(char));
            emit(quote);
            pushToken(HTMLToken.TAG_ATTR);
            emit(char);
            pushToken(HTMLToken.TAG_OPEN_END);
            state = TEXT;
        }
        else if (char == "/")
        {
            if (getch() == ">")
            {
                pushState("/&gt;");
                pushToken(HTMLToken.TAG_ATTR);
                emit(quote + "/>");
                pushToken(HTMLToken.TAG_OPEN_END_CLOSE);
                state = TEXT;
            }
            else
            {
                putback();
                emit(char, EMIT_TEXT | EMIT_VALUE);
            }
        }
        else if (getEntityRepr(char))
        {
            emit(getEntityRepr(char), EMIT_TEXT | EMIT_VALUE);
        }
        else
        {
            emit(char, EMIT_TEXT | EMIT_VALUE);
        }
    }
    private function lexTagExcl():void
    {
        skipWhiteSpace();
        if (eat("--"))
        {
            emit("--");
            state = COMMENT;
            return;
        }
        else if (eat("[CDATA[", false))
        {
            emit("[CDATA[");
            state = CDATA_CONTENT;
            return;
        }
        else if (isNameStartChar(peekch()))
        {
            state = DECLARATION;
        }
        else
        {
            fail("Illegal character following <!");
        }
    }

    private function lexComment():void
    {
        var char:String = getch();
        if (char == "")
        {
            if (getTopStateNote() == RETRY_COMMENT_CLOSE)
            {
                fail("EOF while in comment - possibly closed improperly");
            }
            else
            {
                emit("-->");
            }
        }
        else if (char == "-")
        {
            if (getch() == "-")
            {
                // don't emit -- sequence. lexCommentClose should
                // check if it's a proper closing sequence. if so,
                // then emit and close the comment, if not, then
                // suppress the multiple hyphens as they are not allowed
                // in XML comments
                state = COMMENT_CLOSE;
            }
            else
            {
                emit(char);
            }
        }
        else if (char == ">")
        {
            pushState("-->", RETRY_COMMENT_CLOSE);
            emit(char);
        }
        else
        {
            emit(char);
        }
    }

    private function lexCommentClose():void
    {
        var char:String = getch();
        while (char == "-")
        {
            char = getch();
        }
        if (char == ">")
        {
            emit("-->");
            pushToken(HTMLToken.COMMENT);
            state = TEXT;
        }
        else
        {
            putback();
            state = COMMENT;
        }
    }

    private function lexDeclaration():void
    {
        // just read up to >
        // quoted >s are legal, but i'm getting bored of this
        var char:String = getch();
        emit(char);
        if (char == ">")
        {
            pushToken(HTMLToken.DECLARATION);
            state = TEXT;
        }
    }

    private function lexProcInstr():void
    {
        // read up to ?>
        var char:String = getch();
        if (char == "")
        {
            if (getTopStateNote() == RETRY_PI_CLOSE)
            {
                fail("EOF while in processing instruction - possibly closed improperly");
            }
            else
            {
                emit("?>");
            }
        }
        else if (char == "?")
        {
            if (getch() == ">")
            {
                emit("?>");
                pushToken(HTMLToken.PROC_INSTR);
                state = TEXT;
            }
            else
            {
                pushState("?>", RETRY_PI_CLOSE);
                emit(char);
            }
        }
        else if (char == ">")
        {
            pushState("?>", RETRY_PI_CLOSE);
            emit(char);
        }
        else
        {
            emit(char);
        }
    }

    private function lexCDataContent():void
    {
        var char:String = getch();
        emit(char);
        if (char == "]")
        {
            if (getch() == ">")
            {
                emit(">");
                pushToken(HTMLToken.CDATA);
                state = TEXT;
            }
            else
            {
                putback();
            }
        }
    }


    private function getName():String
    {
        var char:String;
        var name:String = getch();

        if (!isNameStartChar(name)) fail("Illegal character at start of identifier");

        do {
            char = getch();
            if (isNameChar(char))
            {
                name += char;
            }
            else
            {
                putback();
                break;
            }
        } while (char);
        return name;
    }

    private function getEntity():String
    {
        var ent:String = getch();
        var char:String = getch();

        if (ent != "&" || !isEntityStartChar(char)) fail("Illegal character at start of entity");

        ent += char;

        do {
            char = getch();
            if (isNameChar(char))
            {
                ent += char;
            }
            else if (char == ";")
            {
                ent += char;
                break;
            }
            else
            {
                // if the entity parsed so far is valid, then allow it to
                // be terminated with something other than a ;
                if (HTMLReference.instance.isTextEntity(ent.substr(1).toLowerCase()) ||
                    HTMLReference.instance.isNumericEntity(ent))
                {
                    ent += ";";
                    putback();
                }
                else  // otherwise the opening & may have been meant as literal
                {
                    fail("Illegal character in entity");
                }
                break;
            }
        } while (char);
        return ent.toLowerCase();
    }

    private function fail(message:String):void
    {
        var from:int = Math.max(cursor - 12, 0);
        var to:int =   Math.min(cursor + 12, source.length);

        throw new HTMLCleanSyntaxError(cursor, source.substring(from, to), cursor - from, message);
    }

    private function emit(string:String, target:int = EMIT_TEXT):void
    {
        if (target & EMIT_NAME)  currentToken.name  += string;
        if (target & EMIT_VALUE) currentToken.value += string;
        if (target & EMIT_TEXT)  currentToken.text  += string;
    }

    private function eat(literal:String, matchCase:Boolean = true):Boolean
    {
        var sourceStr:String = source.substr(cursor, literal.length);

        if (!matchCase)
        {
            sourceStr = sourceStr.toLowerCase();
            literal = literal.toLowerCase();
        }

        if (sourceStr == literal)
        {
            cursor += literal.length;
            return true;
        }
        else
        {
            return false;
        }
    }

    private function skipWhiteSpace():void
    {
        var char:String = getch();
        while (isSpace(char))
        {
            emit(char);
            char = getch();
        }
        putback();
    }

    private function getch():String
    {
        var char:String = source.charAt(cursor);
        cursor++;
        return char;
    }

    private function peekch():String
    {
        return source.charAt(cursor);
    }

    private function putback():void
    {
        cursor--;
    }

    private function pushToken(type:String):void
    {
        // don't make empty text tokens
        if (!(type == HTMLToken.TEXT && currentToken.text.length == 0))
        {
            currentToken.type = type;
            tokenStream.push(currentToken);
        }
        currentToken = new HTMLToken();
    }

    private function pushState(insert:String, note:String = ""):void
    {
        var lexerState:LexerState =
            new LexerState(insert + source.substr(cursor),
                           0,
                           state,
                           quote,
                           currentToken,
                           tokenStream,
                           note);
        stateStack.push(lexerState);
    }

    private function popState():void
    {
        if (stateStack.length == 0) throw new HTMLCleanLexError("Exhausted lex attempts");

        var lexerState:LexerState = stateStack.pop();

        source = lexerState.source;
        sourceLen = source.length;
        cursor = lexerState.cursor;
        state = lexerState.state;
        quote = lexerState.quote;
        currentToken = lexerState.currentToken;
        tokenStream = lexerState.tokenStream;
    }

    private function getTopStateNote():String
    {
        var topState:LexerState = stateStack[stateStack.length - 1];
        return topState.note;
    }

    private static function getEntityRepr(char:String):String
    {
        return HTMLReference.instance.getEntityRepr(char);
    }

    private static function isNameChar(char:String):Boolean
    {
        return isNameStartChar(char) ||
               (char >= "0" && char <= "9") ||
               char == "-" || char == "." ||
               char == ":";    // allow xml namespaces
    }

    private static function isNameStartChar(char:String):Boolean
    {
        return (char >= "A" && char <= "Z") ||
               (char >= "a" && char <= "z") ||
               char == "_";
    }

    private static function isEntityStartChar(char:String):Boolean
    {
        return isNameStartChar(char) || char == "#";
    }

    private static function isSpace(char:String):Boolean
    {
        return char == " " || char == "\t" || char == "\n" || char == "\r";
    }
}
}

import org.yellcorp.markup.html.HTMLToken;


internal class LexerState
{
    public var source:String;
    public var cursor:int;
    public var state:int;
    public var quote:String;
    public var currentToken:HTMLToken;
    public var tokenStream:Array;
    public var note:String;

    public function LexerState(source:String, cursor:int, state:int, quote:String, currentToken:HTMLToken, tokenStream:Array, note:String)
    {
        this.source = source;
        this.cursor = cursor;
        this.state = state;
        this.quote = quote;
        this.currentToken = currentToken.clone();
        this.tokenStream = tokenStream.map(cloneToken);
        this.note = note;
    }

    private static function cloneToken(item:HTMLToken, i:int, a:Array):HTMLToken
    {
        return item.clone();
    }
}
