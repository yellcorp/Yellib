package org.yellcorp.error
{
/**
 * Interface for classes that can return an array of errors or events
 * that caused them.  This exists because CausedError and CausedErrorEvent
 * have similar behaviour but have different inheritance.
 */
public interface ErrorChain
{
    function getCauses():Array;
}
}
