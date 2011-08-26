package org.yellcorp.lib.debug
{
public class StackUtil
{
    public static function stackTrace():Array
    {
        var traceString:String;
        var calls:Array;
        var i:int;

        try {
            throw new Error();
        }
        catch (e:Error)
        {
            traceString = e.getStackTrace();
        }

        if (!traceString) return [];

        calls = traceString.split(/\n\s+/);

        // remove the first two because it will be the deliberate
        // error + this method
        calls.splice(0, 2);

        for (i = 0;i < calls.length; i++)
        {
            // remove "at "
            calls[i] = calls[i].substr(3);
        }

        return calls;
    }


    public static function currentCallName():String
    {
        return stackTrace()[1];
    }
}
}
