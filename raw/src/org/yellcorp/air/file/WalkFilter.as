package org.yellcorp.air.file
{
import org.yellcorp.regexp.RegExpUtil;
import org.yellcorp.string.StringUtil;

import flash.filesystem.File;


public class WalkFilter
{
    public static const PROP_NAME:String = "name";
    public static const PROP_NATIVE_PATH:String = "nativePath";
    public static const PROP_URL:String = "url";

    public static function all(fsItem:File):Boolean
    {
        return true;
    }

    public static function none(fsItem:File):Boolean
    {
        return false;
    }

    public static function loadableFiles(fsItem:File):Boolean
    {
        return (/\.(?:jpe?g|gif|png|swf)$/i).test(fsItem.name);
    }

    public static function regexFilter(fileProperty:String, regex:RegExp):Function
    {
        function filterFunc(fsItem:File):Boolean
        {
            return regex.test(fsItem[fileProperty]);
        }
        return filterFunc;
    }

    public static function extensionFilter(extensions:Array):Function
    {
        var re:RegExp;
        var normExts:Array = extensions.map(stripLeadingDots);

        if (normExts.length == 1)
        {
            re = new RegExp("\\." + normExts[0] + "$", "i");
        }
        else
        {
            re = RegExpUtil.createAlternates(normExts, false);
            re = new RegExp("\\." + re.source + "$", "i");
        }

        function filterFunc(fsItem:File):Boolean
        {
            return re.test(fsItem.name);
        }

        return filterFunc;
    }

    private static function stripLeadingDots(ext:String, i:*, a:*):String
    {
        return StringUtil.stripStart(ext, ".");
    }
}
}
