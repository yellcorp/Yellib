package org.yellcorp.bmpcache
{
import flash.display.BitmapData;
import flash.net.URLRequest;
import flash.net.URLVariables;


public class CacheUtil
{
    public static function bitmapSize(bitmap:BitmapData):uint
    {
        return bitmap.width * bitmap.height * (bitmap.transparent ? 4 : 3);
    }

    public static function hashRequest(request:URLRequest):String
    {
        var hash:String = request.url;
        if (request.data)
        {
            hash += '?';
            if (request.data is URLVariables)
            {
                hash += hashVars(request.data as URLVariables);
            } else
            {
                hash += request.data.toString();
            }
        }
        return hash;
    }

    private static function hashVars(vars:URLVariables):String
    {
        var key:*;
        var value:*;
        var keyList:Array = new Array();
        var pairs:Array = new Array();

        for (key in vars)
        {
            keyList.push(key);
        }
        keyList.sort();
        for each (key in keyList)
        {
            value = vars[key];
            // don't bother escaping, it just needs to resolve to
            // a consistent string, not actually be usable
            pairs.push(key.toString() + '=' + value.toString());
        }
        return pairs.join('&');
    }
}
}
