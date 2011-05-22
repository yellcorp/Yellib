package org.yellcorp.lib.display
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;


public class ActivitySpinner extends Sprite
{
    public var idleParams:ActivitySpinnerParams;
    public var pulseParams:ActivitySpinnerParams;

    public var trail:Number = 1;
    public var speed:Number = 0.05;

    private var phase:Number = 0;

    private var calcPulseParams:ActivitySpinnerParams;
    private var workParams:ActivitySpinnerParams;

    private var _petalCount:int = 12;

    public function ActivitySpinner()
    {
        idleParams = new ActivitySpinnerParams(
            0x808080, 0, 4, 16, 32);

        pulseParams = new ActivitySpinnerParams(
            Number.NaN, 1);

        calcPulseParams = new ActivitySpinnerParams();
        workParams = new ActivitySpinnerParams();

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);

        rebuildDisplay();
    }

    public function get petalCount():int
    {
        return _petalCount;
    }

    public function set petalCount(new_petalCount:int):void
    {
        if (_petalCount !== new_petalCount)
        {
            _petalCount = new_petalCount;
            rebuildDisplay();
        }
    }

    private function onAddedToStage(event:Event):void
    {
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onRemovedFromStage(event:Event):void
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function rebuildDisplay():void
    {
        var petal:DisplayObject;
        var angle:Number = -360 / _petalCount;

        DisplayUtil.removeAllChildren(this);

        for (var i:int = 0; i < _petalCount; i++)
        {
            petal = new Shape();
            petal.rotation = i * angle;
            addChild(petal);
        }
    }

    private function onEnterFrame(event:Event):void
    {
        var petalPhase:Number;

        calcPulseParams.copy(pulseParams);
        calcPulseParams.inherit(idleParams);

        for (var i:int = 0; i < _petalCount; i++)
        {
            petalPhase = (i / (_petalCount) + phase) % 1;
            petalPhase = 1 - petalPhase / trail;
            if (petalPhase < 0) petalPhase = 0;

            drawLerpPetal(Shape(getChildAt(i)), petalPhase);
        }

        phase += speed;
    }

    private function drawLerpPetal(shape:Shape, tween:Number):void
    {
        var params:ActivitySpinnerParams;
        if (tween <= 0)
        {
            params = idleParams;
        }
        else if (tween >= 1)
        {
            params = calcPulseParams;
        }
        else
        {
            workParams.lerp(idleParams, calcPulseParams, tween);
            params = workParams;
        }
        drawPetal(shape.graphics, params);
    }

    private static function drawPetal(g:Graphics, params:ActivitySpinnerParams):void
    {
        var cornerRadius:Number = params.width * .5;

        g.clear();
        g.beginFill(params.color, params.alpha);
        g.drawRoundRectComplex(
            params.innerRadius, -params.width * .5,
            params.outerRadius - params.innerRadius, params.width,
            cornerRadius, cornerRadius, cornerRadius, cornerRadius);
        g.endFill();
    }
}
}
