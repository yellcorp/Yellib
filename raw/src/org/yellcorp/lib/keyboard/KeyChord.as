package org.yellcorp.lib.keyboard
{
import org.yellcorp.lib.lex.split.SplitLexer;
import org.yellcorp.lib.lex.split.Token;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;


public class KeyChord
{
    private static const lexer:SplitLexer = new SplitLexer(/\s+|([\(\)])/);

    private var _description:String;

    private var shift:Boolean;
    private var ctrl:Boolean;
    private var alt:Boolean;

    private var parseToken:Function;

    private var usingKeyCode:Boolean;

    private var charCode:int;
    private var keyCode:int;

    public function KeyChord(description:String)
    {
        _description = description;
        parse();
    }

    public function get description():String
    {
        return _description;
    }

    public function matches(event:KeyboardEvent):Boolean
    {
        return shift == event.shiftKey &&
               ctrl  == event.ctrlKey  &&
               alt   == event.altKey   &&
               (usingKeyCode ? keyCode  == event.keyCode
                             : charCode == event.charCode);
    }

    private function parse():void
    {
        parseToken = parseDesc;
        lexer.start(_description);

        while (!lexer.atEnd)
        {
            parseToken(lexer.nextToken());
        }
    }

    private function parseError(message:String, token:Token):void
    {
        throw new KeyChordParseError(message, token.text, token.charIndex);
    }

    private function parseDesc(token:Token):void
    {
        var lowerText:String = token.text.toLowerCase();

        switch (lowerText)
        {
        case "shift" :
            shift = true;
            return;

        case "ctrl" :
        case "control" :
        case "command" :
        case "cmd" :
            ctrl = true;
            return;

        case "alt" :
        case "opt" :
        case "option" :
            alt = true;
            return;

        case "keycode" :
            usingKeyCode = true;
            parseToken = parseKeyCodeOpen;
            return;

        case "chr" :
            usingKeyCode = false;
            parseToken = parseCharCodeOpen;

        case "" :
            parseError("Missing key", token);

        default :
            if (token.text.length == 1)
            {
                usingKeyCode = false;
                charCode = token.text.charCodeAt(0);
                parseToken = parseEnd;
            }
            else
            {
                parseError("Unknown key", token);
            }
            break;
        }
    }

    private function parseKeyCodeOpen(token:Token):void
    {
        if (token.text == "(")
        {
            parseToken = parseKeyCodeArg;
        }
        else
        {
            parseError("Expected ( following keycode", token);
        }
    }

    private function parseKeyCodeArg(token:Token):void
    {
        var keyCodeNumber:Number = parseInteger(token.text);

        if (!isFinite(keyCodeNumber))
        {
            keyCodeNumber = Keyboard[token.text];
        }

        if (isFinite(keyCodeNumber))
        {
            keyCode = keyCodeNumber;
            parseToken = parseClose;
        }
        else
        {
            parseError("Key code must be an integer or Keyboard constant", token);
        }
    }

    private function parseCharCodeOpen(token:Token):void
    {
        if (token.text == "(")
        {
            parseToken = parseCharCodeArg;
        }
        else
        {
            parseError("Expected ( following chr", token);
        }
    }

    private function parseCharCodeArg(token:Token):void
    {
        var charCodeNumber:Number = parseInteger(token.text);

        if (isFinite(charCodeNumber))
        {
            charCode = charCodeNumber;
            parseToken = parseClose;
        }
        else
        {
            parseError("Char code must be an integer", token);
        }
    }

    private function parseClose(token:Token):void
    {
        if (token.text == ")")
        {
            parseToken = parseEnd;
        }
        else
        {
            parseError("Expected )", token);
        }
    }

    private function parseEnd(token:Token):void
    {
        if (token.text != "")
        {
            parseError("Expected end of specifier", token);
        }
    }


    private static var INT_PATTERN:RegExp = /(^0x([0-9a-f]+)$)|(^\d+$)/i;

    private static function parseInteger(text:String):Number
    {
        var match:* = INT_PATTERN.exec(text);

        if (match)
        {
            if (match[1])
            {
                return parseInt(match[2], 16);
            }
            else if (match[3])
            {
                return parseInt(match[3], 10);
            }
        }
        return Number.NaN;
    }
}
}
