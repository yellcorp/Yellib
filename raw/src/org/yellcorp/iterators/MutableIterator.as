package org.yellcorp.iterators
{
public interface MutableIterator extends Iterator
{
    function set item(v:*):void;
    function insert(v:*):void;
    function remove():void;
}
}
