package org.yellcorp.lib.serial.source.object
{
import org.yellcorp.lib.serial.error.SourceError;
import org.yellcorp.lib.serial.source.KeyValueSource;
import org.yellcorp.lib.serial.source.MapSource;
import org.yellcorp.lib.serial.source.VectorSource;

import flash.utils.getQualifiedClassName;


public class ObjectSource implements KeyValueSource
{
    public var source:Object;

    public function ObjectSource(source:Object)
    {
        this.source = source;
    }

    public function getPrimitiveValue(key:*):*
    {
        return getValue(key);
    }

    public function getKeyValueSource(key:*):KeyValueSource
    {
        return new ObjectSource(getValue(key));
    }

    public function getVectorSource(key:*):VectorSource
    {
        var vector:* = getValue(key);

        if (vector.hasOwnProperty("length"))
        {
            return new ObjectVectorSource(vector);
        }
        else
        {
            throw new SourceError("Vector type requested for key " + key +
                " but value has no length property (type is " +
                getQualifiedClassName(vector) + ")");
        }
    }

    public function getMapSource(key:*):MapSource
    {
        return null;
    }

    protected function getValue(key:*):*
    {
        if (source.hasOwnProperty(key))
        {
            return source[key];
        }
        else
        {
            throw new SourceError("Non-existent key: " + key);
        }
    }
}
}
