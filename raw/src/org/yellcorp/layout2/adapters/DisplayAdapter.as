package org.yellcorp.layout2.adapters
{
import flash.display.DisplayObject;


public class DisplayAdapter extends BaseAdapter
{
    private var subject:DisplayObject;

    public function DisplayAdapter(newSubject:DisplayObject)
    {
        subject = newSubject;
    }
    public override function getX():Number
    {
        return subject.x;
    }
    public override function getY():Number
    {
        return subject.y;
    }
    public override function getWidth():Number
    {
        return subject.width;
    }
    public override function getHeight():Number
    {
        return subject.height;
    }
    public override function setX(n:Number):void
    {
        subject.x = n;
    }
    public override function setY(n:Number):void
    {
        subject.y = n;
    }
    public override function setWidth(n:Number):void
    {
        subject.width = n;
    }
    public override function setHeight(n:Number):void
    {
        subject.height = n;
    }
}
}
