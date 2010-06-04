package org.yellcorp.xml.validator.utils
{
public class NameCounter
{
    private var _count:Object;

    public function NameCounter()
    {
        _count = { };
    }

    public function getCount(name:String):int
    {
        return _count.hasOwnProperty(name) ? _count[name] : 0;
    }

    public function inc(name:String):int
    {
        var newCount:int = (_count[name] || 0) + 1;
        _count[name] = newCount;
        return newCount;
    }

    public function get count():Object
    {
        return _count;
    }
}
}
