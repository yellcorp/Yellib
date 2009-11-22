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
