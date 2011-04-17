package org.yellcorp.lib.color.transform
{
import flash.geom.ColorTransform;


public class ColorTransformUtil
{
    public static function clear(out:ColorTransform):ColorTransform
    {
        out.redMultiplier   =
        out.greenMultiplier =
        out.blueMultiplier  =
        out.alphaMultiplier = 1;
        out.redOffset       =
        out.greenOffset     =
        out.blueOffset      =
        out.alphaOffset     = 0;

        return out;
    }

    public static function fromColorMatrix(m:Array, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        out.redMultiplier   = m[0];
        out.greenMultiplier = m[6];
        out.blueMultiplier  = m[12];
        out.alphaMultiplier = m[18];
        out.redOffset       = m[4];
        out.greenOffset     = m[9];
        out.blueOffset      = m[14];
        out.alphaOffset     = m[19];

        return out;
    }

    public static function invert(ct:ColorTransform, out:ColorTransform = null):ColorTransform
    {
        if (!out) out = new ColorTransform();

        var irm:Number = 1 / ct.redMultiplier;
        var igm:Number = 1 / ct.greenMultiplier;
        var ibm:Number = 1 / ct.blueMultiplier;
        var iam:Number = 1 / ct.alphaMultiplier;

        out.redMultiplier =   irm;
        out.greenMultiplier = igm;
        out.blueMultiplier =  ibm;
        out.alphaMultiplier = iam;

        out.redOffset *=   -irm;
        out.greenOffset *= -igm;
        out.blueOffset *=  -ibm;
        out.alphaOffset *= -iam;

        return out;
    }
}
}
