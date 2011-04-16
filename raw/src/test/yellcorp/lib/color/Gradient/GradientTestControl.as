package test.yellcorp.lib.color.Gradient
{
import org.yellcorp.lib.color.gradient.Gradient;
import org.yellcorp.lib.color.gradient.GradientFill;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


public class GradientTestControl extends Sprite
{
    private static const GRADIENT_WIDTH:int = 256;
    private static const SWATCH_WIDTH:int = 32;
    private static const HEIGHT:int = 32;

    private var gradient:Gradient;

    private var gradientDisplay:Sprite;
    private var colorSwatch:Shape;
    private var labelField:TextField;
    private var alphaSwatch:Shape;

    public function GradientTestControl(gradient:Gradient, label:String)
    {
        this.gradient = gradient;

        setupView();
        setupEvents();

        labelField.text = label;

        drawGradient(gradientDisplay.graphics, gradient, GRADIENT_WIDTH, HEIGHT);
    }

    private function drawGradient(target:Graphics, gradient:GradientFill, width:int, height:int):void
    {
        var fillTransform:Matrix = new Matrix();

        fillTransform.createGradientBox(width, height);

        target.clear();

        target.beginGradientFill(
            GradientType.LINEAR,
            gradient.getColorArray(),
            gradient.getAlphaArray(),
            gradient.getRatioArray(),
            fillTransform);

        target.drawRect(0, 0, width, height);

        target.endFill();
    }

    private function setupView():void
    {
        addChild(gradientDisplay = new Sprite());
        addChild(colorSwatch = new Shape());
        addChild(alphaSwatch = new Shape());
        colorSwatch.x = GRADIENT_WIDTH;
        alphaSwatch.x = colorSwatch.x + SWATCH_WIDTH;

        addChild(labelField = new TextField());
        labelField.x = alphaSwatch.x + SWATCH_WIDTH;

        labelField.multiline = true;
        labelField.wordWrap = false;
        labelField.height = HEIGHT;
        labelField.defaultTextFormat =
            new TextFormat("_sans", 11, 0xFFFFFF);

        labelField.autoSize = TextFieldAutoSize.LEFT;
    }

    private function setupEvents():void
    {
        gradientDisplay.addEventListener(MouseEvent.MOUSE_OUT, onGradientMouseOut);
        gradientDisplay.addEventListener(MouseEvent.MOUSE_MOVE, onGradientMouseMove);
    }

    private function onGradientMouseOut(event:MouseEvent):void
    {
        drawNullSwatch(colorSwatch.graphics);
        drawNullSwatch(alphaSwatch.graphics);
    }

    private function onGradientMouseMove(event:MouseEvent):void
    {
        drawColorAt(255 * event.localX / gradientDisplay.width);
    }

    private function drawColorAt(param:Number):void
    {
        var cg:Graphics = colorSwatch.graphics;

        cg.clear();
        cg.beginFill(gradient.getParamRGB(param));
        cg.drawRect(0, 0, SWATCH_WIDTH, HEIGHT);
        cg.endFill();

        var ag:Graphics = alphaSwatch.graphics;
        ag.clear();
        ag.beginFill(int(gradient.getParamAlpha(param) * 0xFF) * 0x010101);
        ag.drawRect(0, 0, SWATCH_WIDTH, HEIGHT);
        ag.endFill();
    }

    private function drawNullSwatch(g:Graphics):void
    {
        g.clear();
        g.lineStyle(2, 0xEE3344);
        g.drawRect(0, 0, SWATCH_WIDTH, HEIGHT);
        g.moveTo(0, HEIGHT);
        g.lineTo(SWATCH_WIDTH, 0);
    }
}
}
