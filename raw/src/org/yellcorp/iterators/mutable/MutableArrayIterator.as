package org.yellcorp.iterators.mutable
{
import org.yellcorp.iterators.readonly.ArrayIterator;


// god these names are getting java-ey already
public class MutableArrayIterator extends ArrayIterator implements MutableIterator
{
    public function setItem(v:*):void
    {
        array[index - step] = v;
    }

    public function insert(v:*):void
    {
        if (reverse)
        {
            array.splice(index + 1, 0, v);
        }
        else
        {
            array.splice(index, 0, v);
            ++index;
            ++lastIndex;
        }
    }

    public function remove():void
    {
        array.splice(index - step, 1);
        index -= step;
        if (!reverse)
        {
            --lastIndex;
        }
    }
}
}
