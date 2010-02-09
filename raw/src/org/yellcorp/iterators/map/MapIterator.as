package org.yellcorp.iterators.map
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
        index = -1;
        next();
    }

    public function get valid():Boolean
    {
        return index < keys.length;
    }

    public function next():void
    {
        ++index;
        currentKey = keys[index];
        currentValue = map[currentKey];
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
