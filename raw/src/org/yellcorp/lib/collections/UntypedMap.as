package org.yellcorp.lib.collections
{
/**
 * Represents mapping objects that can store keys of any type. Subclasses
 * of flash.utils.Proxy can implement this interface to compensate for
 * the return type of flash_proxy::nextName being String.  Users of a class
 * that implements UntypedMap should get its .keys property rather than
 * iterating over its keys using for...in.  A get values() method is also
 * declared for symmetry.
 */
public interface UntypedMap
{
    function get keys():Array;
    function get values():Array;
}
}
