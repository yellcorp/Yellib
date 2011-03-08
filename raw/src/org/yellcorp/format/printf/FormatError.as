package org.yellcorp.format.printf
{
public class FormatError extends Error
{
    private var _charIndex:int;
    private var _specimen:String;

    public function FormatError(message:String, specimen:String, charIndex:int = -1)
    {
        super(message);
        _charIndex = charIndex;
        _specimen = specimen;
        name = "FormatError";
    }

    public function get charIndex():int
    {
        return _charIndex;
    }

    public function get specimen():String
    {
        return _charIndex >= 0 ? _specimen.charAt(_charIndex) : "";
    }
}
}
