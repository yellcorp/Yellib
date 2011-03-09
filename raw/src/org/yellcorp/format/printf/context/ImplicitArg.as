package org.yellcorp.format.printf.context
{
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
