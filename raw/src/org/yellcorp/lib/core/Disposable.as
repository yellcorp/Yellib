package org.yellcorp.lib.core
{
/**
 * An interface indicating that its implementor retains strong references
 * to resources, and must be freed when the client is finished with it.
 */
public interface Disposable
{
    /**
     * Frees resources used by this object. Clients should assume that the
     * object's state becomes invalid after calling this method.
     */
    function dispose():void;
}
}
