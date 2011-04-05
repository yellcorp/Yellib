package org.yellcorp.lib.collections
{
import org.yellcorp.lib.iterators.readonly.ArrayIterator;
import org.yellcorp.lib.iterators.readonly.Iterator;


public class BinaryHeap implements Heap
{
    // this will always begin with a null because the addressing is easier
    // to do when the items start at [1] instead of [0]
    // so it's effectively a 1-based index
    private var items:Array;

    private var comparator:Function;

    public function BinaryHeap(comparator:Function, initialContents:Array = null)
    {
        this.comparator = comparator;

        if (initialContents)
        {
            items = initialContents.slice();
            items.unshift(null);
            enforceHeap();
        }
        else
        {
            items = [ null ];
        }
    }

    public function get length():int
    {
        return items.length - 1;
    }

    public function add(item:*):void
    {
        items.push(item);
        upHeap();
    }

    public function peek():*
    {
        return items[1];
    }

    public function remove():*
    {
        var minItem:*;

        if (items.length == 2)
        {
            return items.pop();
        }
        else if (items.length > 2)
        {
            minItem = items[1];
            items[1] = items.pop();
            downHeap(1);
            return minItem;
        }
        else
        {
            return null;
        }
    }

    public function get iterator():Iterator
    {
        return new ArrayIterator(items);
    }

    private function upHeap():void
    {
        var subjectIndex:int = items.length - 1;
        var parentIndex:int;

        var subject:*;
        var parent:*;

        while (subjectIndex > 1)
        {
            parentIndex = subjectIndex >> 1;

            subject = items[subjectIndex];
            parent =  items[parentIndex];

            if (comparator(parent, subject) > 0)
            {
                items[subjectIndex] = parent;
                items[parentIndex] = subject;

                subjectIndex = parentIndex;
            }
            else
            {
                break;
            }
        }
    }

    private function downHeap(subjectIndex:int):void
    {
        var heapLen:int = items.length;

        var minIndex:int = 1;
        var minItem:*;

        var childIndex:int;
        var childItem:*;

        var temp:*;

        while (subjectIndex < heapLen)
        {
            childIndex = subjectIndex << 1;

            minIndex = subjectIndex;
            minItem = items[minIndex];

            if (childIndex < heapLen)
            {
                childItem = items[childIndex];
                if (comparator(minItem, childItem) > 0)
                {
                    minIndex = childIndex;
                    minItem = childItem;
                }

                if (++childIndex < heapLen)
                {
                    childItem = items[childIndex];
                    if (comparator(minItem, childItem) > 0)
                    {
                        minIndex = childIndex;
                        minItem = childItem;
                    }
                }
            }

            if (minIndex != subjectIndex)
            {
                temp = items[subjectIndex];
                items[subjectIndex] = minItem;
                items[minIndex] = temp;

                subjectIndex = minIndex;
            }
            else
            {
                return;
            }
        }

    }

    private function enforceHeap():void
    {
        for (var i:int = (items.length - 1) >> 1; i >= 1; i--)
        {
            downHeap(i);
        }
    }
}
}
