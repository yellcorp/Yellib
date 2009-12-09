package org.yellcorp.random
{
import org.yellcorp.random.generators.RandomNumberGenerator;


public class ArrayRandom
{
    public static function shuffle(array:Array, randomSource:RandomNumberGenerator = null):void
    {
        var remaining:uint = array.length;
        var chosenIndex:uint;
        var swapTemp:*;

        if (!randomSource)  {  randomSource = DefaultRandomSource.getSource();  }

        while (remaining > 1)
        {
            remaining--;
            chosenIndex = Math.floor(randomSource.nextNumber() * (remaining + 1));
            swapTemp = array[chosenIndex];
            array[chosenIndex] = array[remaining];
            array[remaining] = swapTemp;
        }
    }

    public static function chooseValue(array:Array, randomSource:RandomNumberGenerator = null):*
    {
        if (!randomSource)  {  randomSource = DefaultRandomSource.getSource();  }
        return array[Math.floor(randomSource.nextNumber() * array.length)];
    }

    public static function popValue(array:Array, randomSource:RandomNumberGenerator = null):*
    {
        if (!randomSource)  {  randomSource = DefaultRandomSource.getSource();  }
        return array.splice(Math.floor(randomSource.nextNumber() * array.length), 1)[0];
    }
}
}
