package org.yellcorp.array
{
public class ArrayRandom
{
    public static function getRandom(array:Array):*
    {
        return array[Math.floor(Math.random() * array.length)];
    }

    public static function popRandom(array:Array):*
    {
        return array.splice(Math.floor(Math.random() * array.length), 1)[0];
    }

    public static function shuffle(array:Array):void
    {
        array.sort(cmpRandom);
    }

    public static function cmpRandom(a:*, b:*):int
    {
        return Math.random() < 0.5 ? -1 : 1;
    }
}
}
