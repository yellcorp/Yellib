package org.yellcorp.iterators
{
import org.yellcorp.random.generators.NativeRandom;
import org.yellcorp.random.generators.RandomNumberGenerator;


public class ArrayRandomIterator implements Iterator
{
    private var array:Array;
    private var remaining:uint;
    private var choices:Array;
    private var arrayIndex:int;

    private var randomSource:RandomNumberGenerator;

    public function ArrayRandomIterator(array:Array, randomSource:RandomNumberGenerator = null)
    {
        this.array = array;
        this.randomSource = randomSource || new NativeRandom();
        reset();
    }

    public function hasNext():Boolean
    {
        return remaining > 0;
    }

    public function next():void
    {
        var choiceIndex:int;

        choiceIndex = Math.floor(randomSource.nextNumber() * remaining);
        arrayIndex = choices[choiceIndex];

        // swap used indices with those at the end of the array -
        // as remaining decreases, being the upper bound of the
        // random, the end of the array becomes off limits

        remaining--;

        // don't swap if we picked an index that is *going to*
        // become off limits anyway

        if (choiceIndex != remaining)
        {
            choices[choiceIndex] = choices[remaining];
            choices[remaining] = arrayIndex;
        }
    }

    public function reset():void
    {
        var i:int;

        remaining = array.length;

        choices = [ ];
        for (i = 0; i < remaining; i++)
        {
            choices[i] = i;
        }
    }

    public function get item():*
    {
        return array[arrayIndex];
    }
}
}
