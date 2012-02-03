package org.yellcorp.lib.sound
{
import flash.media.SoundTransform;


/**
 * Performs matrix math on SoundTransform objects.
 *
 * If a stereo wave is considered a series of 2-member column vectors, a
 * SoundTransform can be considered as the following 2x2 matrix:
 *
 * [ LL RL ] [ V 0 ]
 * [ LR RR ] [ 0 V ]
 *
 * that is,
 *
 * [ V*LL  V*RL ]
 * [ V*LR  V*RR ]
 *
 * Where: LL is SoundTransform.leftToLeft
 *        RL is SoundTransform.rightToLeft
 *        LR is SoundTransform.leftToRight
 *        RR is SoundTransform.rightToRight
 *        V  is SoundTransform.volume
 */
public class SoundTransformMath
{
    /**
     * Mulitplies two SoundTransforms.
     */
    public static function multiply(s:SoundTransform, t:SoundTransform, out:SoundTransform = null):SoundTransform
    {
        if (!out) out = new SoundTransform();

        var a:Number, b:Number,
            c:Number, d:Number;

        var e:Number, f:Number,
            g:Number, h:Number;

        a = s.leftToLeft;   b = s.rightToLeft;
        c = s.leftToRight;  d = s.rightToRight;

        e = t.leftToLeft;   f = t.rightToLeft;
        g = t.leftToRight;  h = t.rightToRight;

        out.leftToLeft =   a * e + b * g;
        out.rightToLeft =  a * f + b * h;
        out.leftToRight =  c * e + d * g;
        out.rightToRight = c * f + d * h;

        out.volume = s.volume * t.volume;

        return out;
    }

    /**
     * Mulitplies two SoundTransforms in reverse order.
     */
    public static function concat(s:SoundTransform, t:SoundTransform, out:SoundTransform = null):SoundTransform
    {
        return multiply(t, s, out);
    }

    public static function determinant(s:SoundTransform):Number
    {
        return s.leftToLeft * s.rightToRight - s.rightToLeft * s.leftToRight;
    }

    public static function invert(s:SoundTransform, out:SoundTransform = null):SoundTransform
    {
        if (s.volume == 0)
        {
            return null;
        }

        var det:Number = determinant(s);
        if (det == 0)
        {
            return null;
        }
        var idet:Number = 1 / det;

        if (!out) out = new SoundTransform();

        out.volume = 1 / s.volume;

        out.leftToLeft = idet * s.rightToRight;
        out.rightToLeft = idet * -s.rightToLeft;
        out.leftToRight = idet * -s.leftToRight;
        out.rightToRight = idet * s.leftToLeft;

        return out;
    }
}
}
