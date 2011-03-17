package org.yellcorp.lib.format.printf.context
{
/**
 * @private
 */
public class ConstantArg implements Resolver
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
}
}
