package org.yellcorp.map
{
public class MapUtil
{
    public static function setFromKeysValues(keys:Array, values:Array, target:* = null):*
    {
        var i:int;
        if (target === null) target = { };
        for (i = 0;i < keys.length; i++)
        {
            target[keys[i]] = values[i];
        }
        return target;
    }

    public static function setFromInterleaved(keysValues:Array, target:* = null):*
    {
        var i:int;
        if (target === null) target = { };
        for (i = 0;i < keysValues.length; i += 2)
        {
            target[keysValues[i]] = keysValues[i + 1];
        }
        return target;
    }

    public static function setFromMap(map:Object, target:* = null):*
    {
        var key:*;
        if (target === null) target = { };
        for (key in map)
        {
            target[key] = map[key];
        }
        return target;
    }

    public static function mapToArray(map:*):Array
    {
        var key:*;
        var result:Array = [ ];

        for (key in map)
        {
            result.push([key, map[key]]);
        }

        return result;
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
        var key:*;
        for (key in map) return false;

        return true;
    }
}
}
