package org.yellcorp.layout.adapters
{
import flash.geom.Rectangle;


public class AdapterRectangle implements LayoutAdapter
{
    private var subject:Rectangle;

    public function AdapterRectangle(subject:Rectangle)
    {
        this.subject = subject;
    }

    public function getX():Number
    {
        return subject.x;
    }

    public function setX(value:Number):void
    {
        subject.x = value;
    }

    public function getY():Number
    {
        return subject.y;
    }

    public function setY(value:Number):void
    {
        subject.y = value;
    }

    public function getWidth():Number
    {
        return subject.width;
    }

    public function setWidth(value:Number):void
    {
        subject.width = value;
    }

    public function getHeight():Number
    {
        return subject.height;
    }

    public function setHeight(value:Number):void
    {
        subject.height = value;
    }

    public function getCenterX():Number
    {
        return subject.x + subject.width / 2;
    }

    public function setCenterX(value:Number):void
    {
        subject.x = value - subject.width / 2;
    }

    public function getCenterY():Number
    {
        return subject.y + subject.height / 2;
    }

    public function setCenterY(value:Number):void
    {
        subject.y = value - subject.height / 2;
    }
}
}
