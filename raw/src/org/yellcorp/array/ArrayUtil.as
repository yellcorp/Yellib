package org.yellcorp.array
{
import flash.utils.Dictionary;


/**
 * Generic utilities for manipulating Arrays.  A lot of concepts
 * pilfered from functional programming and languages like Python.
 */
public class ArrayUtil
{
    /**
     * Creates one array from multiple arrays by interleaving each member
     * from each array.
     *
     * @example Given two input arrays:
     * <listing version="3.0">
     * var a:Array = [ "1", "2", "3" ];
     * var b:Array = [ "a", "b", "c" ];
     *
     * var z:Array = ArrayUtil.zip(a, b);
     *
     * // z equals:
     * // [ "1", "a", "2", "b", "3", "c" ];
     * </listing>
     */
    public static function zip(... arrays):Array
    {
        var result:Array = new Array();
        var currentArray:Array;
        var len:int = 0;
        var i:int;
        var j:int;

        var nullPadding:Boolean = true;

        for (j = 0;j < arrays.length; j++)
        {
            currentArray = arrays[j] as Array;
            if (currentArray === null)
            {
                throw new ArgumentError("Argument " + j + " not an Array");
            }
            else
            {
                len = Math.max(len, currentArray.length);
            }
        }

        for (i = 0;i < len; i++)
        {
            for (j = 0;j < arrays.length; j++)
            {
                currentArray = arrays[j] as Array;
                if (i < currentArray.length)
                {
                    result.push(currentArray[i]);
                } else if (nullPadding)
                {
                    result.push(null);
                }
            }
        }

        return result;
    }

    /**
     * Array reduction, AKA a left fold.
     * See http://en.wikipedia.org/wiki/Reduce_%28higher-order_function%29
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
     *
     * @param array             The array to reduce
     * @param reductionFunction A function that takes two arguments and
     *                          returns the result of some operation on
     *                          them
     * @param initialValue      The intial value. If present, the first
     *                          function call will be
     *                          <code>reductionFunction(initialValue, array[0])</code>
     *                          Otherwise it will be
     *                          <code>reductionFunction(array[0], array[1])</code>
     * </listing>
     */
    public static function reduce(array:Array, reductionFunction:Function, initialValue:* = null):*
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
     * @param arrayOrObject The Array or Object to pick from
     * @param indices       The indices or properties to pick
     * @return              An array with the specified index/property
     *                      values from the Array/Object
     */
    public static function pick(arrayOrObject:*, indices:Array):Array
    {
        var i:int;
        var picked:Array = [ ];

        for (i = 0; i < indices.length; i++)
        {
            picked.push(arrayOrObject[indices[i]]);
        }
        return picked;
    }

    /**
     * Given an <code>Array</code> of objects, return the specified
     * property for each one.
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
     *
     * @param array    An array of objects.
     * @param property The name of the property to return from each object.
     * @return         A new <code>Array</code> of each object's property
     *                 value.
     */
    public static function mapToProperty(array:Array, property:*):Array
    {
        var mapper:Function = function (m:*, i:int, a:Array):*
        {
            return m[property];
        };
        return array.map(mapper);
    }

    /**
     * Given an <code>Array</code> of objects, calls the specified method
     * on each one and return a new array of the results.
     *
     * @example <listing version="3.0">
     * var numbers:Array = [ 102, 153, 204 ];
     *
     * var decimal:Array = ArrayUtil.mapToMethod(numbers, "toString");
     * // decimal == [ "102", "153", "204" ];
     *
     * var hex:Array = ArrayUtil.mapToMethod(numbers, "toString", [ 16 ]);
     * // hex == [ "66", "99", "cc" ];
     *
     * @param array     An array of objects.
     * @param method    The name of the method to call on each object.
     * @param arguments An array of arguments to pass to each method. If
     *                  omitted, passes no arguments.
     * @return          A new <code>Array</code> of the results of each
     *                  method call.
     */
    public static function mapToMethod(array:Array, methodName:String, arguments:Array = null):Array
    {
        var mapper:Function = function (m:*, i:int, a:Array):*
        {
            return m[methodName].apply(m, arguments);
        };
        return array.map(mapper);
    }

    /**
     * Calls a function for each member of an array, and returns how
     * many returned <code>true</code>.
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
     *
     * @param array        The array containing members to query
     * @param boolFunction A function that takes one argument
     *                     and returns <code>true</code> or <code>false</code>.
     *                     If omitted, will count the number of members
     *                     that cast to <code>Boolean</code> as <code>true</code>.
     * @return The number of calls to <code>boolFunction</code> that returned <code>true</code>
     */
    public static function count(array:Array, boolFunction:Function = null):int
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
     * of the first one to return true.  If none return true, returns -1.
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
     *
     * @param array        The array containing members to query
     * @param boolFunction A function that takes one argument
     *                     and returns <code>true</code> or <code>false</code>.
     *                     If omitted, will return the first member to cast
     *                     to <code>Boolean</code> as <code>true</code>.
     * @param startIndex   The index to start searching from.  If omitted,
     *                     assumes 0.
     * @return The index of the first member to return true, or -1 if none did.
     */
    public static function indexOf(array:Array, boolFunction:Function = null, startIndex:int = 0):int
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
     * of the last one to return true.  If none return true, returns -1.
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
     *
     * @param array        The array containing members to query
     * @param boolFunction A function that takes one argument
     *                     and returns <code>true</code> or
     *                     <code>false</code>.  If omitted, will return
     *                     the last member to cast to <code>Boolean</code>
     *                     as <code>true</code>.
     * @param startIndex   The index to start searching from.  If omitted,
     *                     assumes the end of the array.
     * @return The index of the last member to return true, or -1 if none did.
     */
    public static function lastIndexOf(array:Array, boolFunction:Function = null, startIndex:int = -1):int
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

    public static function getFirst(array:Array, boolFunction:Function):*
    {
        var index:int = indexOf(array, boolFunction);
        return index >= 0 ? array[index] : null;
    }

    public static function getLast(array:Array, boolFunction:Function):*
    {
        var index:int = lastIndexOf(array, boolFunction);
        return index >= 0 ? array[index] : null;
    }

    /**
     * Returns a copy of an array with equal items removed.  Equality
     * checking is strict <code>===</code>.
     */
    public static function unique(array:Array):Array
    {
        var result:Array = [ ];
        var member:*;
        var dict:Dictionary = new Dictionary();
        var i:int;

        for (i = 0; i < array.length; i++)
        {
            member = array[i];
            if (member !== null && member !== undefined)
            {
                dict[member] = member;
            }
        }
        for each (member in dict)
        {
            result.push(member);
        }
        dict = null;
        return result;
    }

    /**
     * Helper function: Wraps a 1-argument function with a function
     * signature suitable for passing to the 3-argument functional methods
     * of Array.
     *
     * @see Array#every
     * @see Array#filter
     * @see Array#forEach
     * @see Array#map
     * @see Array#some
     */
    public static function simpleCallback(closure:Function):Function
    {
        function callback(item:*, index:int, array:Array):*
        {
            return closure(item);
        }
        return callback;
    }

    public static function makeIntSequence(newLength:uint, start:int = 0, step:int = 1):Array
    {
        var i:uint;
        var sequence:Array = new Array(newLength);
        for (i = 0; i < newLength; i++)
        {
            sequence[i] = start + i * step;
        }
        return sequence;
    }
}
}
