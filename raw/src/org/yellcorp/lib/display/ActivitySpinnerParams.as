package org.yellcorp.lib.display
{
import org.yellcorp.lib.color.IntColorUtil;


public class ActivitySpinnerParams
{
    public var color:Number;
    public var alpha:Number;
    public var width:Number;
    public var innerRadius:Number;
    public var outerRadius:Number;

    public function ActivitySpinnerParams(
        color:Number = Number.NaN,
        alpha:Number = Number.NaN,
        width:Number = Number.NaN,
        innerRadius:Number = Number.NaN,
        outerRadius:Number = Number.NaN)
    {
        this.color = color;
        this.alpha = alpha;
        this.width = width;
        this.innerRadius = innerRadius;
        this.outerRadius = outerRadius;
    }

    public function copy(from:ActivitySpinnerParams):void
    {
        color = from.color;
        alpha = from.alpha;
        width = from.width;
        innerRadius = from.innerRadius;
        outerRadius = from.outerRadius;
    }

    public function inherit(parent:ActivitySpinnerParams):void
    {
        if (isNaN(color))       color = parent.color;
        if (isNaN(alpha))       alpha = parent.alpha;
        if (isNaN(width))       width = parent.width;
        if (isNaN(innerRadius)) innerRadius = parent.innerRadius;
        if (isNaN(outerRadius)) outerRadius = parent.outerRadius;
    }

    public function lerp(a:ActivitySpinnerParams, b:ActivitySpinnerParams, t:Number):void
    {
        color = IntColorUtil.lerp(a.color, b.color, t);
        alpha = a.alpha + t * (b.alpha - a.alpha);
        width = a.width + t * (b.width - a.width);
        innerRadius = a.innerRadius + t * (b.innerRadius - a.innerRadius);
        outerRadius = a.outerRadius + t * (b.outerRadius - a.outerRadius);
    }
}
}
