package org.yellcorp.lib.random
{
import org.yellcorp.lib.random.generators.NativeRandom;
import org.yellcorp.lib.random.generators.RandomNumberGenerator;


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
