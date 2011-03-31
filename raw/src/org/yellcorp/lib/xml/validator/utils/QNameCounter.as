package org.yellcorp.lib.xml.validator.utils
{
import org.yellcorp.lib.collections.QNameMap;


public class QNameCounter
{
    private var count:QNameMap;

    public function QNameCounter()
    {
        count = new QNameMap();
    }

    public function getCount(qname:QName):int
    {
        return count[qname] || 0;
    }

    public function inc(qname:QName):int
    {
        var newCount:int = (count[qname] || 0) + 1;
        count[qname] = newCount;
        return newCount;
    }
}
}
