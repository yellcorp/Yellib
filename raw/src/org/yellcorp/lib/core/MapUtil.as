package org.yellcorp.lib.core
{
/**
 * Generic utilities for manipulating mapping objects.  A mapping object is
 * any object that contains values associated with keys, and supports the
 * <code>[]</code> operator, <code>for&#x2026;in</code> enumeration, and
 * <code>for&#x2026;each</code> enumeration.  This includes Objects with
 * dynamic properties, Dictionaries, Arrays, and subclasses of
 * flash.utils.Proxy.
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
     * @param keys   An <code>Array</code> or <code>Vector</code> of keys
     *               to set on the target map.
     * @param values An <code>Array</code> or <code>Vector</code> of values
     *               to associate with each key.
     * @param target The target map. If omitted or <code>null</code>, will
     *               create a new <code>Object</code>.
     * @return       The target map.
     */
    public static function setFromKeysValues(keys:*, values:*, target:* = null):*
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
     * @param keysValues An <code>Array</code> or <code>Vector</code> of
     *                   alternating keys and values
     * @param target     The target map. If omitted, will create a new
     *                   <code>Object</code>
     * @return           The target map.
     */
    public static function setFromInterleaved(keysValues:*, target:* = null):*
    {
        if (target === null) target = { };
        for (var i:int = 0; i < keysValues.length; i += 2)
        {
            target[keysValues[i]] = keysValues[i + 1];
        }
        return target;
    }

    /**
     * Copies dynamic keys and values from one map to the target map. Values
     * for source keys overwrite any identically named keys in
     * <code>target</code>.
     *
     * @param source     The map to copy.
     * @param target     The target map. If omitted, will create a new
     *                   <code>Object</code>.
     * @return           The target map.
     */
    public static function copy(source:*, target:* = null):*
    {
        if (target === null) target = { };
        for (var key:* in source)
        {
            target[key] = source[key];
        }
        return target;
    }

    /**
     * Copies some keys and values from the source map to the target map.
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
     * MapUtil.copySubset(display, tween, [ "x", "y" ]);
     *
     * // tween == {
     * //     alpha:    0,
     * //     rotation: 0,
     * //     x:        200,
     * //     y:        300
     * // }
     * </listing>
     *
     * @param source     The map to copy from.
     * @param target     The map to copy to.
     * @param keyList    An <code>Array</code> or <code>Vector</code> of
     *                   keys to copy. If a key does not exist on
     *                   <code>source</code>, it is ignored.
     */
    public static function copySubset(source:*, target:*, keyList:*):void
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
     * <code>Array</code> or <code>Vector</code>.
     *
     * @param source     The map to move from.
     * @param target     The map to move to.
     * @param keyList    An <code>Array</code> or <code>Vector</code> of
     *                   keys to move. If a key does not exist on
     *                   <code>source</code>, it is ignored.
     */
    public static function moveSubset(source:*, target:*, keyList:*):void
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
     * Returns all the dynamic keys in a map as an <code>Array</code>.
     * The order is undefined.
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
     * Returns all the dynamic values in a map as an <code>Array</code>.
     * The order is undefined.
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
     * <code>Arrays</code>. The order is undefined.
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
     * @return     An <code>Array</code> of 2-member <code>Array</code>s,
     *             with index 0 of each containing keys and index 1
     *             containing values.
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
     * Returns the number of dynamic keys defined in a given map.
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
     * @return     The number of keys defined in the map.
     */
    public static function count(map:*):uint
    {
        var key:*;
        var n:uint = 0;
        for (key in map) n++;
        return n;
    }

    /**
     * Returns <code>true</code> if a map contains no dynamic keys.
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
     * key in the <code>target</code> map, with the original key becoming
     * the new value.
     *
     * @param map           The map to index.
     * @param indexingFunc  A function which accepts two arguments, the key
     *                      and the value, and returns some value.
     * @param target        The map to create the index in. If no object is
     *                      provided, a new <code>Object</code> is created.
     *                      The results of <code>indexingFunc</code> will
     *                      be used as keys, with the keys from
     *                      <code>map</code> becoming the values.
     * @return The map containing the index.
     */
    public static function indexKeys(map:*, indexingFunc:Function, target:* = null):*
    {
        return index(map, indexingFunc, false, target);
    }

    /**
     * Creates an index of a map's values. <code>indexingFunc</code> is
     * called for each key/value pair in <code>map</code>, passing in the
     * key and value as arguments.  The result of this function is then used
     * as the key in the <code>target</code> map, with the original value
     * becoming the new value.
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
