package org.yellcorp.format.template
{
public class TemplateFormatStringError extends ArgumentError
{
    private var _sample:String;
    private var _index:int;

    public function TemplateFormatStringError(message:String, sample:String, index:int)
    {
        super(message);
        _sample = sample;
        _index = index;
    }

    public function get sample():String
    {
        return _sample;
    }

    public function get index():int
    {
        return _index;
    }
}
}
