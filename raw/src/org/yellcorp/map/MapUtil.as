package org.yellcorp.map
{
/**
 * Generic utilities for manipulating mapping objects - i.e. Objects with
 * dynamic properties, Dictionaries, Arrays, anything that can be accessed
 * using [ ]
 */
public class MapUtil
{
    /**
     * Sets keys to values on a map, sourcing the keys from the first array
     * and the values from the second.
     *
     * @example
     * <listing version="3.0">
     * var obj:Object = MapUtil.setFromKeysValues(["one", "two", "three"], [1, 2, 3]);
     *
     * // obj.one == 1;
     * // obj.two == 2;
     * // obj.three == 3;
     * </listing>
     *
     * @param keys   The keys to set on the target map.
     * @param values The values to set each key to.
     * @param target The target map. If omitted, will create a new Object
     * @return       The target map.
     */
    public static function setFromKeysValues(keys:Array, values:Array, target:* = null):*
    {
        if (target === null) target = { };
        for (var i:int = 0; i < keys.length; i++)
        {
            target[keys[i]] = values[i];
        }
        return target;
    }

    /**
     * Sets keys to values on a map, sourcing the keys and values from a
     * single array which alternates between a key name and its value.
     *
     * @example
     * <listing version="3.0">
     * var obj:Object = MapUtil.setFromInterleaved(["one", 1, "two", 2, "three", 3]);
     *
     * // obj.one == 1;
     * // obj.two == 2;
     * // obj.three == 3;
     * </listing>
     *
     * @param keysValues An array of alternating keys and values
     * @param target     The target map. If omitted, will create a new
     *                   <code>Object</code>
     * @return           The target map.
     */
    public static function setFromInterleaved(keysValues:Array, target:* = null):*
    {
        if (target === null) target = { };
        for (var i:int = 0; i < keysValues.length; i += 2)
        {
            target[keysValues[i]] = keysValues[i + 1];
        }
        return target;
    }

    /**
     * Copies the keys and values from one map to the target map.
     *
     * @param map        The map to copy.
     * @param target     The target map. If omitted, will create a new
     *                   <code>Object</code>
     * @return           The target map.
     */
    public static function setFromMap(map:Object, target:* = null):*
    {
        if (target === null) target = { };
        for (var key:* in map)
        {
            target[key] = map[key];
        }
        return target;
    }

    /**
     * Returns all the keys in a map as an <code>Array</code>. The order
     * is undefined. This is implemented as a for...in loop, so sealed
     * instances may return empty arrays.
     *
     * @param map  The map to retrieve keys from.
     * @return     An array of the map's keys.
     */
    public static function getKeys(map:*):Array
    {
        var result:Array = [ ];

        for (var key:* in map)
        {
            result.push(key);
        }

        return result;
    }

    /**
     * Returns all the values in a map as an <code>Array</code>. The order
     * is undefined.
     *
     * @param map  The map to retrieve values from.
     * @return     An array of the map's values.
     */
    public static function getValues(map:*):Array
    {
        var result:Array = [ ];

        for (var key:* in map)
        {
            result.push(map[key]);
        }

        return result;
    }

    /**
     * Returns all the keys and values as an <code>Array</code> of 2-member
     * <code>Arrays</code>.
     * @example
     * <listing version="3.0">
     * var obj:Object = {
     *     one: 1,
     *     two: 2,
     *     three: 3
     * }
     *
     * var pairs:Array = MapUtil.mapToArray(obj);
     *
     * // pairs == [[one, 1], [two, 2], [three, 3]]
     * </listing>
     *
     * @param map  The map to retrieve keys and values from.
     * @return     An array of 2-member arrays, where index 0 is a key, and
     *             index 1 is that key's value.
     */
    public static function mapToArray(map:*):Array
    {
        var result:Array = [ ];

        for (var key:* in map)
        {
            result.push([key, map[key]]);
        }

        return result;
    }

    /**
     * Copies all keys and values from the source map to the target map.
     * Pretty much the same as <code>setFromMap</code>, except it assumes
     * the target already exists and doesn't return a value.
     *
     * @param source     The map to copy from.
     * @param target     The map to copy to.
     *
     * @see #setFromMap
     */
    public static function merge(source:*, target:*):void
    {
        for (var key:* in source)
        {
            target[key] = source[key];
        }
    }

    /**
     * Copies some keys and values from the source map to the target map.
     * The keys to copy are passed in as an <code>Array</code>.
     *
     * @example
     * <listing version="3.0">
     * var display:Object = {
     *     x:      200,
     *     y:      300,
     *     scaleX: 2,
     *     scaleY: 0.5
     * };
     *
     * var tween:Object = {
     *     alpha:    0,
     *     rotation: 0
     * };
     *
     * MapUtil.mergeSubset(display, tween, [ "x", "y" ]);
     *
     * // tween ==
     * // {
     * //     alpha:    0,
     * //     rotation: 0,
     * //     x:        200,
     * //     y:        300
     * // }
     * </listing>
     *
     * @param source     The map to copy from.
     * @param target     The map to copy to.
     * @param keyList    The list of keys to copy. If a key does not exist
     *                   on <code>source</code>, it is ignored.
     */
    public static function mergeSubset(source:*, target:*, keyList:Array):void
    {
        for each (var key:* in keyList)
        {
            if (source[key] !== undefined)
            {
                target[key] = source[key];
            }
        }
    }

    /**
     * Removes some keys and values from the source map and sets them in
     * the target map.  The keys to move are passed in as an
     * <code>Array</code>.
     *
     * @param source     The map to move from.
     * @param target     The map to move to.
     * @param keyList    The list of keys to move. If a key does not exist
     *                   on <code>source</code>, it is ignored.
     */
    public static function moveSubset(source:*, target:*, keyList:Array):void
    {
        for each (var key:* in keyList)
        {
            if (source[key] !== undefined)
            {
                target[key] = source[key];
                delete source[key];
            }
        }
    }

    /**
     * Returns the number of keys defined in a given map.
     *
     * Note: This is done using a <code>for ... in</code> loop, so only
     * dynamic keys will be counted.  Will likely return 0 for instances
     * of sealed classes.
     *
     * @example
     * <listing version="3.0">
     * var howMany:Object = {
     *     one: 1,
     *     two: 2,
     *     three: 3,
     *     four: 4
     * }
     *
     * var keyCount:int = MapUtil.count(howMany);
     * // keyCount == 4
     * </listing>
     *
     * @param map  The map to count
     * @return     The number of keys defined in map.
     */
    public static function count(map:*):uint
    {
        var key:*;
        var n:uint = 0;
        for (key in map) n++;
        return n;
    }

    /**
     * Returns <code>true</code> if a map contains no keys.
     *
     * @param map  The map to test for emptiness.
     * @returns    True if the map has no keys. False otherwise.
     */
    public static function isEmpty(map:*):Boolean
    {
        for (var key:* in map) return false;
        return true;
    }

    /**
     * Creates an index of a map's keys. <code>indexingFunc</code> is called
     * for each key/value pair in <code>map</code>, passing in the key and
     * value as arguments.  The result of this function is then used as the
     * key in the <code>target</code> map, with the origianl key becoming
     * the new value.
     *
     * @param map           The map to index.
     * @param indexingFunc  A function which accepts two arguments, the key
     *                      and the value, and returns some value.
     * @param target        The map to create the index in. If no object is
     *                      provided, a new <code>Object</code> is created.
     *                      The results of <code>indexingFunc</code> will
     *                      be used as keys, with the keys from
     *                      <code>map</code> becoming the value.
     * @return The map containing the index.
     */
    public static function indexKeys(map:*, indexingFunc:Function, target:* = null):*
    {
        return index(map, indexingFunc, false, target);
    }

    /**
     * Creates an index of a map's values. <code>indexingFunc</code> is called
     * for each key/value pair in <code>map</code>, passing in the key and
     * value as arguments.  The result of this function is then used as the
     * key in the <code>target</code> map, with the original value becoming
     * the new value.
     *
     * @param map           The map to index.
     * @param indexingFunc  A function which accepts two arguments, the key
     *                      and the value, and returns some value.
     * @param target        The map to create the index in. If no object is
     *                      provided, a new <code>Object</code> is created.
     *                      The results of <code>indexingFunc</code> will
     *                      be used as keys, with the values from
     *                      <code>map</code> becoming the value.
     * @return The map containing the index.
     */
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
