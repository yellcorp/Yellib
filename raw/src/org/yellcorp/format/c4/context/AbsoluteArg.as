package org.yellcorp.format.c4.context
{
public class AbsoluteArg implements ContextArg
{
    private var _index:int;
    private var _value:*;

    public function AbsoluteArg(index:int)
    {
        _index = index;
    }

    public function resolve(context:RenderContext):void
    {
        _value = context.getAbsoluteIndexArg(_index);
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
