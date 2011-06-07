package org.yellcorp.lib.serial.readers
{
import org.yellcorp.lib.serial.error.SourceError;
import org.yellcorp.lib.serial.source.MapSource;
import org.yellcorp.lib.serial.source.ValueSource;
import org.yellcorp.lib.serial.source.VectorSource;
import org.yellcorp.lib.serial.source.object.ObjectMapSource;
import org.yellcorp.lib.serial.source.object.ObjectValueSource;
import org.yellcorp.lib.serial.source.object.ObjectVectorSource;

import flash.utils.getQualifiedClassName;


public class ObjectReader implements Reader
{
    public function createValueSource(source:*):ValueSource
    {
        return new ObjectValueSource(source);
    }

    public function createVectorSource(source:*):VectorSource
    {
        if (source.hasOwnProperty("length"))
        {
            return new ObjectVectorSource(source);
        }
        else
        {
            throw new SourceError("Vector type requested for value without" +
                " length property (type is " +
                getQualifiedClassName(source) + ")");
        }

        return new ObjectVectorSource(source);
    }

    public function createMapSource(source:*):MapSource
    {
        return new ObjectMapSource(source);
    }
}
}
