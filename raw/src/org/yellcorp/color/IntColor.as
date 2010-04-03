package org.yellcorp.color
{
public class IntColor
{
    private static const RED_SHIFT:uint =   16;
    private static const GREEN_SHIFT:uint =  8;

    private static const RED_MASK:uint =   0xFF0000;
    private static const GREEN_MASK:uint = 0x00FF00;
    private static const BLUE_MASK:uint =  0x0000FF;

    private static const norm:Number = 1 / 255;

    public static function make(r:uint, g:uint, b:uint):uint
    {
        return ((r << RED_SHIFT) & RED_MASK) |
               ((g << GREEN_SHIFT) & GREEN_MASK) |
               (b & BLUE_MASK);
    }

    public static function add(a:uint, b:uint):uint
    {
        var channel:uint;
        var result:uint;

        result = (a & BLUE_MASK) + (b & BLUE_MASK);
        if (result > BLUE_MASK) result = BLUE_MASK;

        channel = (a & GREEN_MASK) + (b & GREEN_MASK);
        if (channel > GREEN_MASK) channel = GREEN_MASK;
        result |= channel;

        channel = (a & RED_MASK) + (b & RED_MASK);
        if (channel > RED_MASK) channel = RED_MASK;

        return result | channel;
    }

    public static function multiply(a:uint, b:uint):uint
    {
        var channel:uint;
        var result:uint;

        result = (a & BLUE_MASK) * (b & BLUE_MASK) * norm;

        channel = ((a & GREEN_MASK) >> GREEN_SHIFT) *
                  ((b & GREEN_MASK) >> GREEN_SHIFT) * norm;
        result |= channel << GREEN_SHIFT;

        channel = ((a & RED_MASK) >> RED_SHIFT) *
                  ((b & RED_MASK) >> RED_SHIFT) * norm;

        return result | (channel << RED_SHIFT);
    }

    public static function screen(a:uint, b:uint):uint
    {
        var channel:uint;
        var result:uint;

        result = 255 - (255 - (a & BLUE_MASK)) *
                       (255 - (b & BLUE_MASK)) * norm;

        channel = 255 - (255 - ((a & GREEN_MASK) >> GREEN_SHIFT)) *
                        (255 - ((b & GREEN_MASK) >> GREEN_SHIFT)) * norm;
        result |= channel << GREEN_SHIFT;

        channel = 255 - (255 - ((a & RED_MASK) >> RED_SHIFT)) *
                        (255 - ((b & RED_MASK) >> RED_SHIFT)) * norm;

        return result | (channel << RED_SHIFT);
    }

    public static function difference(a:uint, b:uint):uint
    {
        var channel:int;
        var result:uint;

        channel = (a & BLUE_MASK) - (b & BLUE_MASK);
        result = channel < 0 ? -channel : channel;

        channel = ((a & GREEN_MASK) >> GREEN_SHIFT) -
                  ((b & GREEN_MASK) >> GREEN_SHIFT);
        result |= (channel < 0 ? -channel : channel) << GREEN_SHIFT;

        channel = ((a & RED_MASK) >> RED_SHIFT) -
                  ((b & RED_MASK) >> RED_SHIFT);
        return result | (channel < 0 ? -channel : channel) << RED_SHIFT;
    }

    public static function lerp(a:uint, b:uint, t:Number):uint
    {
        var channel:uint;
        var result:uint;

        channel = a & BLUE_MASK;
        result = channel + t * ((b & BLUE_MASK) - channel);

        channel = (a & GREEN_MASK) >> GREEN_SHIFT;
        result |= (channel + t * (((b & GREEN_MASK) >> GREEN_SHIFT) - channel)) << GREEN_SHIFT;

        channel = (a & RED_MASK) >> RED_SHIFT;
        return result | (channel + t * (((b & RED_MASK) >> RED_SHIFT) - channel)) << RED_SHIFT;
    }
}
}
