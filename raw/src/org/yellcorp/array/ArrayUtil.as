package org.yellcorp.array
{
public class ArrayUtil
{
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

    public static function reorder(array:Array, indices:Array):Array
    {
        var i:int;
        var reordered:Array;

        reordered = new Array(indices.length);

        for (i = 0; i < indices.length; i++)
        {
            reordered[i] = array[indices[i]];
        }

        return reordered;
    }

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

    public static function indexOf(array:Array, boolFunction:Function):int
    {
        var i:int;
        if (!array) return -1;
        if (boolFunction === null)
        {
            for (i = 0; i < array.length; i++)
            {
                if (array[i]) return i;
            }
        }
        else
        {
            for (i = 0; i < array.length; i++)
            {
                if (boolFunction(array[i])) return i;
            }
        }
        return -1;
    }

    public static function lastIndexOf(array:Array, boolFunction:Function):int
    {
        var i:int;
        if (!array) return -1;
        if (boolFunction === null)
        {
            for (i = array.length - 1; i >= 0; i--)
            {
                if (array[i]) return i;
            }
        }
        else
        {
            for (i = array.length - 1; i >= 0; i--)
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
     * Uses ECMAScript scope behaviour to 'pad out' an existing simple
     * one-arg function for use with Array callbacks, like filter(), map()
     * etc which require 3 args
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
