package org.yellcorp.format.c4.lexer
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
}
}
