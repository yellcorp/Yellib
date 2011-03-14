package org.yellcorp.lib.debug
{
public class ViewDebugUtil
{
    public static function makeIndexColor(index:int, base:Number = 2):uint
    {
        var scale8bit:Number = 0xFF / (base - 1);
        var result:uint;

        result = int((index % base) * scale8bit) << 16;
        index = int(index / base);

        result |= int((index % base) * scale8bit) << 8;
        index = int(index / base);

        result |= int((index % base) * scale8bit);

        return result;
    }
}
}
