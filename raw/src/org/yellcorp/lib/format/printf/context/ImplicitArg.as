package org.yellcorp.lib.format.printf.context
{
/**
 * @private
 */
public class ImplicitArg implements Resolver
{
    private var _value:*;

    public function ImplicitArg()
    {
    }

    public function resolve(context:RenderContext):void
    {
        _value = context.getImplicitArg();
    }

    public function get value():*
    {
        return _value;
    }
}
}
