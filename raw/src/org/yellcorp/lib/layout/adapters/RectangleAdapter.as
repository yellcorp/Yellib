package org.yellcorp.lib.layout.adapters
{
import flash.geom.Rectangle;


public class RectangleAdapter extends BaseAdapter
{
    private var subject:Rectangle;

    public function RectangleAdapter(subject:Rectangle)
    {
        this.subject = subject;
    }
    public override function getX():Number
    {
        return subject.x;
    }
    public override function setX(value:Number):void
    {
        subject.x = value;
    }
    public override function getY():Number
    {
        return subject.y;
    }
    public override function setY(value:Number):void
    {
        subject.y = value;
    }
    public override function getWidth():Number
    {
        return subject.width;
    }
    public override function setWidth(value:Number):void
    {
        subject.width = value;
    }
    public override function getHeight():Number
    {
        return subject.height;
    }
    public override function setHeight(value:Number):void
    {
        subject.height = value;
    }
}
}
