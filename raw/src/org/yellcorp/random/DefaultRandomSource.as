package org.yellcorp.random
{
import org.yellcorp.random.generators.NativeRandom;
import org.yellcorp.random.generators.RandomNumberGenerator;


internal class DefaultRandomSource
{
    private static var defaultRandomSource:RandomNumberGenerator;

    internal static function getSource():RandomNumberGenerator
    {
        if (!defaultRandomSource)
        {
            defaultRandomSource = new NativeRandom();
        }
        return defaultRandomSource;
    }
}
}
