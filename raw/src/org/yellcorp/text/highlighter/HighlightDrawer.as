package org.yellcorp.text.highlighter
{
public interface HighlightDrawer
{
    function setScrollRect(x:int, y:int, width:Number, height:Number):void;
    function clearTextRuns():void;
    function drawTextRun(shape:TextRunShape):void;
}
}
