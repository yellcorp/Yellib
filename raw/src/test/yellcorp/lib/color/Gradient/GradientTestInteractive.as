package test.yellcorp.lib.color.Gradient
{
import org.yellcorp.lib.color.gradient.Gradient;
import org.yellcorp.lib.color.gradient.GradientVertex;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;


[SWF(backgroundColor="#808080", frameRate="60", width="640", height="480")]
public class GradientTestInteractive extends Sprite
{
    private var cursor:Number = 0;
    private var background:CheckerBox;

    public function GradientTestInteractive()
    {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        addChild(background = new CheckerBox(16, 16, 0x787878, 0x888888));

        testSimple();
        testEmpty();
        testSolid();
        testAddedInOrder();
        testAddedOutOfOrder();
        testColorModified();
        testParamModified();
        testRemoved();
        testAlpha();
        testColorConstructor();
        testAlphaConstructor();
        testRatioConstructor();
        testDegenerate();
    }

    private function testSimple():void
    {
        var grad:Gradient = new Gradient(false);
        grad.addVertex(new GradientVertex(  0, 0xFF0000));
        grad.addVertex(new GradientVertex(255, 0x0000FF));

        testGradient(grad, "Simple");
    }

    private function testEmpty():void
    {
        var grad:Gradient = new Gradient(false);
        testGradient(grad, "Empty");
    }

    private function testSolid():void
    {
        var grad:Gradient = new Gradient(false);
        grad.addVertex(new GradientVertex(0, 0xF4E077));
        testGradient(grad, "Solid");
    }

    private function testAddedInOrder():void
    {
        var grad:Gradient = new Gradient(false);
        grad.addVertex(new GradientVertex(  0, 0x00FFFF));
        grad.addVertex(new GradientVertex( 96, 0xFFFF00));
        grad.addVertex(new GradientVertex(255, 0xFF00FF));

        testGradient(grad, "Added in order");
    }

    private function testAddedOutOfOrder():void
    {
        var grad:Gradient = new Gradient(false);
        grad.addVertex(new GradientVertex(  0, 0x00FFFF));
        grad.addVertex(new GradientVertex(255, 0xFF00FF));
        grad.addVertex(new GradientVertex( 96, 0xFFFF00));

        testGradient(grad, "Added out of order");
    }

    private function testColorModified():void
    {
        var grad:Gradient = new Gradient(false);
        grad.addVertex(new GradientVertex(  0, 0x00FFFF));
        grad.addVertex(new GradientVertex(255, 0xFF00FF));
        grad.addVertex(new GradientVertex( 96, 0xFFFF00));

        grad.getVertexAtIndex(1).value = 0x0000FF;

        testGradient(grad, "Color modified through vertex ref");
    }

    private function testParamModified():void
    {
        var grad:Gradient = new Gradient(false);
        grad.addVertex(new GradientVertex(  0, 0x00FFFF));
        grad.addVertex(new GradientVertex(255, 0xFF00FF));
        grad.addVertex(new GradientVertex( 96, 0xFFFF00));

        grad.getVertexAtIndex(0).param = 127;

        testGradient(grad, "Param modified through vertex ref");
    }

    private function testRemoved():void
    {
        var grad:Gradient = new Gradient(false);
        grad.addVertex(new GradientVertex(  0, 0x00FFFF));
        grad.addVertex(new GradientVertex(255, 0xFF00FF));
        grad.addVertex(new GradientVertex( 96, 0xFFFF00));

        grad.removeVertexAtIndex(0);

        testGradient(grad, "Index 0 removed");
    }

    private function testAlpha():void
    {
        var grad:Gradient = new Gradient(true);
        grad.addVertex(new GradientVertex(  0, 0xFF000000));
        grad.addVertex(new GradientVertex( 64, 0x00000000));
        grad.addVertex(new GradientVertex(128, 0xFF0000FF));
        grad.addVertex(new GradientVertex(192, 0x00FF0000));
        grad.addVertex(new GradientVertex(255, 0xFF00FF00));

        testGradient(grad, "With alpha");
    }

    private function testColorConstructor():void
    {
        testGradient(
            new Gradient(false,
                [ 0x000000, 0xFF0000, 0x00FF00, 0x0000FF, 0xFFFFFF]),
            "With colors in constructor");
    }

    private function testAlphaConstructor():void
    {
        testGradient(
            new Gradient(true,
                [ 0x000000, 0xFF0000, 0x00FF00, 0x0000FF, 0xFFFFFF],
                [ 1, 0, .5, 0, 1 ]),
            "With alphas in constructor");
    }

    private function testRatioConstructor():void
    {
        testGradient(
            new Gradient(true,
                [ 0x000000, 0xFF0000, 0x00FF00, 0x0000FF, 0xFFFFFF],
                [ 1, 0, .5, 0, 1 ],
                [ 128, 192, 224, 240, 248 ]),
            "With ratios in constructor");
    }

    private function testDegenerate():void
    {
        var grad:Gradient = new Gradient(false);
        grad.addVertex(new GradientVertex(128, 0x00FFFF));
        grad.addVertex(new GradientVertex(128, 0xFF00FF));
        grad.addVertex(new GradientVertex(128, 0xFFFF00));

        testGradient(grad, "Degenerate");
    }

    private function testGradient(grad:Gradient, label:String):void
    {
        var control:GradientTestControl = new GradientTestControl(grad, label);
        addChild(control);
        control.y = cursor;
        cursor += control.height;
    }

    private function onAddedToStage(event:Event):void
    {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.addEventListener(Event.RESIZE, onResize);
        addEventListener(Event.ENTER_FRAME, onFrame);
    }

    private function onResize(event:Event):void
    {
        background.setSize(stage.stageWidth, stage.stageHeight);
    }

    private function onFrame(event:Event):void
    {
        if (stage.stageWidth && stage.stageHeight)
        {
            removeEventListener(Event.ENTER_FRAME, onFrame);
            stage.dispatchEvent(new Event(Event.RESIZE));
        }
    }
}
}
