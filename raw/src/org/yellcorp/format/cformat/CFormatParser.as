package org.yellcorp.format.cformat
{
import org.yellcorp.map.Cache;

import flash.errors.IllegalOperationError;


public class CFormatParser
{
    private var typeMap:Object = {
        'd': CFormatToken.TYPE_DECIMAL_INT,
        'i': CFormatToken.TYPE_DECIMAL_INT,
        'o': CFormatToken.TYPE_OCTAL_INT,
        'u': CFormatToken.TYPE_UNSIGNED_INT,
        'x': CFormatToken.TYPE_HEX_INT,
        'f': CFormatToken.TYPE_FIX_FLOAT,
        'e': CFormatToken.TYPE_EXP_FLOAT,
        'g': CFormatToken.TYPE_VAR_FLOAT,
        'a': CFormatToken.TYPE_HEX_FLOAT,
        'c': CFormatToken.TYPE_CHAR,
        's': CFormatToken.TYPE_STRING
    };

    private const DEBUG:Boolean = true;

    private var template:StringReader;

    private var tokens:Array;
    private var ctoken:CFormatToken;
    private var parserCache:Cache;

    public function CFormatParser()
    {
        parserCache = new Cache(1000);
    }

    public function parse(templateString:String):CFormatTemplate
    {
        var templateObject:CFormatTemplate;

        if (parserCache.hasValue(templateString))
        {
            return parserCache.getValue(templateString);
        }
        else
        {
            reset(templateString);
            while (!template.atEnd()) { parseToken(); }

            templateObject = new CFormatTemplate(tokens);

            parserCache.setValue(templateString, templateObject);

            return templateObject;
        }
    }

    private function reset(templateString:String):void
    {
        template = new StringReader(templateString);
        tokens = [];
        ctoken = null;
    }

    private function parseToken():void
    {
        if (template.currentChar == "%")
        {
            parseField();
        }
        else
        {
            parseLiteral();
        }
    }

    private function parseLiteral():void
    {
        var end:int = template.indexOfNext("%");

        if (end < 0)
        {
            tokens.push(template.getRest());
            template.pointer = length;
        }
        else
        {
            tokens.push(template.getTo(end));
            template.pointer = end;
        }
    }

    private function parseField():void
    {
        var save:int;
        var error:String;

        if (DEBUG)
        {
            if (template.currentChar != "%")
            {
                throw new IllegalOperationError("Current char is not %");
            }
        }

        template.next();
        save = template.pointer;
        ctoken = new CFormatToken();

        parseIndex();
        parseFlags();
        parseWidth();
        parsePrecision();
        parseType();

        if (ctoken.literalValue)
        {
            tokens.push(ctoken.literalValue);
        }
        else if (ctoken.type == 0)
        {
            error = formatError("parseField", "Error parsing field", save, template.pointer, template.string);
            template.pointer = save;
            tokens.push("%");
            trace(error);
        }
        else
        {
            tokens.push(ctoken);
        }
    }

    private function parseIndex():void
    {
        var index:String = getIndex();

        if (index != "")
        {
            ctoken.index = parseInt(index);
        }
    }

    private function parseFlags():void
    {
        while (!template.atEnd())
        {
            switch (template.currentChar)
            {
                case "-" :
                    ctoken.alignLeft = true;
                    template.next();
                    break;
                case "0" :
                    ctoken.zeroPad = true;
                    template.next();
                    break;
                case "#" :
                    ctoken.alternateForm = true;
                    template.next();
                    break;
                case " " :
                    if (ctoken.positiveSign != "+") // + has higher precedence
                        ctoken.positiveSign = " ";
                    template.next();
                    break;
                case "+" :
                    ctoken.positiveSign = "+";
                    template.next();
                    break;
                case "'" :
                    ctoken.group = true;
                    template.next();
                    break;
                default :
                    return;
            }
        }
    }

    private function parseWidth():void
    {
        var digits:String;

        if (template.currentChar == "*")
        {
            // i'm calling * meta - means get the value
            // for this part of the field from the argument list
            ctoken.widthMeta = true;
            template.next();
            digits = getIndex();
            if (digits != "")
            {
                ctoken.widthMetaArg = parseInt(digits);
            }
        }
        else
        {
            digits = getDigits();
            if (digits != "")
            {
                ctoken.width = parseInt(digits);
            }
        }
    }

    private function parsePrecision():void
    {
        var digits:String;

        if (template.currentChar != ".") return;
        template.next();

        if (template.currentChar == "*")
        {
            // i'm calling * meta - means get the value
            // for this part of the field from the argument list
            ctoken.precisionMeta = true;
            template.next();
            digits = getIndex();
            if (digits != "")
            {
                ctoken.precisionMetaArg = parseInt(digits);
            }
        }
        else
        {
            digits = getDigits();
            ctoken.precision = (digits == "") ? 0 : parseInt(digits);
        }
    }

    private function parseType():void
    {
        var originalChar:String;
        var char:String;

        originalChar = template.currentChar;

        if (originalChar == "%")
        {
            ctoken.literalValue = "%";
            template.next();
            return;
        }

        char = originalChar.toLowerCase();

        if (char != originalChar)
        {
            ctoken.caps = true;
        }

        ctoken.type = typeMap[char];
        template.next();
    }

    private function getIndex():String
    {
        // return a digit string only if it is followed by '$'
        var save:int = template.pointer;
        var digits:String = getDigits();

        if (digits == "")
        {
            return "";
        }
        else if (template.currentChar == "$")
        {
            template.next();
            return digits;
        }
        else
        {
            template.pointer = save;
            return "";
        }
    }

    private function getDigits():String
    {
        var start:int = template.pointer;
        var char:String = template.currentChar;

        while (!template.atEnd() && char >= '0' && char <= '9')
        {
            char = template.next();
        }

        return template.string.substring(start, template.pointer);
    }

    private function formatError(funcName:String, userMessage:String,
                                 fromChar:int = -1, toChar:int = -1,
                                 source:String = null):String
    {
        var str:String = "CFormatParser." + funcName + ": " + userMessage;

        if (fromChar >= 0)
        {
            if (toChar >= 0)
            {
                str += " from " + fromChar +
                       " to " + toChar;
                if (source)
                {
                    str += ' "' + source.substring(fromChar, toChar) + '"';
                }
            }
            else
            {
                str += " at " + fromChar;
            }
        }

        return str;
    }
}
}

