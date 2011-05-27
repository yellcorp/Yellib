package org.yellcorp.lib.color
{
import flash.geom.ColorTransform;


public class ColorUtil
{
    public static function makeRGB(r:Number, g:Number, b:Number):uint
    {
        var ir:int, ig:int, ib:int;

        if (r < 0) ir = 0;
        else if (r > 0xFF) ir = 0xFF;
        else ir = int(r);

        if (g < 0) ig = 0;
        else if (g > 0xFF) ig = 0xFF;
        else ig = int(g);

        if (b < 0) ib = 0;
        else if (b > 0xFF) ib = 0xFF;
        else ib = int(b);

        return (r << 16) | (g << 8) | b;
    }

    public static function makeARGB(r:Number, g:Number, b:Number, a:Number):uint
    {
        var ia:int;

        if (a < 0) ia = 0;
        else if (a > 0xFF) ia = 0xFF;
        else ia = int(a);

        return (a << 24) | makeRGB(r, g, b);
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

    public static function subtract(v:uint, w:uint):uint
    {
        var r:int, g:int, b:int;

        r = (v & 0xFF0000) - (w & 0xFF0000);
        if (r < 0) r = 0;

        g = (v & 0x00FF00) - (w & 0x00FF00);
        if (g < 0) g = 0;

        b = (v & 0x0000FF) - (w & 0x0000FF);
        if (b < 0) b = 0;

        return r | g | b;
    }

    public static function multiply(v:uint, w:uint):uint
    {
        var r:int, g:int, b:int;

        // the constant factor appearing below is 1/255

        r = ((v & 0xFF0000) >>> 16) *
            ((w & 0xFF0000) >>> 16) * 0.00392156862745098;

        g = ((v & 0x00FF00) >>> 8) *
            ((w & 0x00FF00) >>> 8) * 0.00392156862745098;

        b = (v & 0x0000FF) * (w & 0x0000FF) * 0.00392156862745098;

        return (r << 16) | (g << 8) | b;
    }

    public static function screen(v:uint, w:uint):uint
    {
        var r:int, g:int, b:int;

        r = 255 - (255 - ((v & 0xFF0000) >>> 16)) *
                  (255 - ((w & 0xFF0000) >>> 16)) * 0.00392156862745098;

        g = 255 - (255 - ((v & 0x00FF00) >>> 8)) *
                  (255 - ((w & 0x00FF00) >>> 8)) * 0.00392156862745098;

        b = 255 - (255 - (v & 0x0000FF)) *
                  (255 - (w & 0x0000FF)) * 0.00392156862745098;

        return (r << 16) | (g << 8) | b;
    }

    public static function difference(v:uint, w:uint):uint
    {
        var r:int, g:int, b:int;

        r = ((v & 0xFF0000) >>> 16) -
            ((w & 0xFF0000) >>> 16);
        if (r < 0) r = -r;

        g = ((v & 0x00FF00) >>> 8) -
            ((w & 0x00FF00) >>> 8);
        if (g < 0) g = -g;

        b = (v & 0x0000FF) - (w & 0x0000FF);
        if (b < 0) b = -b;

        return (r << 16) | (g << 8) | b;
    }

    public static function lerp(v:uint, w:uint, t:Number):uint
    {
        var r:int, g:int, b:int;

        r = (v & 0xFF0000) >>> 16;
        r += t * (((w & 0xFF0000) >>> 16) - r);

        g = (v & 0x00FF00) >>> 8;
        g += t * (((w & 0x00FF00) >>>  8) - g);

        b = v & 0x0000FF;
        b += t * ((w & 0x0000FF) - b);

        return (r << 16) | (g << 8) | b;
    }

    public static function applyColorTransformARGB(v:uint, t:ColorTransform):Number
    {
        var a:Number, r:Number, g:Number, b:Number;

        a = ((v & 0xFF000000) >>> 24) * t.alphaMultiplier + t.alphaOffset;
        r = ((v & 0x00FF0000) >>> 16) * t.redMultiplier + t.redOffset;
        g = ((v & 0x0000FF00) >>> 8) * t.greenMultiplier + t.greenOffset;
        b =  (v & 0x000000FF) * t.blueMultiplier + t.blueOffset;

        return makeARGB(r, g, b, a);
    }

    public static function applyColorMatrixARGB(v:uint, m:Array):uint
    {
        var va:int = (v & 0xFF000000) >>> 24;
        var vr:int = (v & 0x00FF0000) >>> 16;
        var vg:int = (v & 0x0000FF00) >>> 8;
        var vb:int =  v & 0x000000FF;

        var ua:Number, ur:Number, ug:Number, ub:Number;

        ur = (m[ 0] * vr) + (m[ 1] * vg) + (m[ 2] * vb) + (m[ 3] * va) + m[ 4];
        ug = (m[ 5] * vr) + (m[ 6] * vg) + (m[ 7] * vb) + (m[ 8] * va) + m[ 9];
        ub = (m[10] * vr) + (m[11] * vg) + (m[12] * vb) + (m[13] * va) + m[14];
        ua = (m[15] * vr) + (m[16] * vg) + (m[17] * vb) + (m[18] * va) + m[19];

        return makeARGB(ur, ug, ub, ua);
    }
}
}
