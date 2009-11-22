package org.yellcorp.iterators
{
public class ArrayIterator implements Iterator
{
    protected var array:Array;
    protected var reverse:Boolean;
    protected var index:int;
    protected var lastIndex:int;

    public function ArrayIterator(array:Array, reverse:Boolean = false)
    {
        this.array = array;
        this.reverse = reverse;

        lastIndex = reverse ? 0 : (array.length - 1);

        reset();
    }

    public function hasNext():Boolean
    {
        return index != lastIndex;
    }

    public function next():void
    {
        index += (reverse ? -1 : 1);
    }

    public function reset():void
    {
        index = reverse ? (array.length - 1) : 0;
    }

    public function get item():*
    {
        return array[index];
    }
}
}
