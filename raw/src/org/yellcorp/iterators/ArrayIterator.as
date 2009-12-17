package org.yellcorp.iterators
{
public class ArrayIterator implements Iterator
{
    protected var array:Array;
    protected var reverse:Boolean;
    protected var index:int;
    protected var lastIndex:int;
    protected var step:Number;

    public function ArrayIterator(array:Array, reverse:Boolean = false)
    {
        this.array = array;
        this.reverse = reverse;
        step = reverse ? -1 : 1;

        lastIndex = reverse ? -1 : (array.length);

        reset();
    }

    public function hasNext():Boolean
    {
        return index != lastIndex;
    }

    public function next():*
    {
        var value:* = array[index];
        index += step;
        return value;
    }

    public function reset():void
    {
        index = reverse ? (array.length - 1) : 0;
    }
}
}
