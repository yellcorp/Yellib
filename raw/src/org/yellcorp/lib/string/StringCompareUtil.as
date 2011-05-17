package org.yellcorp.lib.string
{
public class StringCompareUtil
{
    public static function editDistance(aString:String, bString:String):int
    {
        // iterators
        var i:int, j:int;

        // strings as charcode arrays. these are 1-indexed!
        var a:Array, b:Array;

        // lengths

        var aLen:int, bLen:int;

        // intermediate values
        var cost:int, value:int;

        // cost matrix
        var d:Array;

        if ((aString == bString) || (!aString && !bString))
        {
            return 0;
        }
        else if (aString && !bString)
        {
            return aString.length;
        }
        else if (bString && !aString)
        {
            return bString.length;
        }

        a = stringToCharArray1(aString);
        b = stringToCharArray1(bString);

        aLen = aString.length;
        bLen = bString.length;
        cost = 0;

        d = new Array(bLen + 1);
        for (j = 0; j <= bLen; j++)
        {
            d[j] = new Array(aLen + 1);
        }

        for (i = 0; i <= aLen; i++)
            d[0][i] = i;

        for (j = 0; j <= bLen; j++)
            d[j][0] = j;

        for (i = 1; i <= aLen; i++)
        {
            for (j = 1; j <= bLen; j++)
            {
                cost = a[i] == b[j] ? 0 : 1;

                value = Math.min(
                    d[j][i - 1] + 1,
                    d[j - 1][i] + 1,
                    d[j - 1][i - 1] + cost
                );

                if (i > 1 && j > 1 &&
                    a[i] == b[j - 1] &&
                    a[i - 1] == b[j])
                {
                    value = Math.min(value, d[j - 2][i - 2] + cost);
                }

                d[j][i] = value;
            }
        }

        return d[bLen][aLen];
    }

    /**
     * Converts a string to a 1-based array of char codes.
     */
    private static function stringToCharArray1(str:String):Array
    {
        var ca:Array = new Array(str.length + 1);

        ca[0] = 0;
        for (var i:int = 0; i < str.length; i++)
        {
            ca[i + 1] = str.charCodeAt(i);
        }
        return ca;
    }
}
}
