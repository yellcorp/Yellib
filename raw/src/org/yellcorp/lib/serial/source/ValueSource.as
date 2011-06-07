package org.yellcorp.lib.serial.source
{
public interface ValueSource
{
    function getPrimitiveValue(key:*):*;
    function getStructuredValue(key:*):*;
}
}
