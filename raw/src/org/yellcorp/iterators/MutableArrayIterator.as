package org.yellcorp.iterators
{
import org.yellcorp.iterators.MutableIterator;


// god these names are getting java-ey already
public class MutableArrayIterator extends ArrayIterator implements MutableIterator
{
    public function set item(v:*):void
    {
        array[index] = v;
    }

    public function insert(v:*):void
    {
        array.splice(index, 0, v);
        if (reverse)
        {
            index++;
        }
        else
        {
            lastIndex++;
        }
    }

    public function remove():void
    {
        array.splice(index, 1);
        if (!reverse)
        {
            index--;
        }
    }
}
}
