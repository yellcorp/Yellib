package org.yellcorp.lib.serial.source.object
{
import org.yellcorp.lib.serial.source.VectorSource;


public class ObjectVectorSource extends ObjectValueSource implements VectorSource
{
    public function ObjectVectorSource(source:Object)
    {
        super(source);
    }

    public function get length():int
    {
        return source.length;
    }
}
}
