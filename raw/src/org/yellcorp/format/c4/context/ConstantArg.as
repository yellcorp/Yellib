package org.yellcorp.format.c4.context
{
public class ConstantArg implements ContextArg
{
    private var _value:*;

    public function ConstantArg(value:*)
    {
        _value = value;
    }

    public function resolve(context:RenderContext):void
    {
    }

    public function get value():*
    {
        return _value;
    }

    public function get isSet():Boolean
    {
        return true;
    }
}
}
