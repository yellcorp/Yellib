package org.yellcorp.lib.collections
{
public class QNameMap
{
    private var uris:Object;
    private var nullUri:Object;

    public function QNameMap()
    {
        uris = { };
        nullUri = { };
    }

    public function deleteProperty(qname:QName):Boolean
    {
        var localNames:Object = getLocalNameMap(qname.uri);
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

    public function getProperty(qname:QName):*
    {
        var localNames:Object = getLocalNameMap(qname.uri);
        return localNames && localNames[qname.localName];
    }

    public function hasProperty(qname:QName):Boolean
    {
        var localNames:Object = getLocalNameMap(qname.uri);
        return localNames && localNames.hasOwnProperty(qname.localName);
    }

    public function setProperty(qname:QName, value:*):void
    {
        var localNames:Object = getLocalNameMapNew(qname.uri);
        localNames[qname.localName] = value;
    }

    public function getKeys():Array
    {
        var keys:Array = [ ];
        for (var uri:* in uris)
        {
            enumKeys(keys, uri, uri[uris]);
        }
        enumKeys(keys, null, nullUri);
        return keys;
    }

    public function getValues():Array
    {
        var values:Array = [ ];
        for (var uri:* in uris)
        {
            enumValues(values, uri[uris]);
        }
        enumValues(values, nullUri);
        return values;
    }

    private function enumKeys(outArray:Array, uri:*, localNameMap:Object):void
    {
        for (var localName:* in localNameMap)
        {
            outArray.push(new QName(uri, localName));
        }
    }

    private function enumValues(outArray:Array, localNameMap:Object):void
    {
        for each (var value:* in localNameMap)
        {
            outArray.push(value);
        }
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
}
}
