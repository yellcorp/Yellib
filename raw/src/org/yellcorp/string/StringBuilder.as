package org.yellcorp.string
{
public class StringBuilder
{
    private var buffer:Array;
    private var _length:int;

    public function StringBuilder(initialContents:* = "")
    {
        clear();
        if (initialContents) append(initialContents);
    }

    public function clear():void
    {
        buffer = [ ];
        _length = 0;
    }

    public function append(text:*):void
    {
        // Conversion rule: in String(arg), if arg is undefined, then the
        // returned value is also undefined, instead of the string
        // "undefined".  All other args return Strings, including null
        var string:String = text === undefined ? "undefined" : String(text);
        buffer.push(string);
        _length += string.length;
    }

    public function prepend(text:*):void
    {
        var string:String = text === undefined ? "undefined" : String(text);
        buffer.unshift(string);
        _length += string.length;
    }

    public function appendv(textArray:Array):void
    {
        var string:String = textArray.join("");
        buffer.push(string);
        _length += string.length;
    }

    public function appendva(... textArray):void
    {
        var string:String = textArray.join("");
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
