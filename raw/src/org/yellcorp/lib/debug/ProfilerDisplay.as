package org.yellcorp.lib.debug
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.Timer;
import flash.utils.getTimer;


public class ProfilerDisplay extends Sprite
{
    private var frames:SampleSet;
    private var mem:SampleSet;

    private var memTimer:Timer;
    private var drawTimer:Timer;
    private var lastTime:int;

    private var canvas:Shape;

    // display
    private var memGraph:BitmapData;
    private var memDisplay:Bitmap;
    private var memMax:TextField;
    private var memMin:TextField;
    private var memCurrent:TextField;

    private var frameGraph:BitmapData;
    private var frameDisplay:Bitmap;
    private var frameMax:TextField;
    private var frameMin:TextField;
    private var frameAvg:TextField;
    private var gutter:int = 6;

    private var bg:Sprite;

    private var wait:int = 0;

    public function ProfilerDisplay()
    {
        super();
        frames = new SampleSet(128);
        mem = new SampleSet(128);

        canvas = new Shape();

        memTimer = new Timer(500, 0);
        memTimer.addEventListener(TimerEvent.TIMER, sampleMem, false, 0, true);

        drawTimer = new Timer(1000, 0);
        drawTimer.addEventListener(TimerEvent.TIMER, draw, false, 0, true);

        createDisplay();
        layout();

        memTimer.start();
        drawTimer.start();
        addEventListener(Event.ENTER_FRAME, sampleFrame, false, 0, true);
    }

    private function createDisplay():void
    {
        frameGraph = new BitmapData(192, 24, true, 0x80FF00FF);
        frameDisplay = new Bitmap(frameGraph);
        addChild(frameDisplay);

        memGraph = new BitmapData(192, 32, true, 0x80FF00FF);
        memDisplay = new Bitmap(memGraph, PixelSnapping.AUTO, false);
        addChild(memDisplay);

        memMax = new TextField();
        memMin = new TextField();
        memCurrent = new TextField();

        frameMax = new TextField();
        frameMin = new TextField();
        frameAvg = new TextField();

        initText(memMax, memMin, memCurrent, frameMax, frameMin, frameAvg);

        bg = new Sprite();
        bg.graphics.beginFill(0x333333, .5);
        bg.graphics.drawRoundRect(0, 0, gutter*3, gutter*3, gutter*2, gutter*2);
        bg.graphics.endFill();
        bg.scale9Grid = new Rectangle(gutter, gutter, gutter, gutter);

        addChildAt(bg, 0);
    }

    private function initText(... fields):void
    {
        var tf:TextField;

        for each (tf in fields)
        {
            tf.defaultTextFormat = getTextFormat();
            tf.text = "+00000 kb";
            tf.width = tf.textWidth + 4;
            tf.height = tf.textHeight + 4;
            tf.selectable = false;
            addChild(tf);
        }
    }

    private function getTextFormat():TextFormat
    {
        var tf:TextFormat = new TextFormat();
        tf.font = "_sans";
        tf.size = 8;
        tf.color = 0xCCCCCC;
        tf.align = TextFormatAlign.RIGHT;

        return tf;
    }

    private function layout():void
    {
        layoutSet(frameDisplay, frameMax, frameMin, frameAvg, 0, 0, gutter);
        layoutSet(memDisplay, memMax, memMin, memCurrent, 0, frameDisplay.y + frameDisplay.height, gutter);
        bg.width = frameAvg.x + frameAvg.width + gutter;
        bg.height = memDisplay.y + memDisplay.height + gutter;
    }

    private function layoutSet(bmp:Bitmap,
                               max:TextField, min:TextField, val:TextField,
                               x:Number, y:Number, pad:Number):void
    {
        max.x = min.x = x + pad;
        bmp.x = max.x + max.width + pad;
        val.x = bmp.x + bmp.width + pad;

        bmp.y = y + pad;

        max.y = bmp.y;
        min.y = bmp.y + bmp.height - min.height;
        val.y = bmp.y + (bmp.height - val.height) / 2;
    }

    private function draw(event:TimerEvent):void
    {
        var memMinVal:Number = mem.getMin();
        var memDiff:Number = (mem.getMax() - memMinVal) >> 10;
        var memDiffStr:String = memDiff.toString();

        if (memDiff > 0) memDiffStr = "+" + memDiffStr;

        //wait = 2;

        canvas.graphics.clear();
        canvas.graphics.lineStyle(0, 0x33CCFF);
        memGraph.fillRect(memGraph.rect, 0);
        mem.draw(memGraph, canvas);

        // >> 10 = integer div by1024 (2^10)
        memMin.text = (memMinVal >> 10) + " kb";
        memMax.text = memDiffStr + " kb";
        memCurrent.text = (mem.getLast() >> 10) + " kb";

        canvas.graphics.clear();
        canvas.graphics.lineStyle(0, 0x33FF66);
        frameGraph.fillRect(frameGraph.rect, 0);
        frames.draw(frameGraph, canvas);

        frameMin.text = frames.getMin() + " ms";
        frameMax.text = frames.getMax() + " ms";
        frameAvg.text = frames.getAverage().toFixed(1) + " ms";
    }

    private function sampleMem(event:TimerEvent):void
    {
        mem.add(System.totalMemory);
    }

    private function sampleFrame(event:Event):void
    {
        var time:int = getTimer();

        if (wait > 0)
        {
            wait--;
        }
        else
        {
            if (lastTime > 0)
                frames.add(time - lastTime);
        }

        lastTime = time;
    }
}
}
