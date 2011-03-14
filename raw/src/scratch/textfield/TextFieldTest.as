package scratch.textfield
{
import org.yellcorp.lib.env.ResizableStage;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;
import flash.ui.Keyboard;


public class TextFieldTest extends ResizableStage
{
    private var field:TextField;
    private var debugCanvas:Shape;
    private var charIndex:int;

    public function TextFieldTest()
    {
        super();
        addChild(field = makeTextField());
        addChild(debugCanvas = new Shape());
        field.x = 20;
        field.y = 20;
        align(debugCanvas, field);

        field.text = "Line 0\n" +
        "\n" +
        "Line 2 with word wrap " +
            "Line 2 with word wrap " +
            "Line 2 with word wrap " +
            "Line 2 with word wrap " +
            "Line 2 with word wrap " +
            "Line 2 with word wrap " +
            "Line 2 with word wrap\n" +
        "Line 4\n" +
        "Line 5 no linebreak";

        field.setTextFormat(new TextFormat(null, 18), 10, 20);

        charIndex = 0;
        drawCharRect();

        trace(field.getLineMetrics(0).height);
    }

    private function drawCharRect():void
    {
        debugCanvas.graphics.clear();
        drawCharBounds(field, charIndex, debugCanvas.graphics);
        drawLineRect(field, field.getLineIndexOfChar(charIndex), debugCanvas.graphics);
    }

    private function drawLineRect(field:TextField, line:int, g:Graphics):void
    {
        var metrics:TextLineMetrics = field.getLineMetrics(line);
        var lineY:Number = getLineY(field, line);
        var localPoint:Point = field.globalToLocal(new Point(metrics.x, y));

        g.lineStyle(1, makeIndexColor(line));
        g.drawRect(localPoint.x, lineY, metrics.width, metrics.height);
    }

    private function getLineY(field:TextField, line:int):Number
    {
        var y:Number = 0;
        while (line > 0)
        {
            y += field.getLineMetrics(line - 1).height;
            line--;
        }
        return y + 2; // doesn't account for hardcoded 2 pixel gutter
    }

    private function drawCharBounds(field:TextField, char:int, g:Graphics):void
    {
        var bounds:Rectangle = field.getCharBoundaries(char);
        if (bounds)
        {
            g.lineStyle(1, makeIndexColor(char));
            g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
        }
    }

    private function align(toMove:DisplayObject, reference:DisplayObject):void
    {
        toMove.x = reference.x;
        toMove.y = reference.y;
    }

    protected override function onStageResize():void
    {
        field.width = stage.stageWidth - field.x * 2;
        field.height = stage.stageHeight - field.y * 2;
        drawCharRect();
    }

    protected override function onStageAvailable():void
    {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
    }

    private function onKey(event:KeyboardEvent):void
    {
        switch (event.keyCode)
        {
            case Keyboard.RIGHT :
                charIndex += 1;
                break;
            case Keyboard.LEFT :
                charIndex -= 1;
                break;
        }
        drawCharRect();
    }

    private function onMouseWheel(event:MouseEvent):void
    {
        charIndex += event.delta / Math.abs(event.delta);
    }

    private function makeTextField():TextField
    {
        var tf:TextField = new TextField();

        tf.border = true;
        tf.borderColor = 0x333333;
        tf.multiline = true;
        tf.wordWrap = true;
        tf.type = TextFieldType.INPUT;

        return tf;
    }

    private static function makeIndexColor(index:int):uint
    {
        var inChannelBits:int = 2;
        var inChannelMax:int = (1 << inChannelBits) - 1;
        var outChannelShift:int = 0;
        var color:uint = 0;

        var channelValue:Number;

        while (outChannelShift <= 16)
        {
            channelValue = (index & inChannelMax) / inChannelMax;
            color |= int(channelValue * 0xFF) << outChannelShift;

            index >>= inChannelBits;
            outChannelShift += 8;
        }
        return color;
    }
}
}
