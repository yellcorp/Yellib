package org.yellcorp.string
{
public class StringBuilder
{
    private var buffer:Array;
    private var _length:int;

    public function StringBuilder()
    {
        clear();
    }

    public function clear():void
    {
        buffer = [ ];
        _length = 0;
    }

    public function append(text:*):void
    {
        var string:String = (text as String) || text.toString();
        buffer.push(string);
        _length += string.length;
    }

    public function toString():String
    {
        return buffer.join("");
    }

    public function take():String
    {
        var string:String = toString();
        clear();
        return string;
    }

    public function get length():int
    {
        return _length;
    }
}
}
