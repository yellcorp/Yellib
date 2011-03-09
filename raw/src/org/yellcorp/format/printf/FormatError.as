package org.yellcorp.format.printf
{
public class FormatError extends Error
{
    private var _formatString:String;
    private var _charIndex:int;

    public function FormatError(message:String, formatString:String, charIndex:int = -1)
    {
        _formatString = formatString;
        _charIndex = charIndex;
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
        return _charIndex >= 0 ? _formatString.charAt(_charIndex) : "";
    }
}
}
