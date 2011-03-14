package org.yellcorp.lib.text
{
import org.yellcorp.lib.core.MapUtil;

import flash.net.URLVariables;
import flash.text.TextFormat;


public class TextEventUtil
{
    public static function setLinkFormat(map:*, color:int = -1, underline:Boolean = true, outFormat:TextFormat = null):TextFormat
    {
        if (!outFormat) outFormat = new TextFormat();
        outFormat.underline = underline;
        if (color >= 0)
        {
            outFormat.color = color;
        }
        outFormat.url = encodeObjectURL(map);
        return outFormat;
    }
    public static function encodeObjectURL(map:*):String
    {
        return "event:" + encodeObject(map);
    }
    public static function encodeObject(map:*):String
    {
        var urlv:URLVariables = new URLVariables();
        MapUtil.merge(map, urlv);
        return urlv.toString();
    }
    public static function decodeEventString(eventString:String):Object
    {
        var result:Object = { };
        var urlv:URLVariables = new URLVariables();
        urlv.decode(eventString);
        MapUtil.merge(urlv, result);
        return result;
    }
}
}
