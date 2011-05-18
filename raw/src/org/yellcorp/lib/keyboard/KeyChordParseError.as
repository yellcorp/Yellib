package org.yellcorp.lib.keyboard
{
public class KeyChordParseError extends Error
{
    private var _sample:String;
    private var _charIndex:int;

    public function KeyChordParseError(message:String, sample:String, char:int)
    {
        name = "KeyChordParseError";

        _sample = sample;
        _charIndex = char;

        super(message);
    }

    public function get sample():String
    {
        return _sample;
    }

    public function get charIndex():int
    {
        return _charIndex;
    }
}
}
