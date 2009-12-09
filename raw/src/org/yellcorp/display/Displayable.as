package org.yellcorp.display
{
import flash.display.DisplayObject;


/**
 * A base interface that can be used to indicate that an implementor
 * of a sub-interface must have an associated DisplayObject (usually the
 * instance itself)
 */
public interface Displayable
{
    function get display():DisplayObject;
}
}
