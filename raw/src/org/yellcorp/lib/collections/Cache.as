package org.yellcorp.lib.collections
{
public class Cache
{
    private var map:Object;
    private var keyOrder:Array;

    private var _maxEntries:int;

    public function Cache(maxEntries:int)
    {
        if (maxEntries <= 0)
        {
            throw new ArgumentError("maxEntries must be greater than 0");
        }
        _maxEntries = maxEntries;
        clear();
    }

    public function clear():void
    {
        map = { };
        keyOrder = [ ];
    }

    public function hasValue(key:String):Boolean
    {
        return map[key] != null;
    }

    public function getValue(key:String):*
    {
        return map[key];
    }

    public function setValue(key:String, value:*):void
    {
        if (map[key] == null)
        {
            if (keyOrder.length >= _maxEntries)
            {
                deleteByIndex(0);
            }
        }
        map[key] = value;
    }

    public function deleteValue(key:String):Boolean
    {
        var index:int;

        if (map[key] == null) return false;

        index = keyOrder.indexOf(key);
        return deleteByIndex(index);
    }

    public function get maxEntries():int
    {
        return _maxEntries;
    }

    public function set maxEntries(value:int):void
    {
        if (value <= 0)
        {
            throw new ArgumentError("maxEntries must be greater than 0");
        }

        if (value < _maxEntries)
        {
            deleteOldest(_maxEntries - value);
        }
        _maxEntries = maxEntries;
    }

    public function get length():uint
    {
        return keyOrder.length;
    }

    private function deleteByIndex(index:int):Boolean
    {
        if (index < 0)
        {
            throw new ArgumentError("index must be 0 or greater");
        }
        var key:String = keyOrder.splice(index, 1)[0];
        return delete map[key];
    }

    private function deleteOldest(count:int):void
    {
        var ikey:String;
        var delKeys:Array = keyOrder.splice(0, count);

        for each (ikey in delKeys)
        {
            delete map[ikey];
        }
    }
}
}
