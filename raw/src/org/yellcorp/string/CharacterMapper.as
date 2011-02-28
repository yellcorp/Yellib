package org.yellcorp.string
{
import org.yellcorp.map.MapUtil;
import org.yellcorp.regexp.RegExpUtil;


public class CharacterMapper
{
    private var charMap:Object;
    private var modified:Boolean;
    private var regex:RegExp;

    public function CharacterMapper(fromChars:String = "", toChars:String = "")
    {
        clear();
        setFromStrings(fromChars, toChars);
    }

    public function clear():void
    {
        charMap = { };
        modified = true;
    }

    public function hasMapping(fromChar:String):Boolean
    {
        return charMap.hasOwnProperty(fromChar);
    }

    public function getMapping(fromChar:String):String
    {
        return charMap[fromChar];
    }

    public function setMapping(fromChar:String, toChar:String):void
    {
        if (toChar.length != 1)
        {
            throw new ArgumentError("toChar must be of length 1");
        }
        charMap[fromChar] = toChar;
        modified = true;
    }

    public function deleteMapping(fromChar:String):Boolean
    {
        return delete charMap[fromChar];
        modified = true;
    }

    public function setFromStrings(fromChars:String, toChars:String):void
    {
        var i:int;
        var len:int = fromChars.length;

        if (fromChars == null)
        {
            throw new ArgumentError("fromChars is null");
        }
        if (toChars == null)
        {
            throw new ArgumentError("toChars is null");
        }
        if (toChars.length != len)
        {
            throw new ArgumentError("fromChars and toChars must be of equal length");
        }

        for (i = 0; i < len; i++)
        {
            charMap[fromChars.charAt(i)] = toChars.charAt(i);
        }
        modified = true;
    }

    public function map(string:String):String
    {
        if (modified)
        {
            rebuild();
        }
        return string.replace(regex, replaceChar);
    }

    private function replaceChar(match:String, ... rest):String
    {
        return charMap[match] || match;
    }

    private function rebuild():void
    {
        regex = RegExpUtil.createAlternates(MapUtil.getKeys(charMap), false, "g");
        modified = false;
    }
}
}
