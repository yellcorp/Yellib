package org.yellcorp.lib.debug.console
{
import org.yellcorp.lib.ui.BaseDisplay;
import org.yellcorp.lib.ui.scrollbar.VerticalScrollBar;

import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;


public class DebugConsoleView extends BaseDisplay implements InputEditor
{
    private var controller:DebugConsole;

    private var background:InteractiveObject;
    private var sizeHandle:Sprite;
    private var outputScroll:VerticalScrollBar;
    private var _outputField:TextField;
    private var _inputField:TextField;
    private var skin:DebugConsoleSkin;

    public function DebugConsoleView(controller:DebugConsole, initialWidth:Number, initialHeight:Number, skin:DebugConsoleSkin)
    {
        this.controller = controller;
        this.skin = skin;

        super(initialWidth, initialHeight);

        addChild(background = skin.createBackground());
        addChild(sizeHandle = skin.createSizeHandle());
        addChild(_outputField = skin.createOutputField());
        addChild(outputScroll = skin.createOutputScrollBar());
        addChild(_inputField = skin.createInputField());

        sizeHandle.addEventListener(MouseEvent.MOUSE_DOWN, onSizeHandleDown);

        _outputField.autoSize = TextFieldAutoSize.NONE;
        _outputField.multiline = true;
        _outputField.selectable = true;
        _outputField.type = TextFieldType.DYNAMIC;
        _outputField.wordWrap = true;

        _inputField.autoSize = TextFieldAutoSize.NONE;
        _inputField.multiline = false;
        _inputField.selectable = true;
        _inputField.type = TextFieldType.INPUT;
        _inputField.wordWrap = false;

        initLayout();
        invalidate(SIZE);
    }

    public function getInput():String
    {
        return _inputField.text;
    }

    public function setInput(newInput:String):void
    {
        _inputField.text = newInput;
        _inputField.setSelection(newInput.length, newInput.length);
    }

    internal function get outputField():TextField
    {
        return _outputField;
    }

    internal function get inputField():TextField
    {
        return _inputField;
    }

    private function onSizeHandleDown(event:MouseEvent):void
    {
        sizeHandle.startDrag();
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onSizeHandleMove);
        stage.addEventListener(MouseEvent.MOUSE_UP, onSizeHandleUp);
    }

    private function onSizeHandleUp(event:MouseEvent):void
    {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSizeHandleMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onSizeHandleUp);
        sizeHandle.stopDrag();
        setSizeFromSizeHandle();
    }

    private function onSizeHandleMove(event:MouseEvent):void
    {
        setSizeFromSizeHandle();
    }

    private function setSizeFromSizeHandle():void
    {
        setSize(sizeHandle.x + sizeHandle.width + skin.windowGutter,
                sizeHandle.y + sizeHandle.height + skin.windowGutter);
    }

    protected override function draw():void
    {
        if (isInvalid(SIZE))
        {
            drawLayout();
        }
    }

    private function initLayout():void
    {
        _outputField.x =
        _outputField.y =
        _inputField.x =
        outputScroll.y =
            skin.windowGutter;
    }

    private function drawLayout():void
    {
        background.width = _width;
        background.height = _height;

        sizeHandle.x = _width - sizeHandle.width - skin.windowGutter;
        sizeHandle.y = _height - sizeHandle.height - skin.windowGutter;

        _inputField.width = sizeHandle.x - skin.controlGutter - _inputField.x;
        _inputField.y = _height - skin.windowGutter - _inputField.height;

        outputScroll.x = _width - outputScroll.width - skin.windowGutter;
        outputScroll.height = _inputField.y - skin.controlGutter - outputScroll.y;
        outputScroll.forceRedraw();

        _outputField.width = outputScroll.x - _outputField.x;
        _outputField.height = outputScroll.height;

        validate(SIZE);
    }

}
}
