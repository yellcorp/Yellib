package org.yellcorp.format.c4.context
{
public interface ContextArg
{
    function resolve(context:RenderContext):void;
    function get value():*;
    function get isSet():Boolean;
}
}
