package org.yellcorp.random.generators
{
import org.yellcorp.random.generators.RandomNumberGenerator;


public interface SeededRandomNumberGenerator extends RandomNumberGenerator
{
    function get seed():Number;
    function set seed(newSeed:Number):void;
    function reset():void;
}
}
