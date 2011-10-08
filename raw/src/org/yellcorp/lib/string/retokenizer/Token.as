package org.yellcorp.lib.string.retokenizer
{
public class Token
{
    public var text:String;
    public var index:int;
    public var matched:Boolean;

    private var match:Object;

    public function getGroup(groupIndex:int):String
    {
        return match ? match[groupIndex] : null;
    }

    internal static function newFromString(text:String, index:int):Token
    {
        var t:Token = new Token();
        t.matched = false;
        t.text = text;
        t.index = index;
        return t;
    }

    internal static function newFromMatch(match:Object):Token
    {
        var t:Token = new Token();
        t.matched = true;
        t.text = match[0];
        t.index = match.index;
        t.match = match;
        return t;
    }
}
}
