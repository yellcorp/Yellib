package org.yellcorp.lib.core
{
import flash.utils.Dictionary;


/**
 * Utilities for manipulating array-like objects.  An array-like object is
 * one that has the following characteristics:
 * <ul>
 *   <li>It supports iteration over its values using
 *       <code>for each&#x2026;in</code>.</li>
 *   <li>It contains values associated with integer indices.</li>
 *   <li>It has a <code>length</code> property that is set to one higher
 *       than its maximum valid index.</li>
 * </ul>
 * Array-like objects include instances of <code>Array</code>,
 * <code>Vector</code> and the top-level <code>arguments</code> object.
 */
public class ArrayUtil
{
    // these private singletons are used to represent null or undefined
    // values when using a Dictionary to eliminate duplicate elements.
    // This is because null and undefined values are converted to Strings
    // when attempting to use them as keys in a Dictionary.
    private static var nullKey:Object = { };
    private static var undefinedKey:Object = { };

    /**
     * Given a set of arrays, returns them grouped by identical index.
     * If the arrays are unequal in length, the result is equal in length
     * to the shortest array.
     *
     * @example
     * <listing version="3.0">
     * var u:Array = [ "a",  "b",  "c" ];
     * var v:Array = [ "1",  "2",  "3" ];
     * var w:Array = [ "do", "re", "mi" ];
     *
     * var z:Array = ArrayUtil.zip(a, b);
     *
     * // z ==
     * // [ [ "a", "1", "do" ],
     * //   [ "b", "2", "re" ],
     * //   [ "c", "3", "mi" ] ]
     * </listing>
     */
    public static function zip(... arrays):Array
    {
        return zipv(arrays);
    }

    /**
     * Identical to zip, but accepts an array of arrays, instead of a
     * parameter list of arrays.
     *
     * @see #zip
     */
    public static function zipv(arrays:*):Array
    {
        var shortest:Number;
        var result:Array;
        var build:Array;

        if (!arrays)
        {
            return arrays;
        }

        if (arrays.length == 0)
        {
            return [ ];
        }

        for each (var a:* in arrays)
        {
            if (a.length < shortest)
            {
                shortest = a.length;
            }
        }

        if (isNaN(shortest))
        {
            throw new ArgumentError("Couldn't get length property from any object");
        }

        result = new Array(shortest);
        for (var i:Number = 0; i < shortest; i++)
        {
            build = [ ];
            for each (var v:* in arrays)
            {
                build.push(v[i]);
            }
            result[i] = build;
        }
        return result;
    }


    /**
     * Array reduction, also known as a left fold.
     * See <a href="http://en.wikipedia.org/wiki/Fold_%28higher-order_function%29">Fold
     * (higher-order function) on Wikipedia</a>.
     *
     * @example
     * <listing version="3.0">
     * function add(a:Number, b:Number):Number {
     *      return a + b;
     * }
     * var arrayToSum:Array = [ 1, 2, 3, 4, 5 ];
     *
     * var sum:Number = ArrayUtil.reduce(arrayToSum, add, 0);
     *
     * // sum == 15
     * </listing>
     *
     * @param array             The array to reduce.
     * @param reductionFunction A function that takes two arguments and
     *                          returns the result of some operation on
     *                          them.
     * @param initialValue      The intial value. If present, the first
     *                          function call will be
     *                          <code>reductionFunction(initialValue, array[0])</code>
     *                          Otherwise it will be
     *                          <code>reductionFunction(array[0], array[1])</code>.
     */
    public static function reduce(array:*, reductionFunction:Function,
            initialValue:* = null):*
    {
        var i:int;
        var acc:*;

        if (initialValue === null)
        {
            if (array.length >= 1)
            {
                acc = array[0];
                i = 1;
            }
        }
        else
        {
            acc = initialValue;
            i = 0;
        }

        for ( ; i < array.length; i++)
        {
            acc = reductionFunction(acc, array[i]);
        }

        return acc;
    }


    /**
     * Given an object or array, and an array of indices or properties,
     * use the latter to index into the former.  Useful when calling
     * <code>Array.sort()</code> with <code>Array.RETURNINDEXEDARRAY</code>
     * set.
     *
     * @example Example using an Array:
     * <listing version="3.0">
     * var fromArray:Array  = [ "apples", "bananas", "cardamoms", "durians" ];
     *
     * var reordered:Array = ArrayUtil.pick(fromArray, [ 2, 0, 3, 1 ]);
     * // reordered == [ "cardamoms", "apples", "durians", "bananas" ]
     *
     * var duplicated:Array = ArrayUtil.pick(fromArray, [ 1, 1, 1, 3 ]);
     * // duplicated == [ "bananas", "bananas", "bananas", "durians" ]
     * </listing>
     *
     * Example using an Object:
     * <listing version="3.0">
     * var fromObject:Object = {
     *     image: "steve.jpg"
     *     url: "http://steve.com",
     *     name: "Steve",
     * };
     * var propArray:Array = [ "name", "image", "url" ];
     *
     * var newArray:Array = ArrayUtil.pick(fromObject, propArray);
     *
     * // newArray == [ "Steve", "steve.jpg", "http://steve.com" ]
     * </listing>
     *
     * @param source   The instance to pick from.
     * @param indices  The indices or properties to pick.
     * @return         An array with the specified index or property
     *                 values from source.
     */
    public static function pick(source:*, indices:*):Array
    {
        var i:int;
        var picked:Array = [ ];

        for (i = 0; i < indices.length; i++)
        {
            picked.push(source[indices[i]]);
        }
        return picked;
    }


    /**
     * Given an array of objects, return the specified property for each one.
     *
     * @example <listing version="3.0">
     * var things:Array = [
     *     { width:  320, height: 240 },
     *     { width:  640, height: 480 },
     *     { width: 1024, height: 768 },
     * ];
     *
     * var heights:Array = ArrayUtil.mapToProperty(things, "height");
     * // heights == [ 240, 480, 768 ]
     * </listing>
     *
     * @param array    An array of objects.
     * @param property The name of the property to return from each object.
     * @return         A new <code>Array</code> of each object's property
     *                 value.
     */
    public static function mapToProperty(array:*, property:*):Array
    {
        var result:Array = [ ];
        for each (var member:* in array)
        {
            result.push(member[property]);
        }
        return result;
    }


    /**
     * Given an array of objects, calls the specified method on each one
     * and return a new array of the results.
     *
     * @example <listing version="3.0">
     * var numbers:Array = [ 102, 153, 204 ];
     *
     * var decimal:Array = ArrayUtil.mapToMethod(numbers, "toString");
     * // decimal == [ "102", "153", "204" ];
     *
     * var hex:Array = ArrayUtil.mapToMethod(numbers, "toString", [ 16 ]);
     * // hex == [ "66", "99", "cc" ];
     * </listing>
     *
     * @param array      An array of objects.
     * @param method     The name of the method to call on each object.
     * @param methodArgs An array of arguments to pass to each method. If
     *                   omitted or <code>null</code>, passes no arguments.
     * @return           A new <code>Array</code> of the results of each
     *                   method call.
     */
    public static function mapToMethod(array:*, methodName:String, methodArgs:* = null):Array
    {
        var result:Array = [ ];
        for each (var member:* in array)
        {
            result.push(member[methodName].apply(member, methodArgs));
        }
        return result;
    }


    /**
     * Returns the number of members in an array that return
     * <code>true</code> when passed to the provided function.
     *
     * @example
     * <listing version="3.0">
     * function isPositive(n:Number):Boolean {
     *     return n >= 0
     * }
     *
     * var numbers:Array = [ -2, -1, 0, 1, 2 ];
     *
     * var numPositive:int = ArrayUtil.count(numbers, isPositive);
     * // numPositive == 3
     * </listing>
     *
     * @param array        The array containing members to query
     * @param boolFunction A function that takes one argument
     *                     and returns <code>true</code> or
     *                     <code>false</code>.  If omitted or
     *                     <code>null</code>, will count the number of
     *                     members that cast to <code>Boolean</code> as
     *                     <code>true</code>.
     * @return The number of calls to <code>boolFunction</code> that
     *         returned <code>true</code>
     */
    public static function count(array:*, boolFunction:Function = null):int
    {
        var i:int;
        var result:int;
        if (!array) return 0;
        result = 0;
        if (boolFunction === null)
        {
            for (i = 0; i < array.length; i++)
            {
                if (array[i]) result++;
            }
        }
        else
        {
            for (i = 0; i < array.length; i++)
            {
                if (boolFunction(array[i])) result++;
            }
        }
        return result;
    }


    /**
     * Calls a function for each member of an array, returning the index
     * of the first one to return <code>true</code>.  If none return
     * <code>true</code>, returns <code>-1</code>.
     *
     * @example
     * <listing version="3.0">
     * function isNumber(text:String):Boolean {
     *     return isFinite(parseFloat(text));
     * }
     *
     * var junk:Array = [ "oven", "grill", "1200", "microwave", "300" ];
     *
     * var firstNumber:int = ArrayUtil.indexOf(junk, isNumber);
     * // firstNumber == 2
     * </listing>
     *
     * @param array        The array containing members to query
     * @param boolFunction A function that takes one argument
     *                     and returns <code>true</code> or
     *                     <code>false</code>.  If omitted or
     *                     <code>null</code>, will return the index of the
     *                     first member to cast to <code>Boolean</code> as
     *                     <code>true</code>.
     * @param startIndex   The index to start searching from.  If omitted,
     *                     assumes <code>0</code>.
     * @return The index of the first member to return <code>true</code>,
     *         or <code>-1</code> if none did.
     */
    public static function indexOf(array:*, boolFunction:Function = null,
            startIndex:int = 0):int
    {
        var i:int;
        if (!array) return -1;
        if (boolFunction === null)
        {
            for (i = startIndex; i < array.length; i++)
            {
                if (array[i]) return i;
            }
        }
        else
        {
            for (i = startIndex; i < array.length; i++)
            {
                if (boolFunction(array[i])) return i;
            }
        }
        return -1;
    }


    /**
     * Calls a function for each member of an array, returning the index
     * of the last one to return <code>true</code>.  If none return
     * <code>true</code>, returns <code>-1</code>.
     *
     * @example
     * <listing version="3.0">
     * function isNumber(text:String):Boolean {
     *     return isFinite(parseFloat(text));
     * }
     *
     * var junk:Array = [ "oven", "grill", "1200", "microwave", "300" ];
     *
     * var lastNumber:int = ArrayUtil.lastIndexOf(junk, isNumber);
     * // lastNumber == 4
     * </listing>
     *
     * @param array        The array containing members to query
     * @param boolFunction A function that takes one argument
     *                     and returns <code>true</code> or
     *                     <code>false</code>.  If omitted or
     *                     <code>null</code>, will return the index of the
     *                     last member to cast to <code>Boolean</code> as
     *                     <code>true</code>.
     * @param startIndex   The index to start searching from.  If omitted,
     *                     assumes the end of the array.
     * @return The index of the last member to return <code>true</code>, or
     *         <code>-1</code> if none did.
     */
    public static function lastIndexOf(array:*, boolFunction:Function = null, startIndex:int = -1):int
    {
        var i:int;
        if (!array) return -1;
        if (startIndex < 0) startIndex = array.length - 1;
        if (boolFunction === null)
        {
            for (i = startIndex; i >= 0; i--)
            {
                if (array[i]) return i;
            }
        }
        else
        {
            for (i = startIndex; i >= 0; i--)
            {
                if (boolFunction(array[i])) return i;
            }
        }
        return -1;
    }


    /**
     * Calls a function for each member of an array, returning the first
     * member to return <code>true</code>.  If none return
     * <code>true</code>, returns <code>null</code>.
     *
     * @example
     * <listing version="3.0">
     * function isNumber(text:String):Boolean {
     *     return isFinite(parseFloat(text));
     * }
     *
     * var junk:Array = [ "oven", "grill", "1200", "microwave", "300" ];
     *
     * var firstNumber:String = ArrayUtil.findFirst(junk, isNumber);
     * // firstNumber == "1200"
     * </listing>
     *
     * @param array        The array containing members to query
     * @param boolFunction A function that takes one argument
     *                     and returns <code>true</code> or <code>false</code>.
     *                     If omitted, will return the first member to cast
     *                     to <code>Boolean</code> as <code>true</code>.
     * @param startIndex   The index to start searching from.  If omitted,
     *                     assumes <code>0</code>.
     * @return The first member to return <code>true</code>, or
     *         <code>null</code> if none did.
     */
    public static function findFirst(array:*, boolFunction:Function, startIndex:int = 0):*
    {
        var index:int = indexOf(array, boolFunction, startIndex);
        return index >= 0 ? array[index] : null;
    }


    /**
     * Calls a function for each member of an array, returning the last one
     * to return <code>true</code>.  If none return <code>true</code>,
     * returns <code>null</code>.
     *
     * @example
     * <listing version="3.0">
     * function isNumber(text:String):Boolean {
     *     return isFinite(parseFloat(text));
     * }
     *
     * var junk:Array = [ "oven", "grill", "1200", "microwave", "300" ];
     *
     * var lastNumber:String = ArrayUtil.findLast(junk, isNumber);
     * // lastNumber == "300"
     * </listing>
     *
     * @param array        The array containing members to query
     * @param boolFunction A function that takes one argument
     *                     and returns <code>true</code> or
     *                     <code>false</code>.  If omitted, will return
     *                     the last member to cast to
     *                     <code>Boolean</code> as <code>true</code>.
     * @param startIndex   The index to start searching from.  If omitted,
     *                     assumes the end of the array.
     * @return The last member to return <code>true</code>, or
     *         <code>null</code> if none did.
     */
    public static function findLast(array:*, boolFunction:Function, startIndex:int = -1):*
    {
        var index:int = lastIndexOf(array, boolFunction, startIndex);
        return index >= 0 ? array[index] : null;
    }


    /**
     * Returns a copy of an array with equal items removed.  Equality
     * checking is strict (<code>===</code>).
     */
    public static function unique(array:*):Array
    {
        var result:Array = [ ];
        var member:*;
        var memberKey:*;
        var seen:Dictionary = new Dictionary(true);
        var i:int;

        for (i = 0; i < array.length; i++)
        {
            member = array[i];
            memberKey = valueToKey(member);

            if (!seen[memberKey])
            {
                result.push(member);
                seen[memberKey] = member;
            }
        }
        seen = null;
        return result;
    }


    /**
     * Returns <code>true</code> if the elements in array <code>v</code> are
     * strictly equal (<code>===</code>) to the elements in array
     * <code>w</code>, and appear in the same order.
     */
    public static function arraysEqual(v:*, w:*):Boolean
    {
        var len:int = v.length;

        if (!v && !w)
        {
            return v === w;
        }
        else if (!v || !w)
        {
            return false;
        }
        else if (len !== w.length)
        {
            return false;
        }
        else
        {
            for (var i:int = 0; i < len; i++)
            {
                if (v[i] !== w[i])
                {
                    return false;
                }
            }
        }
        return true;
    }


    /**
     * Returns <code>true</code> if the elements in array <code>v</code>
     * are strictly equal (===) to the elements in array <code>w</code>,
     * without considering order.
     */
    public static function arraysEqualUnordered(v:*, w:*):Boolean
    {
        var aCount:Dictionary;
        var bCount:Dictionary;
        var item:*;

        if (!v && !w)
        {
            return v === w;
        }
        else if (!v || !w)
        {
            return false;
        }
        else if (v.length !== w.length)
        {
            return false;
        }
        else
        {
            aCount = countElements(v);
            bCount = countElements(w);

            for (item in v)
            {
                if (aCount[item] !== bCount[item])
                {
                    return false;
                }
            }
        }
        return true;
    }


    /**
     * Wraps a 1-argument function with a function signature suitable for
     * passing to the 3-argument functional methods of Array.
     *
     * @param func  A function that accepts one argument: an array item.
     * @return      A function that accepts three arguments: an array item,
     *              an index, and an array.
     *
     * @see Array#every
     * @see Array#filter
     * @see Array#forEach
     * @see Array#map
     * @see Array#some
     */
    public static function simpleCallback(func:Function):Function
    {
        function callback(item:*, index:int, array:*):*
        {
            return func(item);
        }
        return callback;
    }


    private static function countElements(v:*):Dictionary
    {
        var item:*;
        var itemCount:Dictionary = new Dictionary(true);

        for each (item in v)
        {
            item = valueToKey(item);
            if (itemCount[item])
            {
                itemCount[item]++;
            }
            else
            {
                itemCount[item] = 1;
            }
        }
        return itemCount;
    }


    private static function valueToKey(value:*):*
    {
        if (value === null)
        {
            return nullKey;
        }
        else if (value === undefined)
        {
            return undefinedKey;
        }
        else
        {
            return value;
        }
    }
}
}
