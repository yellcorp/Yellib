package org.yellcorp.iterators
{
public interface MutableIterator extends Iterator
{
    function setItem(replaceValue:*):void;
    function insert(insertValue:*):void;
    function remove():void;
}
}
