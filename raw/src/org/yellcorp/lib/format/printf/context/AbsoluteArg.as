package org.yellcorp.lib.format.printf.context
{
/**
 * @private
 */
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
        _value = context.getArgAtIndex(_index);
    }

    public function get value():*
    {
        return _value;
    }
}
}
