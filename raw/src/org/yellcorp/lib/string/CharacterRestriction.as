package org.yellcorp.lib.string
{
/**
 * A class encapsulating a character restriction specification, designed
 * to be compatible with flash.text.TextField.restrict
 */
public class CharacterRestriction
{
    private var _restrict:String;
    
    private var acceptMap:Object;
    private var acceptsByDefault:Boolean;
    
    // parser state
    private var parseIndex:uint;
    private var parseAccept:Boolean;
    private var parseWaitingForRange:Boolean;
    private var rules:Array;
    
    public function CharacterRestriction(restrictSpecifier:String = "")
    {
        restrict = restrictSpecifier;
    }

    public function get restrict():String
    {
        return _restrict;
    }

    public function set restrict(new_restrict:String):void
    {
        _restrict = new_restrict;
        parse();
    }
    
    public function acceptsChar(char:String):Boolean
    {
        return acceptMap.hasOwnProperty(char) ? acceptMap[char] : acceptsByDefault;
    }
    
    public function filter(str:String):String
    {
        var filteredString:Array = [ ];
        var ch:String;
        
        for (var i:int = 0; i < str.length; i++)
        {
            ch = str.charAt(i);
            if (acceptsChar(ch))
            {
                filteredString.push(ch);
            }
        }
        return filteredString.join();
    }

    private function parse():void
    {
        var ch:Number;
        
        acceptMap = { };
        acceptsByDefault = false;
        
        parseIndex = 0;
        parseAccept = true;
        parseWaitingForRange = false;
        rules = [ ];
        
        if (!_restrict) return;
        
        while (!atEnd())
        {
            ch = getch();
            switch (ch)
            {
            case 0x5E: // ^
                if (parseWaitingForRange)
                {
                    parseChar(ch);
                }
                else
                {
                    if (firstChar())
                    {
                        acceptsByDefault = true;
                    }
                    parseAccept = !parseAccept;
                }
                break;
                
            case 0x2D: // -
                if (parseWaitingForRange || firstChar() || atEnd())
                {
                    parseChar(ch);
                }
                else
                {
                    parseWaitingForRange = true;
                }
                break;
                
            case 0x5C: // \
                if (atEnd())
                {
                    parseChar(ch);
                }
                else
                {
                    parseChar(getch());
                }
                break;
            
            default:
                parseChar(ch);
                break;
            }
        }
        
        for each (var r:CharacterRule in rules)
        {
            for (var i:int = r.begin; i <= r.end; i++)
            {
                acceptMap[String.fromCharCode(i)] = r.accept;
            }
        }
        rules = null;
    }

    private function parseChar(ch:Number):void
    {
        if (parseWaitingForRange)
        {
            parseWaitingForRange = false;
            rules[rules.length - 1].end = ch;
        }
        else
        {
            rules.push(new CharacterRule(parseAccept, ch));
        }
    }
    
    private function firstChar():Boolean
    {
    	// assume getch has already been called, so compare
    	// with 1, not 0
    	return parseIndex == 1;
    }
    
    private function atEnd():Boolean
    {
        return parseIndex >= _restrict.length;
    }

    private function getch():Number
    {
        return _restrict.charCodeAt(parseIndex++);
    }
}
}

class CharacterRule
{
    public var accept:Boolean;
    public var begin:int;
    public var end:int;
    
    public function CharacterRule(accept:Boolean, begin:int, end:int = -1)
    {
        this.accept = accept;
        this.begin = begin;
        this.end = end < 0 ? begin : end;
    }
}