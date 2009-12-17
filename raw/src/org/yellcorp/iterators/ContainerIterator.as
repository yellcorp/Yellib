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

        reset();
    }

    public function hasNext():Boolean
    {
        return index != lastIndex;
    }

    public function next():*
    {
        var value:* = parent.getChildAt(index);
        index += (reverse ? -1 : 1);
        return value;
    }

    public function reset():void
    {
        lastIndex = reverse ? -1 : (parent.numChildren);
        index = reverse ? (parent.numChildren - 1) : 0;
    }
}
}
