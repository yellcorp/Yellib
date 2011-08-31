package org.yellcorp.lib.color.gradient
{
/**
 * Represents a gradient object that can describe itself in terms of
 * parameters to Graphics.beginGradientFill or Graphics.lineGradientStyle
 */
public interface GraphicsGradient
{
    function getColorArray():Array;
    function getAlphaArray():Array;
    function getRatioArray():Array;
}
}
