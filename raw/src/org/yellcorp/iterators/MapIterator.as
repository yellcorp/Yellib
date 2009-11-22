package org.yellcorp.iterators
{
public class MapIterator
{
    protected var map:*;
    protected var keys:Array;
    protected var index:int;

    protected var currentKey:*;
    protected var currentValue:*;

    public function MapIterator(map:*)
    {
        this.map = map;
        reset();
    }

    public function reset():void
    {
        var enumKey:*;

        keys = [ ];
        for (enumKey in map)
        {
            keys.push(enumKey);
        }

        index = 0;
    }

    public function hasNext():Boolean
    {
        return index < keys.length;
    }

    public function next():void
    {
        currentKey = keys[index];
        currentValue = map[currentKey];
        index++;
    }

    public function get key():*
    {
        return currentKey;
    }

    public function get value():*
    {
        return currentValue;
    }
}
}
