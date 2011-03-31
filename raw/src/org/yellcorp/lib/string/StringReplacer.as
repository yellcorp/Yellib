package org.yellcorp.lib.string
{
import org.yellcorp.lib.core.MapUtil;
import org.yellcorp.lib.core.RegExpUtil;


public class StringReplacer
{
    private var replMap:Object;
    private var pattern:RegExp;

    public function StringReplacer(replacementMap:Object = null)
    {
        replacements = replacementMap;
    }


    public function clear():void
    {
        replMap = { };
        pattern = null;
    }

    public function setReplacement(from:String, to:String):void
    {
        if (!hasReplacement(from))
        {
            // if this is a new key, the regex will need to be rebuilt
            pattern = null;
        }
        replMap[from] = to;
    }

    public function hasReplacement(from:String):Boolean
    {
        return replMap.hasOwnProperty(from);
    }

    public function getReplacement(from:String):String
    {
        return replMap[from];
    }

    public function deleteReplacement(from:String):Boolean
    {
        if (hasReplacement(from))
        {
            pattern = null;
        }
        return delete replMap[from];
    }


    public function get replacements():Object
    {
        return MapUtil.copy(replMap);
    }

    public function set replacements(replacementMap:Object):void
    {
        clear();
        merge(replacementMap);
    }

    public function merge(replacementMap:Object):void
    {
        for (var k:String in replacementMap)
        {
            setReplacement(k, replacementMap[k]);
        }
    }


    public function replace(string:String):String
    {
        if (!pattern)
        {
            pattern = RegExpUtil.createAlternates(
                MapUtil.getKeys(replMap), false, "g");
        }

        return string.replace(pattern, replace1);
    }


    private function replace1(match:String, ... ignored):String
    {
        return replMap[match];
    }
}
}
