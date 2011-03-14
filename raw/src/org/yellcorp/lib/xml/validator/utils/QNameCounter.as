package org.yellcorp.lib.xml.validator.utils
{
import org.yellcorp.lib.collections.QNameMap;


public class QNameCounter
{
    private var _count:QNameMap;

    public function QNameCounter()
    {
        _count = new QNameMap();
    }

    public function getCount(qname:QName):int
    {
        return _count.getValue(qname) || 0;
    }

    public function inc(qname:QName):int
    {
        var newCount:int = (_count.getValue(qname) || 0) + 1;
        _count.setValue(qname, newCount);
        return newCount;
    }
}
}
