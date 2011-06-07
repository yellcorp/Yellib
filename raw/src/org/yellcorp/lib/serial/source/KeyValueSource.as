package org.yellcorp.lib.serial.source
{
public interface KeyValueSource
{
    function getPrimitiveValue(key:*):*;
    function getKeyValueSource(key:*):KeyValueSource;
    function getVectorSource(key:*):VectorSource;
    function getMapSource(key:*):MapSource;
}
}
