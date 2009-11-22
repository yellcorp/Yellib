package org.yellcorp.map
{
import org.yellcorp.error.AssertError;
import org.yellcorp.format.Template;


public class OrderedStringMap
{
    private var valueMap:Object;
    private var keyOrder:Array;
    private var indexMap:Object;

    public function OrderedStringMap()
    {
        clear();
    }

    public function clear():void
    {
        valueMap = { };
        indexMap = { };
        keyOrder = [ ];
    }

    // MAP BEHAVIOUR

    public function hasKey(key:String):Boolean
    {
        return valueMap.hasOwnProperty(key);
    }

    public function setKey(key:String, value:*):void
    {
        if (!hasKey(key))
        {
            indexMap[key] = keyOrder.length;
            keyOrder.push(key);
        }
        valueMap[key] = value;
    }

    public function getKey(key:String):*
    {
        return valueMap[key];
    }

    public function deleteKey(key:String):Boolean
    {
        var index:int;

        index = getIndexOfKey(key);
        if (index < 0)
        {
            return false;
        }
        else
        {
            deleteKeyIndex(key, index);
            return true;
        }
    }

    // ORDERED BEHAVIOUR

    public function get length():int
    {
        return keyOrder.length;
    }

    public function getIndexOfKey(key:String):int
    {
        if (hasKey(key))
        {
            return indexMap[key];
        }
        else
        {
            return -1;
        }
    }

    public function getKeyAtIndex(index:int):String
    {
        if (index < length)
        {
            return keyOrder[index];
        }
        else
        {
            return null;
        }
    }

    public function getValueAtIndex(index:uint):*
    {
        var key:String;

        key = getKeyAtIndex(index);

        if (key !== null)
        {
            return valueMap[key];
        }
        else
        {
            return undefined;
        }
    }

    public function deleteAtIndex(index:int):Boolean
    {
        var key:String;

        if (index < length)
        {
            key = keyOrder[index];
            deleteKeyIndex(key, index);
            return true;
        }
        else
        {
            return false;
        }
    }

    public function popKey(key:String):*
    {
        var poppedVal:*;
        var index:int;

        index = getIndexOfKey(key);

        if (index >= 0)
        {
            poppedVal = valueMap[key];
            deleteKeyIndex(key, index);
            return poppedVal;
        }
        else
        {
            return undefined;
        }
    }

    public function popIndex(index:int):*
    {
        var poppedVal:*;
        var key:String;

        key = getKeyAtIndex(index);

        if (key !== null)
        {
            poppedVal = valueMap[key];
            deleteKeyIndex(key, index);
            return poppedVal;
        }
        else
        {
            return undefined;
        }
    }

    public function pop():*
    {
        return popIndex(length - 1);
    }

    public function shift():*
    {
        return popIndex(0);
    }

    private function deleteKeyIndex(key:String, index:int):void
    {
        // DEBUG check
        AssertError.assert(indexMap[key] == index,
                           Template.format("key={key}, index={index}, indexMap[key]={kIndex}",
                                           { key: key, index: index, kIndex: indexMap[key] } )) &&

        AssertError.assert(keyOrder[index] == key,
                           Template.format("key={key}, index={index}, keyOrder[index]={iKey}",
                                           { key: key, index: index, iKey: keyOrder[index] } ));

        delete valueMap[key];
        delete indexMap[key];
        keyOrder.splice(index, 1);
    }
}
}
