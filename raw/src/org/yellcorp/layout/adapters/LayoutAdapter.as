package org.yellcorp.layout.adapters
{

public interface LayoutAdapter
{
    // not getters or setters so the
    // evaluating object can store closures

    function getX():Number;
    function setX(value:Number):void;

    function getY():Number;
    function setY(value:Number):void;

    function getWidth():Number;
    function setWidth(value:Number):void;

    function getHeight():Number;
    function setHeight(value:Number):void;

    function getCenterX():Number;
    function setCenterX(value:Number):void;

    function getCenterY():Number;
    function setCenterY(value:Number):void;
}
}
