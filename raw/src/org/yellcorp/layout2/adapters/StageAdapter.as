package org.yellcorp.layout2.adapters
{
import flash.display.Stage;


public class StageAdapter extends BaseAdapter
{
    private var stage:Stage;

    public function StageAdapter(stage:Stage)
    {
        this.stage = stage;
    }
    public override function getX():Number
    {
        return stage.x;
    }
    public override function setX(value:Number):void
    {
        stage.x = value;
    }
    public override function getY():Number
    {
        return stage.y;
    }
    public override function setY(value:Number):void
    {
        stage.y = value;
    }
    public override function getWidth():Number
    {
        return stage.stageWidth;
    }
    public override function setWidth(value:Number):void
    {
        stage.stageWidth = value;
    }
    public override function getHeight():Number
    {
        return stage.stageHeight;
    }
    public override function setHeight(value:Number):void
    {
        stage.stageHeight = value;
    }
}
}
