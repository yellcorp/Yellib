package org.yellcorp.lib.collections
{
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;


public class BaseMap extends Proxy implements UntypedMap
{
    protected var store:Dictionary;
    protected var iterKeys:Array;
    protected var iterValues:Array;

    public function BaseMap(initialContents:* = null)
    {
        store = new Dictionary();
        if (initialContents)
        {
            for (var k:* in initialContents)
            {
                this[k] = initialContents[k];
            }
        }
    }

    public function get keys():Array
    {
        var kv:Array = [ ];
        for (var k:* in store) kv.push(k);
        return kv;
    }

    public function get values():Array
    {
        var vv:Array = [ ];
        for (var v:* in store) vv.push(v);
        return vv;
    }

    override flash_proxy function deleteProperty(key:*):Boolean
    {
        return delete store[key];
    }

    override flash_proxy function getProperty(key:*):*
    {
        return store[key];
    }

    override flash_proxy function hasProperty(key:*):Boolean
    {
        return store.hasOwnProperty(key);
    }

    override flash_proxy function setProperty(key:*, value:*):void
    {
        store[key] = value;
    }

    override flash_proxy function nextNameIndex(index:int):int
    {
        if (index == 0)
        {
            startIteration();
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

    protected function startIteration():void
    {
        // this is not done by calls to get keys() or get values().
        // evaluating them in the same loop ensures that the value
        // at any index of loopValues belongs to the key at the same
        // index in loopKeys
        iterKeys = [ ];
        iterValues = [ ];
        for (var k:* in store)
        {
            iterKeys.push(k);
            iterValues.push(store[k]);
        }
    }
}
}
