package org.yellcorp.lib.debug
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.InteractiveObject;
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
    private var classNames:TextField;
    private var instanceNames:TextField;

    public function MouseDebugger(canvas:Sprite)
    {
        this.canvas = canvas;
        classNames = createTextField();
        instanceNames = createTextField();

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

        canvas.stage.addEventListener(Event.RESIZE, onStageResize);
        classNames.width = canvas.stage.stageWidth;
        instanceNames.width = canvas.stage.stageWidth;

        canvas.addChild(classNames);
        canvas.addChild(instanceNames);

        layout();
    }

    private function onRemovedFromStage(event:Event):void
    {
        canvas.removeEventListener(MouseEvent.MOUSE_OVER, onCanvasOver);
        canvas.removeEventListener(MouseEvent.MOUSE_OUT, onCanvasOut);
        canvas.stage.removeEventListener(MouseEvent.MOUSE_OVER, onStageOver);
        canvas.stage.removeEventListener(MouseEvent.MOUSE_OUT, onStageOut);
        canvas.stage.removeEventListener(Event.RESIZE, onStageResize);

        canvas.removeChild(classNames);
        canvas.removeChild(instanceNames);
    }

    private function onStageResize(event:Event):void
    {
        classNames.width = canvas.stage.stageWidth;
        instanceNames.width = canvas.stage.stageWidth;
        layout();
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
        classNames.text = "";
        instanceNames.text = "";

        if (target)
        {
            canvas.visible = true;
            drawRectHeirarchy(target);
            layout();
        }
    }

    private function onStageOut(event:MouseEvent):void
    {
    }

    private function layout():void
    {
        classNames.x = 0;
        classNames.y = 0;

        instanceNames.x = 0;
        instanceNames.y = classNames.height;
    }

    private function drawRectHeirarchy(subject:DisplayObject):void
    {
        var i:int;
        var nodes:Array = [ ];
        var color:uint;
        var text:String;

        while (subject && !(subject is Stage))
        {
            nodes.unshift(subject);
            subject = subject.parent;
        }

        for (i = 0; i < nodes.length; i++)
        {
            color = ViewDebugUtil.makeIndexColor(i + 1, 3);
            drawGuide(canvas, nodes[i], color);

            text = getDisplayName(nodes[i]);
            if (i > 0)
            {
                text = "." + text;
            }
            appendWithColor(classNames, text, color);

            text = nodes[i].name;
            if (i > 0)
            {
                text = "." + text;
            }
            appendWithColor(instanceNames, text, color);
        }

        if (subject is InteractiveObject)
        {
            text = "\nmouseEnabled=" + InteractiveObject(subject).mouseEnabled;
            if (subject is DisplayObjectContainer)
            {
                text += ", mouseChildren=" + DisplayObjectContainer(subject).mouseChildren;
            }
            appendWithColor(instanceNames, text, 0xFFFFFF);
        }
    }

    private static function appendWithColor(field:TextField, text:String, color:uint):void
    {
        field.appendText(text);
        field.setTextFormat(new TextFormat(null, null, color),
                field.text.length - text.length,
                field.text.length);
    }

    private static function drawGuide(canvas:Sprite, subject:DisplayObject, color:uint):void
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

    private static function createTextField():TextField
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

    private static function createStrokeFilter():BitmapFilter
    {
        return new GlowFilter(0, 1, 2, 2, 4, 1);
    }

    private static function getDisplayName(target:DisplayObject):String
    {
        var displayName:String = DebugUtil.getShortClassName(target);
        if (target.parent)
        {
            displayName += "[" + target.parent.getChildIndex(target) + "]";
        }
        return displayName;
    }
}
}
