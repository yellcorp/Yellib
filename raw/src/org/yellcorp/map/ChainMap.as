package org.yellcorp.map
{
import flash.utils.Dictionary;


public class ChainMap
{
    private var data:Dictionary;
    private var _parent:ChainMap;

    public function ChainMap(initialMap:Object = null)
    {
        setFromMap(initialMap);
    }

    public function getValue(key:*):*
    {
        if (hasOwnKey(key))
        {
            return data[key];
        }
        else if (_parent)
        {
            return _parent.getValue(key);
        }
        else
        {
            return data[key];
        }
    }

    public function setValue(key:*, value:*):*
    {
        return data[key] = value;
    }

    public function deleteKey(key:*):Boolean
    {
        return (delete data[key]);
    }

    public function hasKey(key:*):Boolean
    {
        if (hasOwnKey(key))
        {
            return true;
        }
        else if (_parent)
        {
            return _parent.hasKey(key);
        }
        else
        {
            return false;
        }
    }

    public function hasOwnKey(key:*):Boolean
    {
        return data.hasOwnProperty(key);
    }

    public function get parent():ChainMap
    {
        return _parent;
    }

    public function set parent(parent:ChainMap):void
    {
        _parent = parent;
    }

    public function setFromMap(map:Object):void
    {
        var key:*;

        data = new Dictionary();

        if (map != null)
        {
            for (key in map)
            {
                data[key] = map[key];
            }
        }
    }

    public function clear():void
    {
        data = new Dictionary();
    }

    public function toDictionary(ownValuesOnly:Boolean = false):Dictionary
    {
        var result:Dictionary = new Dictionary();

        mergeInto(result, !ownValuesOnly);

        return result;
    }

    private function mergeInto(target:Dictionary, recursive:Boolean):void
    {
        var key:*;

        for (key in data)
        {
            if (!target.hasOwnProperty(key))
            {
                target[key] = data[key];
            }
        }

        if (recursive && _parent)
        {
            _parent.mergeInto(target, recursive);
        }
    }
}
}
