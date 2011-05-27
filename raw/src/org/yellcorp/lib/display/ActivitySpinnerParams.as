package org.yellcorp.lib.display
{
import org.yellcorp.lib.color.ColorUtil;


public class ActivitySpinnerParams
{
    public var color:Number;
    public var alpha:Number;
    public var width:Number;

    public var innerRadius:Number;
    public var outerRadius:Number;

    public var innerCornerRadius:Number;
    public var outerCornerRadius:Number;

    public function ActivitySpinnerParams(
        color:Number = Number.NaN,
        alpha:Number = Number.NaN,
        width:Number = Number.NaN,
        innerRadius:Number = Number.NaN,
        outerRadius:Number = Number.NaN,
        innerCornerRadius:Number = Number.NaN,
        outerCornerRadius:Number = Number.NaN)
    {
        this.color = color;
        this.alpha = alpha;
        this.width = width;
        this.innerRadius = innerRadius;
        this.outerRadius = outerRadius;
        this.innerCornerRadius = innerCornerRadius;
        this.outerCornerRadius = outerCornerRadius;
    }

    public function copy(from:ActivitySpinnerParams):void
    {
        color = from.color;
        alpha = from.alpha;
        width = from.width;
        innerRadius = from.innerRadius;
        outerRadius = from.outerRadius;
        innerCornerRadius = from.innerCornerRadius;
        outerCornerRadius = from.outerCornerRadius;
    }

    public function inherit(parent:ActivitySpinnerParams):void
    {
        if (isNaN(color))       color = parent.color;
        if (isNaN(alpha))       alpha = parent.alpha;
        if (isNaN(width))       width = parent.width;
        if (isNaN(innerRadius)) innerRadius = parent.innerRadius;
        if (isNaN(outerRadius)) outerRadius = parent.outerRadius;
        if (isNaN(innerCornerRadius)) innerCornerRadius = parent.innerCornerRadius;
        if (isNaN(outerCornerRadius)) outerCornerRadius = parent.outerCornerRadius;
    }

    public function lerp(a:ActivitySpinnerParams, b:ActivitySpinnerParams, t:Number):void
    {
        color = ColorUtil.lerp(a.color, b.color, t);
        alpha = a.alpha + t * (b.alpha - a.alpha);
        width = a.width + t * (b.width - a.width);
        innerRadius = a.innerRadius + t * (b.innerRadius - a.innerRadius);
        outerRadius = a.outerRadius + t * (b.outerRadius - a.outerRadius);
        innerCornerRadius = a.innerCornerRadius + t * (b.innerCornerRadius - a.innerCornerRadius);
        outerCornerRadius = a.outerCornerRadius + t * (b.outerCornerRadius - a.outerCornerRadius);
    }
}
}
