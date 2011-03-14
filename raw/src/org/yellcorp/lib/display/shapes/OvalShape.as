package org.yellcorp.lib.display.shapes
{
public class OvalShape extends BaseFilledOutlinedShape
{
    public function OvalShape(startWidth:Number, startHeight:Number)
    {
        super(startWidth, startHeight);
    }

    protected override function draw(w:Number, h:Number):void
    {
        graphics.drawEllipse(0, 0, w, h);
    }
}
}
