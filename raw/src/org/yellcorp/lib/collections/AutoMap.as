package org.yellcorp.lib.collections
{
import flash.utils.Proxy;
import flash.utils.flash_proxy;


public class AutoMap extends Proxy
{
    public var creationFunction:Function = null;

    private var store:Object;
    private var loopKeys:Array;
    private var loopValues:Array;

    public function AutoMap(creationFunction:Function = null)
    {
        store = { };
        this.creationFunction = creationFunction;
    }

    override flash_proxy function deleteProperty(name:*):Boolean
    {
        return delete store[name];
    }

    override flash_proxy function getProperty(name:*):*
    {
        var value:*;

        if (!store.hasOwnProperty(name) && creationFunction !== null)
        {
            if (creationFunction.length == 0)
            {
                value = creationFunction();
            }
            else
            {
                value = creationFunction(name);
            }
            store[name] = value;
            return value;
        }
        else
        {
            return store[name];
        }
    }

    override flash_proxy function hasProperty(name:*):Boolean
    {
        return store.hasOwnProperty(name);
    }

    override flash_proxy function setProperty(name:*, value:*):void
    {
        store[name] = value;
    }

    override flash_proxy function nextNameIndex(index:int):int
    {
        if (index == 0)
        {
            loopKeys = [ ];
            loopValues = [ ];
            for (var k:* in store)
            {
                loopKeys.push(k);
                loopValues.push(store[k]);
            }
        }

        if (index < loopKeys.length)
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
        return loopKeys[index - 1];
    }

    override flash_proxy function nextValue(index:int):*
    {
        return loopValues[index - 1];
    }
}
}
