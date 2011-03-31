package org.yellcorp.lib.collections
{
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;


public class HashMap extends Proxy implements UntypedMap
{
    private var store:Dictionary;
    private var iterKeys:Array;
    private var iterValues:Array;

    public function HashMap()
    {
        store = new Dictionary();
    }

    public function hash(object:*):*
    {
        return object;
    }

    public function isEqual(a:*, b:*):Boolean
    {
        return a === b;
    }

    public function get keys():Array
    {
        var kv:Array = [ ];
        evaluateEntries(kv, null);
        return kv;
    }

    public function get values():Array
    {
        var vv:Array = [ ];
        evaluateEntries(null, vv);
        return vv;
    }

    override flash_proxy function hasProperty(key:*):Boolean
    {
        var bucket:Dictionary = store[hash(key)];

        if (bucket)
        {
            return findEqualKey(bucket, key) !== undefined;
        }
        else
        {
            return false;
        }
    }

    override flash_proxy function getProperty(key:*):*
    {
        var bucket:Dictionary = store[hash(key)];
        var keyMatch:*;

        if (bucket)
        {
            keyMatch = findEqualKey(bucket, key);
            if (keyMatch !== undefined)
            {
                return bucket[keyMatch];
            }
        }
        return undefined;
    }

    override flash_proxy function setProperty(key:*, value:*):void
    {
        var keyHash:* = hash(key);
        var bucket:Dictionary = store[keyHash];
        var oldKey:*;

        if (bucket)
        {
            oldKey = findEqualKey(bucket, key);
            if (oldKey !== undefined)
            {
                bucket[oldKey] = value;
            }
            else
            {
                bucket[key] = value;
            }
        }
        else
        {
            bucket = new Dictionary();
            bucket[key] = value;
            store[keyHash] = bucket;
        }
    }

    override flash_proxy function deleteProperty(key:*):Boolean
    {
        var keyHash:* = hash(key);
        var bucket:Dictionary = store[keyHash];
        var keyMatch:*;

        if (bucket)
        {
            keyMatch = findEqualKey(bucket, key);
            if (keyMatch !== undefined)
            {
                delete bucket[keyMatch];

                for (var dummy:* in bucket)
                    return true;

                // if the above loop didn't execute, then the bucket
                // is empty and can be deleted
                delete store[keyHash];
                return true;
            }
        }
        return false;
    }

    override flash_proxy function nextNameIndex(index:int):int
    {
        if (index == 0)
        {
            iterKeys = [ ];
            iterValues = [ ];
            evaluateEntries(iterKeys, iterValues);
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

    private function findEqualKey(bucket:Dictionary, key:*):*
    {
        for (var search:* in bucket)
        {
            if (isEqual(key, search))
            {
                return search;
            }
        }
        return undefined;
    }

    private function evaluateEntries(keys:Array, values:Array):void
    {
        for each (var bucket:Dictionary in store)
        {
            for (var k:* in bucket)
            {
                if (keys) keys.push(k);
                if (values) values.push(bucket[k]);
            }
        }
    }
}
}
