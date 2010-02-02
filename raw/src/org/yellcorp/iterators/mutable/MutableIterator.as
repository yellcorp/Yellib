package org.yellcorp.iterators.mutable
{
import org.yellcorp.iterators.readonly.Iterator;


public interface MutableIterator extends Iterator
{
    function set current(replaceValue:*):void;
    function insert(insertValue:*):void;
    function remove():void;
}
}
