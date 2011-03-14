package org.yellcorp.lib.display.shapes
{
public class RectangleShape extends BaseFilledOutlinedShape
{
    public function RectangleShape(startWidth:Number, startHeight:Number)
    {
        super(startWidth, startHeight);
    }

    protected override function draw(w:Number, h:Number):void
    {
        graphics.drawRect(0, 0, w, h);
    }
}
}
