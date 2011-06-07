package org.yellcorp.lib.serial.readers
{
import org.yellcorp.lib.serial.source.MapSource;
import org.yellcorp.lib.serial.source.ValueSource;
import org.yellcorp.lib.serial.source.VectorSource;


public interface Reader
{
    function createValueSource(source:*):ValueSource;
    function createVectorSource(source:*):VectorSource;
    function createMapSource(source:*):MapSource;
}
}
