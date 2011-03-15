package org.yellcorp.lib.debug.console
{
import org.yellcorp.lib.core.Disposable;

import flash.events.KeyboardEvent;
import flash.events.TextEvent;
import flash.ui.Keyboard;


public class DebugConsole implements Disposable, CompletionCandidates
{
    private var skin:DebugConsoleSkin;
    private var _view:DebugConsoleView;
    private var inputHistory:InputHistory;
    private var tabCompleter:InputCompleter;

    public function DebugConsole(initialWidth:Number, initialHeight:Number, skin:DebugConsoleSkin)
    {
        this.skin = skin;
        _view = new DebugConsoleView(this, initialWidth, initialHeight, skin);

        _view.inputField.addEventListener(KeyboardEvent.KEY_DOWN, onInputKeyDown);
        _view.inputField.addEventListener(TextEvent.TEXT_INPUT, onInputText);

        inputHistory = new InputHistory(_view);
        tabCompleter = new InputCompleter(_view, this);
    }

    public function dispose():void
    {
        _view = null;
        inputHistory = null;
        tabCompleter = null;
    }

    public function get view():DebugConsoleView
    {
        return _view;
    }

    public function getCandidates(input:String):Array
    {
        // TODO: getCandidates
        return null;
    }

    public function clearInput():void
    {
        _view.setInput("");
        markInputEdited();
    }

    private function markInputEdited():void
    {
        tabCompleter.edited();
        inputHistory.edited();
    }

    private function processInput(getInput:String):void
    {
        // TODO: processInput
    }

    private function onInputKeyDown(event:KeyboardEvent):void
    {
        switch (event.keyCode)
        {
            case Keyboard.ENTER :
                inputHistory.commit();
                processInput(_view.getInput());
                clearInput();
            case Keyboard.TAB :
                tabCompleter.advance(event.shiftKey ? -1 : 1);
                break;
            case Keyboard.UP :
                inputHistory.step(-1);
                break;
            case Keyboard.DOWN :
                inputHistory.step(1);
                break;
        }
    }

    private function onInputText(event:TextEvent):void
    {
        markInputEdited();
    }
}
}
