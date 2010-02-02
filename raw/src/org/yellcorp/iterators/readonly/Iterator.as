package org.yellcorp.iterators.readonly
{
public interface Iterator
{
    function get valid():Boolean;
    function get current():*
    function next():void;
    function reset():void;
}
}
