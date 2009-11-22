package org.yellcorp.layout.adapters
{
import flash.display.Stage;


public class AdapterStage implements LayoutAdapter
{
    private var stage:Stage;

    public function AdapterStage(stage:Stage)
    {
        this.stage = stage;
    }

    public function getX():Number
    {
        return stage.x;
    }

    public function setX(value:Number):void
    {
        stage.x = value;
    }

    public function getY():Number
    {
        return stage.y;
    }

    public function setY(value:Number):void
    {
        stage.y = value;
    }

    public function getWidth():Number
    {
        return stage.stageWidth;
    }

    public function setWidth(value:Number):void
    {
        stage.stageWidth = value;
    }

    public function getHeight():Number
    {
        return stage.stageHeight;
    }

    public function setHeight(value:Number):void
    {
        stage.stageHeight = value;
    }

    public function getCenterX():Number
    {
        return stage.x + stage.stageWidth / 2;
    }

    public function setCenterX(value:Number):void
    {
        stage.x = value - stage.stageWidth / 2;
    }

    public function getCenterY():Number
    {
        return stage.y + stage.stageHeight / 2;
    }

    public function setCenterY(value:Number):void
    {
        stage.y = value - stage.stageHeight / 2;
    }
}
}
