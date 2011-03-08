package org.yellcorp.format.printf.context
{
public class AbsoluteArg implements Resolver
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
}
}
