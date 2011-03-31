package org.yellcorp.lib.collections
{
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;


public class QNameMap extends Proxy implements UntypedMap
{
    private var uris:Object;
    private var nullUri:Object;

    // keys that aren't QNames get stored in here. given that the Proxy
    // methods don't enforce type, and we can't throw errors from
    // flash_proxy methods, might as well at least uphold expectations
    private var other:Dictionary;

    private var iterKeys:Array;
    private var iterValues:Array;

    public function QNameMap()
    {
        uris = { };
        nullUri = { };
        other = new Dictionary();
    }

    public function get keys():Array
    {
        var kv:Array = [ ];
        enumerateEntries(kv, null);
        return kv;
    }

    public function get values():Array
    {
        var vv:Array = [ ];
        enumerateEntries(null, vv);
        return vv;
    }

    override flash_proxy function deleteProperty(key:*):Boolean
    {
        var qname:QName;
        var localNames:Object;

        if (key is QName)
        {
            qname = key as QName;
            localNames = getLocalNameMap(qname.uri);
            if (localNames)
            {
                if (delete localNames[qname.localName])
                {
                    deleteLocalNameMapIfEmpty(qname.uri);
                    return true;
                }
            }
            return false;
        }
        else
        {
            return delete other[key];
        }
    }

    override flash_proxy function getProperty(key:*):*
    {
        var qname:QName;
        var localNames:Object;

        if (key is QName)
        {
            qname = key as QName;
            localNames = getLocalNameMap(qname.uri);
            return localNames && localNames[qname.localName];
        }
        else
        {
            return other[key];
        }
    }

    override flash_proxy function hasProperty(key:*):Boolean
    {
        var qname:QName;
        var localNames:Object;

        if (key is QName)
        {
            qname = key as QName;
            localNames = getLocalNameMap(qname.uri);
            return localNames && localNames.hasOwnProperty(qname.localName);
        }
        else
        {
            return other.hasOwnProperty(key);
        }
    }

    override flash_proxy function setProperty(key:*, value:*):void
    {
        var qname:QName;
        var localNames:Object;

        if (key is QName)
        {
            qname = key as QName;
            localNames = getLocalNameMapNew(qname.uri);
            localNames[qname.localName] = value;
        }
        else
        {
            other[key] = value;
        }
    }

    override flash_proxy function nextNameIndex(index:int):int
    {
        if (index == 0)
        {
            iterKeys = [ ];
            iterValues = [ ];
            enumerateEntries(iterKeys, iterValues);
        }

        if (index < iterKeys.length)
        {
            return index + 1;
        }
        else
        {
            return 0;
        }
    }

    override flash_proxy function nextName(index:int):String
    {
        return iterKeys[index - 1];
    }

    override flash_proxy function nextValue(index:int):*
    {
        return iterValues[index - 1];
    }

    private function getLocalNameMap(uri:*):Object
    {
        return uri === null ? nullUri : uris[uri];
    }

    private function getLocalNameMapNew(uri:*):Object
    {
        return uri === null ? nullUri : (uris[uri] = { });
    }

    private function deleteLocalNameMapIfEmpty(uri:*):void
    {
        if (uri === null)
            return;

        for (var test:* in uris[uri])
            return;

        delete uris[uri];
    }

    private function enumerateEntries(outKeys:Array, outValues:Array):void
    {
        for (var uri:* in uris)
        {
            enumerateLocal(uri, uri[uris], outKeys, outValues);
        }
        enumerateLocal(null, nullUri, outKeys, outValues);
        for (var k:* in other)
        {
            outKeys.push(k);
            outValues.push(other[k]);
        }
    }

    private function enumerateLocal(uri:*, localNameMap:Object,
            outKeys:Array, outValues:Array):void
    {
        for (var localName:* in localNameMap)
        {
            if (outKeys) outKeys.push(new QName(uri, localName));
            if (outValues) outValues.push(localNameMap[localName]);
        }
    }
}
}
