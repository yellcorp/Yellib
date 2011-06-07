package org.yellcorp.lib.core
{
public class Stack
{
    private var stack:Array;
    private var _top:*;

    public function Stack()
    {
        stack = [ ];
    }

    public function push(value:*):void
    {
        stack.push(_top);
        _top = value;
    }

    public function pop():*
    {
        var removed:* = _top;
        _top = stack.pop();
        return removed;
    }

    public function get top():*
    {
        return _top;
    }

    public function get length():uint
    {
        return stack.length;
    }
}
}