internal class StringReader
{
    private var _string:String;
    private var _cchar:String;
    private var _pointer:int;
    private var _length:int;

    public function StringReader(string:String)
    {
        this.string = string;
    }

    public function next():String
    {
        pointer = _pointer + 1;
        return _cchar;
    }

    public function prev():String
    {
        pointer = _pointer - 1;
        return _cchar;
    }

    public function indexOfNext(search:String):int
    {
        return _string.indexOf(search, _pointer);
    }

    public function getRest():String
    {
        return _string.substr(_pointer);
    }

    public function getChars(count:int):String
    {
        return _string.substr(_pointer, count);
    }

    public function getTo(index:int):String
    {
        return _string.substring(_pointer, index);
    }

    public function atEnd():Boolean
    {
        return _pointer >= _length;
    }

    public function get currentChar():String
    {
        return _cchar;
    }

    public function get string():String
    {
        return _string;
    }

    public function set string(value:String):void
    {
        _string = value;
        _length = value.length;
        pointer = 0;
    }

    public function get pointer():int
    {
        return _pointer;
    }

    public function set pointer(value:int):void
    {
        _pointer = value;
        _cchar = (_pointer >= _length) ? "" : _string.charAt(_pointer);
    }

    public function get length():int
    {
        return _length;
    }
}
