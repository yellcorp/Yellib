package org.yellcorp.lib.valid
{
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
