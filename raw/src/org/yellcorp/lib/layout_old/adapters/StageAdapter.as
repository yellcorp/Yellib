package org.yellcorp.lib.layout_old.adapters
{
import flash.display.Stage;


public class StageAdapter extends BaseAdapter
{
    private var subject:Stage;

    public function StageAdapter(subject:Stage)
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
        return subject.stageWidth;
    }
    public override function setWidth(v:Number):void
    {
        subject.stageWidth = v;
    }
    public override function getHeight():Number
    {
        return subject.stageHeight;
    }
    public override function setHeight(v:Number):void
    {
        subject.stageHeight = v;
    }
}
}
