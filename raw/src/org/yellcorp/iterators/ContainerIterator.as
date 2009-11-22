package org.yellcorp.iterators
{
import org.yellcorp.iterators.Iterator;

import flash.display.DisplayObjectContainer;


public class ContainerIterator implements Iterator
{
    private var parent:DisplayObjectContainer;
    private var reverse:Boolean;
    private var index:int;
    private var lastIndex:int;

    public function ContainerIterator(parent:DisplayObjectContainer , reverse:Boolean = false)
    {
        this.parent = parent;
        this.reverse = reverse;

        lastIndex = reverse ? 0 : (parent.numChildren - 1);

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
        index = reverse ? (parent.numChildren - 1) : 0;
    }

    public function get item():*
    {
        return parent.getChildAt(index);
    }
}
}
