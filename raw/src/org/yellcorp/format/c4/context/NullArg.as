package org.yellcorp.format.c4.context
{
public class NullArg implements ContextArg
{
    public function resolve(context:RenderContext):void
    {
    }

    public function get value():*
    {
        return null;
    }

    public function get isSet():Boolean
    {
        return false;
    }
}
}
