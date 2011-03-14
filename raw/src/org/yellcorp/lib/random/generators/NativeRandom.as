package org.yellcorp.lib.random.generators
{
public class NativeRandom implements RandomNumberGenerator
{
    public function nextNumber():Number
    {
        return Math.random();
    }
}
}
