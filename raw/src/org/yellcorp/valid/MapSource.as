package org.yellcorp.valid
{
import org.yellcorp.valid.ValueSource;


public class MapSource implements ValueSource
{
    private var map:*;

    public function MapSource(objectOrDictionary:*)
    {
        map = objectOrDictionary;
    }

    public function getValue(key:String):*
    {
        return map[key];
    }
}
}
