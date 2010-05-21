package org.yellcorp.markup.htmlclean.errors
{
import org.yellcorp.string.StringUtil;


public class HTMLCleanSyntaxError extends Error
{
    private var _sampleCursor:int;
    private var _sourceSample:String;
    private var _char:int;

    public function HTMLCleanSyntaxError(char:int, sourceSample:String, sampleCursor:int, message:String = "", id:int = 0)
    {
        _char = char;
        _sampleCursor = sampleCursor;
        _sourceSample = sourceSample;
        super(message, id);
    }

    public function formatSourceSample(prefix:String):String
    {
        return prefix + _sourceSample;
    }

    public function formatCursor(prefix:String):String
    {
        return StringUtil.repeat(" ", prefix.length + _sampleCursor - 1) + "^";
    }

    public function get charIndex():int
    {
        return _sampleCursor;
    }

    public function get sourceSample():String
    {
        return _sourceSample;
    }

    public function get char():int
    {
        return _char;
    }
}
}
