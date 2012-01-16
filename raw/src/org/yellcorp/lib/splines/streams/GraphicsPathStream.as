package org.yellcorp.lib.splines.streams
{
import flash.display.GraphicsPath;
import flash.display.GraphicsPathCommand;


public class GraphicsPathStream implements SplineStream
{
    public var winding:String;
    public var commands:Vector.<int>;
    public var data:Vector.<Number>;

    public function GraphicsPathStream(winding:String = "evenOdd")
    {
        this.winding = winding;
        clear();
    }

    public function moveTo(x:Number, y:Number):void
    {
        commands.push(GraphicsPathCommand.MOVE_TO);
        data.push(x, y);
    }

    public function lineTo(x:Number, y:Number):void
    {
        commands.push(GraphicsPathCommand.LINE_TO);
        data.push(x, y);
    }

    public function curveTo(cx:Number, cy:Number, px:Number, py:Number):void
    {
        commands.push(GraphicsPathCommand.CURVE_TO);
        data.push(cx, cy, px, py);
    }

    public function clear():void
    {
        commands = new Vector.<int>();
        data = new Vector.<Number>();
    }

    public function createGraphicsPath():GraphicsPath
    {
        return new GraphicsPath(commands, data, winding);
    }
}
}
