package org.yellcorp.lib.collections
{
public class QNameMap
{
    private var root:Object;

    public function QNameMap()
    {
        root = { };
    }

    public function hasKey(qname:QName):Boolean
    {
        return root.hasOwnProperty(qname.uri) &&
               root[qname.uri].hasOwnProperty(qname.localName);
    }

    public function getValue(qname:QName):*
    {
        if (root.hasOwnProperty(qname.uri))
        {
            return root[qname.uri][qname.localName];
        }
        else
        {
            return null;
        }
    }

    public function setValue(qname:QName, value:*):void
    {
        var uriMap:Object;

        if (root.hasOwnProperty(qname.uri))
        {
            root[qname.uri][qname.localName] = value;
        }
        else
        {
            uriMap = root[qname.uri] = { };
            uriMap[qname.localName] = value;
        }
    }
}
}
