package wip.yellcorp.lib.hash
{
import flash.utils.Dictionary;


public class HashMap
{
    private var dict:Dictionary;

    // private var _size:uint;

    public function HashMap()
    {
        clear();
    }

    public function clear():void
    {
        dict = new Dictionary();
    }

    public function hasKey(key:Hashable):Boolean
    {
        var bucket:Array = getBucket(key);

        if (bucket == null || bucket.length == 0)
        {
            return false;
        }
        else
        {
            return getValueIndex(bucket, key) >= 0;
        }
    }

    public function setItem(key:Hashable, value:*):void
    {
        var bucket:Array = getBucketNew(key);
        var index:int = -1;

        if (bucket.length > 0)
            index = getValueIndex(bucket, key);

        if (index >= 0)
        {
            bucket[index] = value;
        }
        else
        {
            bucket.push(key, value);
        }
    }

    public function getItem(key:Hashable, notFoundValue:* = null):*
    {
        var bucket:Array = getBucket(key);
        var index:int = -1;

        if (bucket == null || bucket.length == 0)
        {
            return notFoundValue;
        }
        else
        {
            index = getValueIndex(bucket, key);
            return (index >= 0) ? bucket[index] : notFoundValue;
        }
    }

    public function remove(key:Hashable):Boolean
    {
        var bucket:Array = getBucket(key);
        var index:int = -1;

        if (bucket.length > 0)
            index = getKeyIndex(bucket, key);

        if (index >= 0)
        {
            bucket.splice(index - 1, 2);
            return true;
        }
        else
        {
            return false;
        }
    }

    private function getBucket(key:Hashable):Array
    {
        return dict[key.hash()];
    }

    private function getBucketNew(key:Hashable):Array
    {
        var hash:* = key.hash();
        var bucket:Array = dict[hash];

        if (bucket == null)
        {
            bucket = dict[hash] = new Array();
        }

        return bucket;
    }

    private function getKeyIndex(bucket:Array, key:Hashable):int
    {
        var index:int;

        for (index = 0; index < bucket.length; index += 2)
        {
            if (key.equals(bucket[index]))
            {
                return index;
            }
        }

        return -1;
    }

    private function getValueIndex(bucket:Array, key:Hashable):int
    {
        var index:int = getKeyIndex(bucket, key);
        if (index >= 0) index++;
        return index;
    }
}
}
