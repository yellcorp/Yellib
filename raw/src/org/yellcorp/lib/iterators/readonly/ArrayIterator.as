package org.yellcorp.lib.iterators.readonly
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

        reset();
    }

    public function get valid():Boolean
    {
        return (step < 0) ? (index > lastIndex)
                          : (index < lastIndex);
    }

    public function get current():*
    {
        return array[index];
    }

    public function next():void
    {
        index += step;
    }

    public function reset():void
    {
        lastIndex = reverse ? -1 : (array.length);
        index = reverse ? (array.length - 1) : 0;
    }
}
}
