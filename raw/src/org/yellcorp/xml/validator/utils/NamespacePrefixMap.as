package org.yellcorp.xml.validator.utils
{
import org.yellcorp.map.MapUtil;


public class NamespacePrefixMap
{
    public static const NO_PREFIX:String = "xmlns";

    private var _prefixToURI:Object;
    private var _parent:NamespacePrefixMap;

    public function NamespacePrefixMap(prefixToURI:Object, parent:NamespacePrefixMap = null)
    {
        _parent = parent;
        _prefixToURI = { };
        if (prefixToURI)
        {
            MapUtil.merge(prefixToURI, _prefixToURI);
        }
        if (!_prefixToURI.hasOwnProperty(NO_PREFIX))
        {
            _prefixToURI[NO_PREFIX] = "";
        }
    }

    public function getURI(prefix:String):String
    {
        var searchPrefix:String;

        if (prefix)
        {
            searchPrefix = prefix;
        }
        else
        {
            prefix = "";
            searchPrefix = NO_PREFIX;
        }

        if (_prefixToURI.hasOwnProperty(searchPrefix))
        {
            return _prefixToURI[searchPrefix];
        }
        else if (_parent)
        {
            return _parent.getURI(searchPrefix);
        }
        else
        {
            throw new ArgumentError("No URI with prefix " + prefix);
        }
    }

    public function getNamespace(prefix:String):Namespace
    {
        return new Namespace(prefix, getURI(prefix));
    }

    public function parseName(qnameString:String):QName
    {
        var split:Array = splitQName(qnameString);
        var prefix:String = split[0];
        var localName:String = split[1];
        var uri:String = getURI(prefix);
        return new QName(uri, localName);
    }

    private static function splitQName(qnameString:String):Array
    {
        var split:Array = qnameString.split(":", 2);
        if (split.length == 1) split.unshift("");
        return split;
    }
}
}
