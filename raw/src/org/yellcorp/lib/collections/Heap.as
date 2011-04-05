package org.yellcorp.lib.collections
{
import org.yellcorp.lib.iterators.readonly.Iterator;


public interface Heap
{
    function get length():int;
    function add(item:*):void;
    function peek():*;
    function remove():*;
    function get iterator():Iterator;
}
}
