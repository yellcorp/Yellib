package org.yellcorp.format.printf.context
{
public interface Resolver
{
    function resolve(context:RenderContext):void;
    function get value():*;
}
}
