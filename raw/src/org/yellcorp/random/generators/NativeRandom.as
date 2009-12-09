package org.yellcorp.random.generators
{
public class NativeRandom implements RandomNumberGenerator
{
    public function nextNumber():Number
    {
        return Math.random();
    }
}
}
