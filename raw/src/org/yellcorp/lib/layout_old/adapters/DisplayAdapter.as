package org.yellcorp.lib.layout_old.adapters
{
import flash.display.DisplayObject;


public class DisplayAdapter extends BaseAdapter
{
    private var subject:DisplayObject;

    public function DisplayAdapter(subject:DisplayObject)
    {
        this.subject = subject;
    }
    public override function getX():Number
    {
        return subject.x;
    }
    public override function setX(v:Number):void
    {
        subject.x = v;
    }
    public override function getY():Number
    {
        return subject.y;
    }
    public override function setY(v:Number):void
    {
        subject.y = v;
    }
    public override function getWidth():Number
    {
        return subject.width;
    }
    public override function setWidth(v:Number):void
    {
        subject.width = v;
    }
    public override function getHeight():Number
    {
        return subject.height;
    }
    public override function setHeight(v:Number):void
    {
        subject.height = v;
    }
}
}
