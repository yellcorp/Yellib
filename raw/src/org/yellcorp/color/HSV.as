package org.yellcorp.color
{
public class HSV
{
    public var h:Number;
    public var s:Number;
    public var v:Number;

    private static const INVSCALE:Number = 1 / 255;
    private static const INV60:Number = 1 / 60;

    public function HSV(hue:Number = 0, saturation:Number = 0, value:Number = 0)
    {
        h = hue;
        s = saturation;
        v = value;
    }

    public function clone():HSV
    {
        return new HSV(h, s, v);
    }

    public function copy(from:HSV):HSV
    {
        h = from.h;
        s = from.s;
        v = from.v;

        return this;
    }

    public function toString():String
    {
        return "[HSV {" + h.toFixed(1) + ", " + s.toFixed(3) + ", " + v.toFixed(3) + "}]";
    }

    public function convertToRGB(out:VectorRGB = null):VectorRGB
    {
        var floor:Number;
        var frac:Number;

        var hfrac:Number = h * INV60;
        var hcase:int = Math.floor(hfrac);
        hfrac -= hcase;
        if (hcase < 0 || hcase >= 6) hcase %= 6;

        if (!out) out = new VectorRGB();

        if (hcase & 1)
        {
            // falling channel
            frac = v * (1 - hfrac * s);
        }
        else
        {
            // rising channel
            frac = v * (1 - (1 - hfrac) * s);
        }

        floor = v * (1 - s);

        floor *= 255;
        frac *= 255;
        var scaledValue:int = v * 255;

        switch (hcase)
        {
            case 0 :
                out.setValue(scaledValue, frac, floor);
                break;
            case 1 :
                out.setValue(frac, scaledValue, floor);
                break;
            case 2:
                out.setValue(floor, scaledValue, frac);
                break;
            case 3:
                out.setValue(floor, frac, scaledValue);
                break;
            case 4:
                out.setValue(frac, floor, scaledValue);
                break;
            case 5:
                out.setValue(scaledValue, floor, frac);
                break;
            default:
                throw new Error("Internal error.  hcase=" + hcase);
                break;
        }

        return out;
    }

    public function convertFromRGB(rgb:VectorRGB):HSV
    {
        var r:Number = rgb.r * INVSCALE;
        var g:Number = rgb.g * INVSCALE;
        var b:Number = rgb.b * INVSCALE;

        var hi:Number = Math.max(r, g, b);
        var lo:Number = Math.min(r, g, b);

        if (hi == lo)
        {
            h = 0;    // no saturation, hue=0 by convention
        }
        else if (hi == r && g >= b)
        {
            // red to yellow
            h = 60 * (g - b) / (hi - lo) + 0;
        }
        else if (hi == r && g < b)
        {
            // magenta to red
            h = 60 * (g - b) / (hi - lo) + 360;
        }
        else if (hi == g)
        {
            // yellow to cyan
            h = 60 * (b - r) / (hi - lo) + 120;
        }
        else if (hi == b)
        {
            // cyan to magenta
            h = 60 * (r - g) / (hi - lo) + 240;
        }

        if (hi == 0)
        {
            s = 0;    // no brightness, sat=0 by conv.
        }
        else
        {
            s = 1 - (lo / hi);
        }

        v = hi;

        return this;
    }
}
}
