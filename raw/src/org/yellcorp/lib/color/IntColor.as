package org.yellcorp.lib.color
{
public class IntColor
{
    public static function make(r:uint, g:uint, b:uint):uint
    {
        return ((r << 16) & 0xFF0000) |
               ((g <<  8) & 0x00FF00) |
               (b & 0x0000FF);
    }

    public static function add(v:uint, w:uint):uint
    {
        var r:int, g:int, b:int;

        r = (v & 0xFF0000) + (w & 0xFF0000);
        if (r > 0xFF0000) r = 0xFF0000;

        g = (v & 0x00FF00) + (w & 0x00FF00);
        if (g > 0x00FF00) g = 0x00FF00;

        b = (v & 0x0000FF) + (w & 0x0000FF);
        if (b > 0x0000FF) b = 0x0000FF;

        return r | g | b;
    }

    public static function multiply(v:uint, w:uint):uint
    {
        var r:int, g:int, b:int;

        // the constant factor appearing below is 1/255

        r = ((v & 0xFF0000) >> 16) *
            ((w & 0xFF0000) >> 16) * 0.00392156862745098;

        g = ((v & 0x00FF00) >> 8) *
            ((w & 0x00FF00) >> 8) * 0.00392156862745098;

        b = (v & 0x0000FF) * (w & 0x0000FF) * 0.00392156862745098;

        return (r << 16) | (g << 8) | b;
    }

    public static function screen(v:uint, w:uint):uint
    {
        var r:int, g:int, b:int;

        r = 255 - (255 - ((v & 0xFF0000) >> 16)) *
                  (255 - ((w & 0xFF0000) >> 16)) * 0.00392156862745098;

        g = 255 - (255 - ((v & 0x00FF00) >> 8)) *
                  (255 - ((w & 0x00FF00) >> 8)) * 0.00392156862745098;

        b = 255 - (255 - (v & 0x0000FF)) *
                  (255 - (w & 0x0000FF)) * 0.00392156862745098;

        return (r << 16) | (g << 8) | b;
    }

    public static function difference(v:uint, w:uint):uint
    {
        var r:int, g:int, b:int;

        r = ((v & 0xFF0000) >> 16) -
            ((w & 0xFF0000) >> 16);
        if (r < 0) r = -r;

        g = ((v & 0x00FF00) >> 8) -
            ((w & 0x00FF00) >> 8);
        if (g < 0) g = -g;

        b = (v & 0x0000FF) - (w & 0x0000FF);
        if (b < 0) b = -b;

        return (r << 16) | (g << 8) | b;
    }

    public static function lerp(v:uint, w:uint, t:Number):uint
    {
        var r:int, g:int, b:int;

        r = (v & 0xFF0000) >> 16;
        r += t * (((w & 0xFF0000) >> 16) - r);

        g = (v & 0x00FF00) >> 8;
        g += t * (((w & 0x00FF00) >>  8) - g);

        b = v & 0x0000FF;
        b += t * ((w & 0x0000FF) - b);

        return (r << 16) | (g << 8) | b;
    }
}
}
