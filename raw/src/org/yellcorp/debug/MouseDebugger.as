package org.yellcorp.debug
{
import org.yellcorp.display.ViewDebugUtil;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BitmapFilter;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.utils.getQualifiedClassName;


public class MouseDebugger
{
    private var canvas:Sprite;
    private var caption:TextField;

    public function MouseDebugger(canvas:Sprite)
    {
        this.canvas = canvas;
        caption = createTextField();

        canvas.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
        canvas.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
        if (canvas.stage)
        {
            onAddedToStage();
        }
    }

    private function onAddedToStage(event:Event = null):void
    {
        canvas.addEventListener(MouseEvent.MOUSE_OVER, onCanvasOver);
        canvas.addEventListener(MouseEvent.MOUSE_OUT, onCanvasOut);
        canvas.stage.addEventListener(MouseEvent.MOUSE_OVER, onStageOver);
        canvas.stage.addEventListener(MouseEvent.MOUSE_OUT, onStageOut);

        canvas.stage.addEventListener(Event.RESIZE, onResize);
        caption.width = canvas.stage.stageWidth;

        canvas.addChild(caption);

        caption.x = 0;
        caption.y = 0;
    }

    private function onRemovedFromStage(event:Event):void
    {
        canvas.removeEventListener(MouseEvent.MOUSE_OVER, onCanvasOver);
        canvas.removeEventListener(MouseEvent.MOUSE_OUT, onCanvasOut);
        canvas.stage.removeEventListener(MouseEvent.MOUSE_OVER, onStageOver);
        canvas.stage.removeEventListener(MouseEvent.MOUSE_OUT, onStageOut);
        canvas.stage.removeEventListener(Event.RESIZE, onResize);

        canvas.removeChild(caption);
    }

    private function onResize(event:Event):void
    {
        caption.width = canvas.stage.stageWidth;
    }

    private function onCanvasOver(event:MouseEvent):void
    {
        canvas.visible = false;
        event.stopPropagation();
    }

    private function onCanvasOut(event:MouseEvent):void
    {
    }

    private function onStageOver(event:MouseEvent):void
    {
        var g:Graphics = canvas.graphics;
        var target:DisplayObject = event.target as DisplayObject;

        g.clear();
        caption.text = "";

        if (target)
        {
            canvas.visible = true;
            drawRectHeirarchy(canvas, target, caption);
        }
    }

    private function onStageOut(event:MouseEvent):void
    {
    }

    private function drawRectHeirarchy(canvas:Sprite, subject:DisplayObject, field:TextField):void
    {
        var i:int;
        var nodes:Array = [ ];
        var color:uint;
        var name:String;

        while (subject && !(subject is Stage))
        {
            nodes.unshift(subject);
            subject = subject.parent;
        }

        for (i = 0; i < nodes.length; i++)
        {
            color = ViewDebugUtil.makeIndexColor(i + 1, 3);
            drawGuide(canvas, nodes[i], color);

            name = getDisplayName(nodes[i]);
            if (i > 0)
            {
                name = "." + name;
            }

            appendWithColor(field, name, color);
        }
    }

    private function appendWithColor(field:TextField, text:String, color:uint):void
    {
        field.appendText(text);
        field.setTextFormat(new TextFormat(null, null, color),
                field.text.length - text.length,
                field.text.length);
    }

    private function drawGuide(canvas:Sprite, subject:DisplayObject, color:uint):void
    {
        var g:Graphics = canvas.graphics;
        var rect:Rectangle;

        rect = subject.getRect(canvas);

        g.lineStyle(2, color);
        g.drawRect(rect.x, rect.y, rect.width, rect.height);
        g.lineStyle(1, color);
        g.moveTo(rect.left, rect.top + 16);
        g.lineTo(rect.left + 16, rect.top);
    }

    private function createTextField():TextField
    {
        var t:TextField;
        var tf:TextFormat;

        t = new TextField();
        t.type = TextFieldType.DYNAMIC;
        t.autoSize = TextFieldAutoSize.LEFT;
        t.multiline = true;
        t.wordWrap = true;

        tf = new TextFormat("_sans", 12, 0xFFFFFF, true);
        t.defaultTextFormat = tf;
        t.setTextFormat(tf);

        t.filters = [ createStrokeFilter() ];

        return t;
    }

    private function createStrokeFilter():BitmapFilter
    {
        return new GlowFilter(0, 1, 2, 2, 4, 1);
    }

    private static function getDisplayName(target:DisplayObject):String
    {
        return getLeafName(getQualifiedClassName(target));
    }

    private static function getLeafName(className:String):String
    {
        var sep:int = className.indexOf("::");
        if (sep >= 0)
        {
            return className.substr(sep + 2);
        }
        else
        {
            return className;
        }
    }
}
}
