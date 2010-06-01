package org.yellcorp.markup.htmlclean
{
import org.yellcorp.markup.html.HTMLReference;
import org.yellcorp.markup.html.HTMLToken;
import org.yellcorp.markup.htmlclean.errors.HTMLCleanLexError;
import org.yellcorp.markup.htmlclean.errors.HTMLCleanSyntaxError;


/**
 * HTMLCleanLexer is responsible for lexing a raw string into a stream
 * of HTML tokens, with an aim to correcting common markup errors in
 * a way a web browser might.  This is the first step when trying to
 * coerce a random HTML document into valid XML.
 *
 * Lexing is done on an entire stream at once - the lex method accepts the
 * entire document as a String and returns an Array of HTMLToken instances,
 * which should then be passed to an instance of HTMLCleanParser.
 * It's done this way instead of incrementally so the lexer can back
 * up and retry a section if it reaches a dead end.
 *
 * The Lexer saves its state when it encounters an ambiguity: for
 * example, a < in the source may be the beginning of an HTML tag, or
 * it may be a literal less-than that should be converted to &lt;
 *
 * If it can't make sense of < as the beginning of a tag, it will back
 * up and assume it should be changed to an &lt; instead.
 *
 * For the most part, the lexer works a single character at a time,
 * which is fast in the land of C and Java but probably the slower way
 * of doing things in ActionScript.  Such is the cost of dealing with
 * dirty HTML.
 *
 */
public class HTMLCleanLexer
{
    ////////////////////
    // Lexer scan states
    ////////////////////

    // See lex* methods for descriptions

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

    //////////////////
    // Emit properties
    //////////////////

    // emit() is called by the lexer to append a string
    // to the current token.  It can emit to any of the token's .name,
    // .value, or .text by passing a bitwise OR of the following constants
    private static const EMIT_NAME:int = 1;
    private static const EMIT_VALUE:int = 2;
    private static const EMIT_TEXT:int = 4;

    //////////////
    // State names
    //////////////

    // Special case alternatives.  Some parsing routines check what _kind_
    // of ambiguities are on the stack to decide how to proceed
    private static const RETRY_COMMENT_CLOSE:String = "RETRY_COMMENT_CLOSE";
    private static const RETRY_PI_CLOSE:String = "RETRY_PI_CLOSE";


    // instance fields
    private var source:String;
    private var cursor:int;
    private var sourceLen:int;
    private var state:int;
    private var dispatch:Array;

    // special state var: which close quote we are looking for
    private var quote:String;

    // alternate ways of interpreting ambiguities are stored here, and
    // are popped when the lexer encounters an error.  If this stack is
    // exhausted, lex() throws an HTMLCleanLexError to the caller
    private var stateStack:Array;

    private var currentToken:HTMLToken;
    private var tokenStream:Array;

    // an array of HTMLCleanSyntaxError objects which can be examined
    // by the caller to see all errors encountered.  HTMLCleanSyntaxErrors
    // are never thrown publically so don't need to be caught by calling
    // code.
    private var _errorHistory:Array;

    public function HTMLCleanLexer()
    {
        // dispatch table.  This indexes the different lexing functions
        // by the state they belong to.  Same effect as a big switch-case.
        // maybe it _should_ be a big switch-case.
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

    /**
     * Lex an HTML document.
     *
     * @param dirtyHTML The HTML document.
     * @return An array of HTMLToken objects.
     * @throws HTMLCleanLexError
     */
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

        // make a local copy of the tokenStream...
        tokenStreamReturn = tokenStream;

        // so we can clear it before returning it to the caller
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
        // TEXT: Scanning literal text or an entity

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
            // if this is some other char that should be
            // an entity, convert it ( i.e. > ' " )
            emit(getEntityRepr(char));
        }
        else if (char == "")
        {
            // end of document
            pushToken(HTMLToken.TEXT);
        }
        else
        {
            emit(char);
        }
    }

    private function lexTagStart():void
    {
        // TAG_START: Encountered a < and allowing whitespace, but yet to
        // decide if this is an open, close </, comment/declaration <!,
        // or PI <?

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
        // TAG_OPEN: Scanned a < followed by an alpha char.  Now looking
        // for the tag name

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
        // TAG_CLOSE: Scanned </ and looking for tag name
        skipWhiteSpace();
        var tagName:String = getName().toLowerCase();
        emit(tagName, EMIT_TEXT | EMIT_NAME);
        state = TAG_CLOSE_TRAILER;
    }

    private function lexTagCloseTrailer():void
    {
        // TAG_CLOSE_TRAILER: Scanned </TAGNAME and looking for close >

        skipWhiteSpace();
        var char:String = getch();

        // the first non whitespace character closes the tag and puts us
        // back into plaintext mode.  Emit a > regardless of what it is.

        // basically this means any junk inside the close tag itself will
        // become plain text following the close tag
        if (char != ">")
            putback();

        emit(">");
        pushToken(HTMLToken.TAG_CLOSE);
        state = TEXT;
    }

    private function lexTagOpenTrailer():void
    {
        // TAG_OPEN_TRAILER: Scanned the < and tag name, now looking for
        // either the closing > or a series of attributes
        var char:String = getch();
        if (isSpace(char))
        {
            emit(char);
            state = TAG_ATTR_NAME;
        }
        else if (char == "/")
        {
            // could be a self-closing tag like <br />
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
        // TAG_ATTR_NAME: Attribute name in opening tag

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
            // no attributes
            emit(char);
            pushToken(HTMLToken.TAG_OPEN_END);
            state = TEXT;
        }
        else if (char == "")
        {
            // end of document: close the tag with a >
            emit(">");
            pushToken(HTMLToken.TAG_OPEN_END);
            state = TEXT;
        }
        else if (char == "/")
        {
            // possible self-closing tag
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
        // TAG_ATTR_EQUALS: Scanning the = of an attribute name-value pair

        skipWhiteSpace();
        var char:String = getch();
        if (char == "=")
        {
            emit(char);
            skipWhiteSpace();
            char = getch();
            if (char == '"' || char == "'")
            {
                // found a quoted value
                emit(char);
                quote = char;
                state = TAG_ATTR_QUOTED_VALUE;
            }
            else
            {
                // found a non-quoted value, for example
                // <img src=image.jpg>
                // wrap the value in quotes
                putback();
                emit('"');
                quote = '"';
                state = TAG_ATTR_BARE_VALUE;
            }
        }
        else
        {
            putback();

            // found an attribute without a value. give it the string
            // value "true".
            emit('="true"', EMIT_TEXT);
            emit("true", EMIT_VALUE);

            pushToken(HTMLToken.TAG_ATTR);
            state = TAG_ATTR_NAME;
        }
    }

    private function lexTagAttrQuotedValue():void
    {
        // TAG_ATTR_QUOTED_VALUE: Scanning a quoted value, which will be
        // terminated by the quote that opened it

        var char:String = getch();
        var entity:String;

        if (char == quote)
        {
            // could be close quote without close tag
            pushState(quote + ">");

            // could also be quote-within-quote. assuming this is more
            // likely, so push this last
            pushState(getEntityRepr(char));

            emit(char);
            pushToken(HTMLToken.TAG_ATTR);
            state = TAG_ATTR_NAME;
        }
        else if (char == "")
        {
            // end of document. close it using the opening quote we found
            // then back up to the TAG_ATTR_NAME state, which will also
            // see the end of the document and add its closing >
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
        // TAG_ATTR_BARE_VALUE: Scanning an unquoted attribute value, which
        // will be terminated by > or whitespace

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
            // assume this is the end of the unquoted value

            // but it could, as always, be intended as a &gt;
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
        // TAG_EXCL: Scanning a <! tag which could turn into either a
        // doctype declaration, CDATA, or a comment
        skipWhiteSpace();
        if (eat("--"))
        {
            // it's a comment
            emit("--");
            state = COMMENT;
            return;
        }
        else if (eat("[CDATA[", false))
        {
            // it's a CDATA
            emit("[CDATA[");
            state = CDATA_CONTENT;
            return;
        }
        else if (isNameStartChar(peekch()))
        {
            // it's a DOCTYPE or some other exotic beast
            state = DECLARATION;
        }
        else
        {
            fail("Illegal character following <!");
        }
    }

    private function lexComment():void
    {
        // COMMENT: scanning a comment, removing -- sequences that aren't
        // --> sequences (illegal in XML).

        // Also will save any bare > characters as a possible closed
        // comment, I think IE used to allow this

        // FIXME: May not handle -> very well.  Could turn it into --->
        // which would choke the XML parser

        var char:String = getch();
        if (char == "")
        {
            // reached the end of the document while in a comment.  two
            // possibilities are likely here - either it truly is the end
            // of the doc and we just need to cap it off with a -->

            // OR: There was an attempted close early on (say with a bare
            // > char) and we just ate the rest of the document
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
                // don't emit -- sequence. Let lexCommentClose
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
            // here's the possible bad comment close
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
        // COMMENT_CLOSE: lexComment has already read the -- sequence, but
        // not emitted it.

        var char:String = getch();

        // skip over any superfluous -
        while (char == "-")
        {
            char = getch();
        }
        if (char == ">")
        {
            // if we get a > emit a proper closing sequence
            emit("-->");
            pushToken(HTMLToken.COMMENT);
            state = TEXT;
        }
        else
        {
            // turns out it wasn't a close after all. don't emit the -
            // characters
            putback();
            state = COMMENT;
        }
    }

    private function lexDeclaration():void
    {
        // DECLARATION: a <! tag that isn't a comment <!-- or <![CDATA[

        // just read up to >

        // FIXME: quoted >s are legal and this is a copout,
        // but i'm getting bored of this.
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
        // PROC_INSTR: In most cases <?xml version="1.0" ?>

        // The scanner just looks for a closing ?> sequence and otherwise
        // doesn't care about the content.  Like the auto-comment fixing,
        // will first accept a >, but if it reaches the end of doc, will
        // retry it as a ?>

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
        // CDATA_CONTENT: In a <![CDATA[ and looking for a closing ]]>
        var char:String = getch();
        emit(char);
        if (char == "]")
        {
            if (eat("]>"))
            {
                emit("]>");
                pushToken(HTMLToken.CDATA);
                state = TEXT;
            }
        }
        else if (char == "")
        {
            emit("]]>");
            pushToken(HTMLToken.CDATA);
            state = TEXT;
        }
    }

    // end of state methods

    private function getName():String
    {
        // scans, consumes and returns a valid name

        // a valid name is one that starts with a NameStartChar and
        // followed by 0 or more NameChars (see the is* functions for
        // definitions)

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
        // scans, consumes and returns an XML/HTML entity

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
                else
                {
                    // otherwise the opening & may have been meant as
                    // literal.  fail here and let lex() pop the stack
                    fail("Illegal character in entity");
                }
                break;
            }
        } while (char);
        return ent.toLowerCase();
    }

    private function fail(message:String):void
    {
        // utility function to create a new HTMLCleanSyntaxError object,
        // populate it with brief info about the current state, and then
        // throw it.  Errors are thrown so a bad lex state can be escaped
        // from anywhere
        var from:int = Math.max(cursor - 12, 0);
        var to:int =   Math.min(cursor + 12, source.length);

        throw new HTMLCleanSyntaxError(cursor, source.substring(from, to), cursor - from, message);
    }

    private function emit(string:String, target:int = EMIT_TEXT):void
    {
        // append string to a property of the current token. For the most
        // part this will just be to the .text property (EMIT_TEXT) -
        // which reflects the literal text belonging to the token

        // the .name and .value properties are used in the parsing stage
        // (HTMLCleanParser)

        if (target & EMIT_NAME)  currentToken.name  += string;
        if (target & EMIT_VALUE) currentToken.value += string;
        if (target & EMIT_TEXT)  currentToken.text  += string;
    }

    private function eat(literal:String, matchCase:Boolean = true):Boolean
    {
        // checks for a sequence coming up in the character stream, and if
        // it matches, skips past it and returns true.  if not a match,
        // returns false and leaves the cursor where it was

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
        // gets the next character in the input stream
        var char:String = source.charAt(cursor);
        cursor++;
        return char;
    }

    private function peekch():String
    {
        // returns the next character without advancing the cursor
        return source.charAt(cursor);
    }

    private function putback():void
    {
        //FIXME: invalid after restoring a state, so should throw
        // if the cursor goes into negative territory
        cursor--;
    }

    private function pushToken(type:String):void
    {
        // tags the current token with a token type, pushes it to the
        // output stream, and creates a new empty current token

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
        // saves the current lexer state when a potential ambiguity or
        // alternate interpretation exists.  the string passed in the
        // 'insert' argument will be inserted to the character stream
        // i.e. if this state is restored, getch() will first read the
        // chars from this inserted string, and then return to the
        // original stream.

        // 'insert' should always have a value otherwise the saved state
        // will behave no differently if it is restored

        // note that the input stream up to cursor-1 is not saved with
        // these states

        // FIXME: the true cursor value should still be stored otherwise
        // the offsets in the Error objects will be all wrong

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
        // pops the last saved state and adopts it

        // this is the error that makes it back out to the caller. if
        // this is thrown, show's over
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
        // peeks at the most recent saved state and returns its .note
        // property.
        var topState:LexerState = stateStack[stateStack.length - 1];
        return topState.note;
    }

    private static function getEntityRepr(char:String):String
    {
        // just a short alias
        return HTMLReference.instance.getEntityRepr(char);
    }

    private static function isNameStartChar(char:String):Boolean
    {
        // characters allowed as the first char of an
        // HTML/XML name
        return (char >= "A" && char <= "Z") ||
               (char >= "a" && char <= "z") ||
               char == "_";
    }

    private static function isNameChar(char:String):Boolean
    {
        // characters that are legal anywhere in an HTML/XML name
        return isNameStartChar(char) ||
               (char >= "0" && char <= "9") ||
               char == "-" || char == "." ||
               char == ":";    // allow xml namespaces
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

        // make a deep copy of the tokenStream array
        this.tokenStream = tokenStream.map(cloneToken);

        this.note = note;
    }

    private static function cloneToken(item:HTMLToken, i:int, a:Array):HTMLToken
    {
        return item.clone();
    }
}
