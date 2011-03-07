package org.yellcorp.format.c4.context
{
public class RelativeArg implements ContextArg
{
    private var _offset:int;
    private var _value:*;

    public function RelativeArg(offset:int)
    {
        _offset = offset;
    }

    public function resolve(context:RenderContext):void
    {
        _value = context.getRelativeIndexArg(_offset);
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
