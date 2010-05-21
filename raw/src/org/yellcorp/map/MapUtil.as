package org.yellcorp.map
{
public class MapUtil
{
    public static function setFromKeysValues(keys:Array, values:Array, target:* = null):*
    {
        if (target === null) target = { };
        for (var i:int = 0;i < keys.length; i++)
        {
            target[keys[i]] = values[i];
        }
        return target;
    }

    public static function setFromInterleaved(keysValues:Array, target:* = null):*
    {
        if (target === null) target = { };
        for (var i:int = 0;i < keysValues.length; i += 2)
        {
            target[keysValues[i]] = keysValues[i + 1];
        }
        return target;
    }

    public static function setFromMap(map:Object, target:* = null):*
    {
        if (target === null) target = { };
        for (var key:* in map)
        {
            target[key] = map[key];
        }
        return target;
    }

    public static function getKeys(map:*):Array
    {
        var result:Array = [ ];

        for (var key:* in map)
        {
            result.push(key);
        }

        return result;
    }

    public static function getValues(map:*):Array
    {
        var result:Array = [ ];

        for (var key:* in map)
        {
            result.push(map[key]);
        }

        return result;
    }

    public static function mapToArray(map:*):Array
    {
        var result:Array = [ ];

        for (var key:* in map)
        {
            result.push([key, map[key]]);
        }

        return result;
    }

    public static function merge(source:*, target:*):void
    {
        for (var key:* in source)
        {
            target[key] = source[key];
        }
    }

    public static function mergeSubset(source:*, target:*, keyList:Array):void
    {
        for each (var key:* in keyList)
        {
            target[key] = source[key];
        }
    }

    public static function count(map:*):uint
    {
        var key:*;
        var n:uint = 0;
        for (key in map) n++;
        return n;
    }

    public static function isEmpty(map:*):Boolean
    {
        for (var key:* in map) return false;
        return true;
    }

    public static function indexKeys(map:*, indexingFunc:Function, target:* = null):*
    {
        return index(map, indexingFunc, false, target);
    }

    public static function indexValues(map:*, indexingFunc:Function, target:* = null):*
    {
        return index(map, indexingFunc, true, target);
    }

    private static function index(map:*, indexingFunc:Function, useValues:Boolean, target:*):*
    {
        var key:*;
        var value:*;
        var newKey:*;
        if (target === null) target = { };

        for (key in map)
        {
            value = map[key];
            newKey = indexingFunc(value, key);
            target[newKey] = useValues ? value : key;
        }
        return target;
    }
}
}
