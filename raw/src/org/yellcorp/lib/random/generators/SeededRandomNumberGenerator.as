package org.yellcorp.lib.random.generators
{
public interface SeededRandomNumberGenerator extends RandomNumberGenerator
{
    function get seed():Number;
    function set seed(newSeed:Number):void;
    function reset():void;
}
}
