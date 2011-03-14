package org.yellcorp.lib.color
{
import flash.geom.ColorTransform;


public class VectorRGB
{
    public var r:Number;
    public var g:Number;
    public var b:Number;

    private static const INVSCALE:Number = 1 / 255;

    public function VectorRGB(R:Number = 0, G:Number = 0, B:Number = 0)
    {
        r = R;
        g = G;
        b = B;
    }

    public function clone():VectorRGB
    {
        return new VectorRGB(r, g, b);
    }

    public function copy(from:VectorRGB):VectorRGB
    {
        r = from.r;
        g = from.g;
        b = from.b;
        return this;
    }

    public function toString():String
    {
        return "[VectorRGB " + r.toFixed(1) + ", " + g.toFixed(1) + ", " + b.toFixed(1) + "]";
    }

    public function setValue(R:Number, G:Number, B:Number):VectorRGB
    {
        r = R;
        g = G;
        b = B;
        return this;
    }

    public function setUint24(v:uint):VectorRGB
    {
        b = (v & 0xFF);
        g = ((v >>= 8) & 0xFF);
        r = ((v >>= 8) & 0xFF);
        return this;
    }

    public function getUint24():uint
    {
        var tr:Number = r;
        var tg:Number = g;
        var tb:Number = b;

        var v:uint;

        if (tr >= 255)
            v = 0xFF0000;
        else if (tr <= 0)
            v = 0;
        else
            v = int(r) << 16;

        if (tg >= 255)
            v |= 0xFF00;
        else if (tg > 0)
            v |= int(g) << 8;

        if (tb >= 255)
            v |= 0xFF;
        else if (tb > 0)
            v |= int(b);

        return v;
    }

    // COPY OPS
    public function plus(v:VectorRGB):VectorRGB
    {
        return new VectorRGB(r + v.r, g + v.g, b + v.b);
    }

    public function minus(v:VectorRGB):VectorRGB
    {
        return new VectorRGB(r - v.r, g - v.g, b - v.b);
    }

    public function scale(s:Number):VectorRGB
    {
        return new VectorRGB(r * s, g * s, b * s);
    }

    // SETTER OPS
    public function plusEquals(v:VectorRGB):VectorRGB
    {
        r += v.r;
        g += v.g;
        b += v.b;
        return this;
    }

    public function minusEquals(v:VectorRGB):VectorRGB
    {
        r -= v.r;
        g -= v.g;
        b -= v.b;
        return this;
    }

    public function scaleEquals(s:Number):VectorRGB
    {
        r *= s;
        g *= s;
        b *= s;
        return this;
    }

    public function clamp():VectorRGB
    {
        if (r < 0)   r = 0;
        if (r > 255) r = 255;
        if (g < 0)   g = 0;
        if (g > 255) g = 255;
        if (b < 0)   b = 0;
        if (b > 255) b = 255;

        return this;
    }

    // COMMON BLEND MODES
    // for others, see BlendModes.as if i can be arsed writing it
    public function blendMultiply(v:VectorRGB):VectorRGB
    {
        r *= v.r * INVSCALE;
        g *= v.g * INVSCALE;
        b *= v.b * INVSCALE;

        return this;
    }

    public function blendScreen(v:VectorRGB):VectorRGB
    {
        r = 255 - (255 - r) * (255 - v.r) * INVSCALE;
        g = 255 - (255 - g) * (255 - v.g) * INVSCALE;
        b = 255 - (255 - b) * (255 - v.b) * INVSCALE;

        return this;
    }

    public function blendDifference(v:VectorRGB):VectorRGB
    {
        r = Math.abs(r - v.r);
        g = Math.abs(g - v.g);
        b = Math.abs(b - v.b);

        return this;
    }

    public function applyTransform(t:ColorTransform):VectorRGB
    {
        r = r * t.redMultiplier   + t.redOffset;
        g = g * t.greenMultiplier + t.greenOffset;
        b = b * t.blueMultiplier  + t.blueOffset;
        return this;
    }

    /**
     * Note that this assumes alpha = 1 (100% opaque)
     * @param    m    A 20-member array (see ColorMatrixFilter)
     *              or a ColorMatrix object
     * @return
     */
    public function applyMatrix(m:Array):VectorRGB
    {
        var tr:Number = r;
        var tg:Number = g;
        var tb:Number = b;

        r = m[ 0] * tr + m[ 1] * tg + m[ 2] * tb + m[ 3] + m[ 4];
        g = m[ 5] * tr + m[ 6] * tg + m[ 7] * tb + m[ 8] + m[ 9];
        b = m[10] * tr + m[11] * tg + m[12] * tb + m[13] + m[14];

        return this;
    }

    // SCALAR
    public function equals(other:VectorRGB):Boolean
    {
        return r == other.r && g == other.g && b == other.b;
    }

    public function isNear(other:VectorRGB, epsilon:Number):Boolean
    {
        return Math.abs(r - other.r) <= epsilon &&
               Math.abs(g - other.g) <= epsilon &&
               Math.abs(b - other.b) <= epsilon;
    }

    // STATIC
    public static function lerp(u:VectorRGB, v:VectorRGB, t:Number, out:VectorRGB = null):VectorRGB
    {
        if (!out) out = new VectorRGB();
        out.r = u.r + t * (v.r - u.r);
        out.g = u.g + t * (v.g - u.g);
        out.b = u.b + t * (v.b - u.b);
        return out;
    }

    // FACTORY
    public static function fromUint24(v:uint):VectorRGB
    {
        return (new VectorRGB()).setUint24(v);
    }
}
}
