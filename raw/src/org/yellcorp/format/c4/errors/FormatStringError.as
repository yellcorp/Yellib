package org.yellcorp.format.c4.errors
{
public class FormatStringError extends Error
{
    private var _formatString:String;
    private var _charIndex:int;
    private var _specimen:String;

    public function FormatStringError(message:String, formatString:String, charIndex:int = -1)
    {
        _formatString = formatString;
        _charIndex = charIndex;
        _specimen = specimen;
        super(message);
    }

    public function get formatString():String
    {
        return _formatString;
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