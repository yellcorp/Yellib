package org.yellcorp.debug.console
{
import org.yellcorp.ui.BaseDisplay;
import org.yellcorp.ui.scrollbar.VerticalScrollBar;

import flash.display.InteractiveObject;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;


public class DebugConsoleView extends BaseDisplay
{
    private var background:InteractiveObject;
    private var sizeHandle:InteractiveObject;
    private var outputField:TextField;
    private var outputScroll:VerticalScrollBar;
    private var inputField:TextField;
    private var skin:DebugConsoleSkin;

    public function DebugConsoleView(initialWidth:Number, initialHeight:Number, skin:DebugConsoleSkin)
    {
        this.skin = skin;

        super(initialWidth, initialHeight);

        addChild(background = skin.createBackground());
        addChild(sizeHandle = skin.createSizeHandle());
        addChild(outputField = skin.createOutputField());
        addChild(outputScroll = skin.createOutputScrollBar());
        addChild(inputField = skin.createInputField());

        outputField.autoSize = TextFieldAutoSize.NONE;
        outputField.multiline = true;
        outputField.selectable = true;
        outputField.type = TextFieldType.DYNAMIC;
        outputField.wordWrap = true;

        inputField.autoSize = TextFieldAutoSize.NONE;
        inputField.multiline = false;
        inputField.selectable = true;
        inputField.type = TextFieldType.INPUT;
        inputField.wordWrap = false;

        initLayout();
        invalidateSize();
    }

    protected override function draw():void
    {
        if (invalidSize)
        {
            drawLayout();
        }
    }

    private function initLayout():void
    {
        outputField.x =
        outputField.y =
        inputField.x =
        outputScroll.y =
            skin.windowGutter;
    }

    private function drawLayout():void
    {
        background.width = _width;
        background.height = _height;

        sizeHandle.x = _width - sizeHandle.width - skin.windowGutter;
        sizeHandle.y = _height - sizeHandle.height - skin.windowGutter;

        inputField.width = sizeHandle.x - skin.controlGutter - inputField.x;
        inputField.y = _height - skin.windowGutter - inputField.height;

        outputScroll.x = _width - outputScroll.width - skin.windowGutter;
        outputScroll.height = inputField.y - skin.controlGutter - outputScroll.y;
        outputScroll.forceRedraw();

        outputField.width = outputScroll.x - outputField.x;
        outputField.height = outputScroll.height;

        invalidSize = false;
    }
}
}
