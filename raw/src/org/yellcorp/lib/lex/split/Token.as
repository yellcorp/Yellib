package org.yellcorp.lib.lex.split
{
public class Token
{
    public var text:String;
    public var charIndex:int;

    public function Token(text:String, charIndex:int)
    {
        this.text = text || "";
        this.charIndex = charIndex;
    }

    public function substr(start:int, length:int):Token
    {
        return new Token(text.substr(start, length), charIndex + start);
    }

    public function toString():String
    {
        return "[Token text=" + text + " charIndex=" + charIndex + "]";
    }
}
}
