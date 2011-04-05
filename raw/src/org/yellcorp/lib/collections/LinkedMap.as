package org.yellcorp.lib.collections
{
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;


public class LinkedMap extends Proxy implements UntypedMap
{
    private var map:Dictionary;
    private var keySet:DequeSet;

    private var iterKeys:Array;
    private var iterValues:Array;

    public function LinkedMap()
    {
        map = new Dictionary();
        keySet = new DequeSet();
    }

    public function get newestKey():*
    {
        return keySet.front;
    }

    public function get oldestKey():*
    {
        return keySet.back;
    }

    override flash_proxy function deleteProperty(name:*):Boolean
    {
        if (map[name] !== undefined)
        {
            keySet.remove(name);
            return delete map[name];
        }
        else
        {
            return false;
        }
    }

    override flash_proxy function getProperty(name:*):*
    {
        if (map[name] !== undefined)
        {
            keySet.pushFront(name);
        }
        return map[name];
    }

    override flash_proxy function hasProperty(name:*):Boolean
    {
        return map[name] !== undefined;
    }

    override flash_proxy function setProperty(name:*, value:*):void
    {
        map[name] = value;
        keySet.pushFront(name);
    }

    override flash_proxy function nextNameIndex(index:int):int
    {
        if (index == 0)
        {
            iterKeys = keySet.toArray();
            iterValues = [ ];
            for each (var key:* in iterKeys)
            {
                iterValues.push(map[key]);
            }
        }

        if (index < iterKeys.length)
        {
            return index + 1;
        }
        else
        {
            return 0;
        }
    }

    override flash_proxy function nextName(index:int):String
    {
        return iterKeys[index - 1];
    }

    override flash_proxy function nextValue(index:int):*
    {
        return iterValues[index - 1];
    }

    public function get keys():Array
    {
        return keySet.toArray();
    }

    public function get values():Array
    {
        var vv:Array = [ ];
        for (var k:* in keySet.toArray())
        {
            vv.push(map[k]);
        }
        return vv;
    }
}
}
