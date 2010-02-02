package org.yellcorp.iterators.readonly
{
import flash.display.DisplayObjectContainer;


public class ContainerIterator implements Iterator
{
    protected var parent:DisplayObjectContainer;
    protected var reverse:Boolean;
    protected var index:int;
    protected var lastIndex:int;
    protected var step:Number;

    public function ContainerIterator(container:DisplayObjectContainer, reverse:Boolean = false)
    {
        parent = container;
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
        return parent.getChildAt(index);
    }

    public function next():void
    {
        index += step;
    }

    public function reset():void
    {
        lastIndex = reverse ? -1 : (parent.numChildren);
        index = reverse ? (parent.numChildren - 1) : 0;
    }
}
}
