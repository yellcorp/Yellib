package org.yellcorp.lib.color.vector
{
import org.yellcorp.lib.color.IntColorUtil;
import org.yellcorp.lib.error.AssertError;
import org.yellcorp.lib.geom.Vector3;

import flash.geom.ColorTransform;


public class VectorColorUtil
{
    public static function clamp(v:Vector3):Vector3
    {
        if (v.x > 1) v.x = 1;
        else if (v.x < 0) v.x = 0;

        if (v.y > 1) v.y = 1;
        else if (v.y < 0) v.y = 0;

        if (v.z > 1) v.z = 1;
        else if (v.z < 0) v.z = 0;

        return v;
    }

    public static function uintToVector(uintColor:uint, out:Vector3 = null):Vector3
    {
        if (!out) out = new Vector3();

        out.x = ((uintColor & 0xFF0000) >>> 16) * 0.00392156862745098;
        out.y = ((uintColor & 0x00FF00) >>>  8) * 0.00392156862745098;
        out.z =  (uintColor & 0x0000FF)         * 0.00392156862745098;

        return out;
    }

    public static function vectorToUint(v:Vector3):uint
    {
        return IntColorUtil.makeRGB(v.x * 0xFF, v.y * 0xFF, v.z * 0xFF);
    }

    public static function convertRGBtoHSV(rgb:Vector3, out:Vector3 = null):Vector3
    {
        var r:Number = rgb.x;
        var g:Number = rgb.y;
        var b:Number = rgb.z;

        var h:Number, s:Number;

        if (!out) out = new Vector3();

        var hi:Number = Math.max(r, g, b);
        var lo:Number = Math.min(r, g ,b);

        if (hi == lo)
        {
            h = 0;    // no saturation, hue=0 by convention
        }
        else if (lo == b)
        {
            // red to green
            h = (g - r) / (hi - lo) + 1;
        }
        else if (lo == r)
        {
            // green to blue
            h = (b - g) / (hi - lo) + 3;
        }
        else if (lo == g)
        {
            // blue to red
            h = (r - b) / (hi - lo) + 5;
        }

        if (hi == 0)
        {
            s = 0;    // no brightness, sat=0 by convention
        }
        else
        {
            s = 1 - (lo / hi);
        }

        // h is on a 0-6 interval, scale it to 0-1
        // value is equal to hi
        out.setValues(h / 6, s, hi);
        return out;
    }

    public static function convertHSVtoRGB(hsv:Vector3, out:Vector3 = null):Vector3
    {
        var h:Number = hsv.x * 6;
        var s:Number = hsv.y;
        var v:Number = hsv.z;

        var hzone:int, param:Number;
        var min:Number = v * (1 - s);

        if (!out) out = new Vector3();

        if (v == 0)
        {
            out.setValues(0, 0, 0);
            return out;
        }

        if (s == 0)
        {
            out.setValues(v, v, v);
            return out;
        }

        if (h < 0)
        {
            h = h % 6 + 6;
        }
        else if (h > 6)
        {
            h %= 6;
        }

        hzone =  Math.floor(h);
        param = (h - hzone) * v * s;

        switch (hzone)
        {
            case 0 :
                // red to yellow: r=v, g=rising, b=min
                out.setValues(v, min + param, min);
                break;

            case 1 :
                // yellow to green: r=falling, g=v, b=min
                out.setValues(v - param, v, min);
                break;

            case 2 :
                // green to cyan: r=min, g=v, b=rising
                out.setValues(min, v, min + param);
                break;

            case 3 :
                // cyan to blue: r=min, g=falling, b=v
                out.setValues(min, v - param, v);
                break;

            case 4 :
                // blue to magenta: r=rising, g=min, b=v
                out.setValues(min + param, min, v);
                break;

            case 5 :
                // magenta to red: r=v, g=min, b=falling
                out.setValues(v, min, v - param);
                break;

            default :
                AssertError.assert(false, "Bad hzone: " + hzone);
                break;
        }

        return out;
    }

    public static function applyColorTransform(v:Vector3, t:ColorTransform):void
    {
        v.x = v.x * t.redMultiplier   + t.redOffset / 255;
        v.y = v.z * t.greenMultiplier + t.greenOffset / 255;
        v.z = v.y * t.blueMultiplier  + t.blueOffset / 255;
    }

    public static function applyColorMatrix(v:Vector3, m:Array, alpha:Number = 1):Number
    {
        var r:Number = v.x;
        var g:Number = v.y;
        var b:Number = v.z;

        v.x = (m[ 0] * r) + (m[ 1] * g) + (m[ 2] * b) + (m[ 3] * alpha) + m[ 4] / 255;
        v.y = (m[ 5] * r) + (m[ 6] * g) + (m[ 7] * b) + (m[ 8] * alpha) + m[ 9] / 255;
        v.z = (m[10] * r) + (m[11] * g) + (m[12] * b) + (m[13] * alpha) + m[14] / 255;

        return (m[15] * r) + (m[16] * g) + (m[17] * b) + (m[18] * alpha) + m[19] / 255;
    }
}
}
