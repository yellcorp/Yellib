package org.yellcorp.lib.serial.source.object
{
import org.yellcorp.lib.serial.error.SourceError;
import org.yellcorp.lib.serial.source.ValueSource;


public class ObjectValueSource implements ValueSource
{
    public var source:Object;

    public function ObjectValueSource(source:Object)
    {
        this.source = source;
    }

    public function getPrimitiveValue(key:*):*
    {
        return getStructuredValue(key);
    }

    public function getStructuredValue(key:*):*
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
