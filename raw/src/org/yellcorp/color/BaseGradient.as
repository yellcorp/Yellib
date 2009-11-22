package org.yellcorp.color
{
import org.yellcorp.error.AbstractCallError;

import flash.display.Graphics;
import flash.geom.Matrix;


public class BaseGradient
{
    public function BaseGradient()
    {
    }

    public final function getRGB(point:Number, out:VectorRGB = null):VectorRGB
    {
        if (!out) out = new VectorRGB();
        putRGB(point, out);
        return out;
    }

    protected function putRGB(point:Number, out:VectorRGB):void
    {
        throw new AbstractCallError();
    }

    public function getAlpha(point:Number):Number
    {
        throw new AbstractCallError();
    }

    public function getColorArray():Array
    {
        throw new AbstractCallError();
    }

    public function getAlphaArray():Array
    {
        throw new AbstractCallError();
    }

    public function getRatioArray():Array
    {
        throw new AbstractCallError();
    }

    public final function beginGradientFillOn(g:Graphics,
                                              type:String,
                                              matrix:Matrix = null,
                                              spreadMethod:String = "pad",
                                              interpolationMethod:String = "rgb",
                                              focalPointRatio:Number = 0):void
    {
        g.beginGradientFill(type, getColorArray(), getAlphaArray(), getRatioArray(), matrix, spreadMethod, interpolationMethod, focalPointRatio);
    }

    public final function lineGradientStyleOn(g:Graphics,
                                              type:String,
                                              matrix:Matrix = null,
                                              spreadMethod:String = "pad",
                                              interpolationMethod:String = "rgb",
                                              focalPointRatio:Number = 0):void
    {
        g.lineGradientStyle(type, getColorArray(), getAlphaArray(), getRatioArray(), matrix, spreadMethod, interpolationMethod, focalPointRatio);
    }
}
}
