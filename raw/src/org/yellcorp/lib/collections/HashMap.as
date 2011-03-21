package org.yellcorp.lib.collections
{
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;


public class HashMap extends Proxy
{
    private var store:Dictionary;

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

    override flash_proxy function hasProperty(key:*):Boolean
    {
        var bucket:Dictionary;

        bucket = store[hash(key)];
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
        var bucket:Dictionary;
        var keyMatch:*;

        bucket = store[hash(key)];
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
        var bucket:Dictionary;
        var keyHash:*;
        var oldKey:*;

        keyHash = hash(key);
        bucket = store[keyHash];
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
        var bucket:Dictionary;
        var keyHash:*;
        var keyMatch:*;

        keyHash = hash(key);
        bucket = store[keyHash];
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
}
}
