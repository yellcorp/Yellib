package org.yellcorp.lib.format.printf.context
{
/**
 * @private
 */
public interface Resolver
{
    function resolve(context:RenderContext):void;
    function get value():*;
}
}
