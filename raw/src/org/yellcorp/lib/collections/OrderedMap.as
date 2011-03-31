package org.yellcorp.lib.collections
{
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;


public class OrderedMap extends Proxy implements UntypedMap
{
    private var keyToValue:Dictionary;
    private var keyToIndex:Dictionary;
    private var keyOrder:Array;

    public function OrderedMap()
    {
        keyToValue = new Dictionary();
        keyToIndex = new Dictionary();
        keyOrder = [ ];
    }

    public function get length():uint
    {
        return keyOrder.length;
    }

    public function indexOfKey(key:String):int
    {
        if (keyToIndex.hasOwnProperty(key))
        {
            return keyToIndex[key];
        }
        else
        {
            return -1;
        }
    }

    public function indexOfValue(value:*, start:int = 0):int
    {
        for (; start < keyOrder.length; start++)
        {
            if (keyToValue[keyOrder[start]] === value)
            {
                return start;
            }
        }
        return -1;
    }

    public function lastIndexOfValue(value:*, start:int = int.MAX_VALUE):int
    {
        if (start >= keyOrder.length)
        {
            start = keyOrder.length - 1;
        }
        for (; start >= 0; start--)
        {
            if (keyToValue[keyOrder[start]] === value)
            {
                return start;
            }
        }
        return -1;
    }

    public function getKeyAt(index:uint):String
    {
        return keyOrder[index];
    }

    public function getValueAt(index:uint):*
    {
        if (index < keyOrder.length)
        {
            return keyToValue[keyOrder[index]];
        }
        else
        {
            return null;
        }
    }

    public function deleteAt(index:uint):Boolean
    {
        var key:String;
        if (index < keyOrder.length)
        {
            key = keyOrder[index];
            deleteIndexAndKey(index, key);
            return true;
        }
        else
        {
            return false;
        }
    }

    public function get keys():Array
    {
        return keyOrder.slice();
    }

    public function get values():Array
    {
        var vv:Array = [ ];
        for each (var k:* in keyOrder) vv.push(keyToValue[k]);
        return vv;
    }

    override flash_proxy function deleteProperty(key:*):Boolean
    {
        var index:int;
        if (keyToValue.hasOwnProperty(key))
        {
            index = keyToIndex[key];
            deleteIndexAndKey(index, key);
        }
        else
        {
            return false;
        }
    }

    override flash_proxy function getProperty(key:*):*
    {
        return keyToValue[key];
    }

    override flash_proxy function hasProperty(key:*):Boolean
    {
        return keyToValue.hasOwnProperty(key);
    }

    override flash_proxy function setProperty(key:*, value:*):void
    {
        if (!keyToValue.hasOwnProperty(key))
        {
            keyToIndex[key] = keyOrder.length;
            keyOrder.push(key);
        }
        keyToValue[key] = value;
    }

    override flash_proxy function nextNameIndex(index:int):int
    {
        return index < keyOrder.length ? index + 1 : 0;
    }

    override flash_proxy function nextName(index:int):String
    {
        return keyOrder[index - 1];
    }

    override flash_proxy function nextValue(index:int):*
    {
        return keyToValue[keyOrder[index - 1]];
    }

    private function deleteIndexAndKey(index:int, key:*):void
    {
        keyOrder.splice(index, 1);
        delete keyToValue[key];
        delete keyToIndex[key];
    }
}
}
