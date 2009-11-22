package org.yellcorp.iterators
{
public interface Iterator
{
    function get item():*;
    function hasNext():Boolean;
    function next():void;
    function reset():void;
}
}
