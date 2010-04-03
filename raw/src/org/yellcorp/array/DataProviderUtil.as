package org.yellcorp.array
{
import fl.data.DataProvider;


public class DataProviderUtil
{
    public static function findFirst(dp:DataProvider, boolFunction:Function):int
    {
        var i:int;
        if (!dp) return -1;
        if (boolFunction === null)
        {
            for (i = 0; i < dp.length; i++)
            {
                if (dp.getItemAt(i)) return i;
            }
        }
        else
        {
            for (i = 0; i < dp.length; i++)
            {
                if (boolFunction(dp.getItemAt(i))) return i;
            }
        }
        return -1;
    }
    public static function findLast(dp:DataProvider, boolFunction:Function):int
    {
        var i:int;
        if (!dp) return -1;
        if (boolFunction === null)
        {
            for (i = dp.length - 1; i >= 0; i--)
            {
                if (dp.getItemAt(i)) return i;
            }
        }
        else
        {
            for (i = dp.length - 1; i >= 0; i--)
            {
                if (boolFunction(dp.getItemAt(i))) return i;
            }
        }
        return -1;
    }
}
}
