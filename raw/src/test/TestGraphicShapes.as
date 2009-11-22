package test
{
import org.yellcorp.display.GraphicsShapes;
import org.yellcorp.env.ResizableStage;


public class TestGraphicShapes extends ResizableStage
{
    public function TestGraphicShapes()
    {
        super();
    }

    protected override function onStageAvailable():void
    {
        var x:Number;
        var y:Number;

        var spacing:Number = 96;
        var radius1:Number = 32;
        var radius2:Number = 16;

        var sides:uint = 3;

        x = y = spacing *.5;

        while (y < 400)
        {
            while (x < 550)
            {
                graphics.lineStyle(1.5, 0x33CC99, 1);
                graphics.beginFill(0x33CC99, 0.6);
                //GraphicsShapes.drawPolygon(graphics, x, y, radius, sides++);
                GraphicsShapes.drawPolyStar(graphics, x, y, radius1, radius2, sides++);
                graphics.endFill();
                x += spacing;
            }
            x = spacing * .5;
            y += spacing;
        }
    }
}
}
