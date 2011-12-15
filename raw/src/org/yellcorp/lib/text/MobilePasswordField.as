package org.yellcorp.lib.text
{
import org.yellcorp.lib.core.StringUtil;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.text.TextField;
import flash.ui.Keyboard;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;


[Event(name="change", type="flash.events.Event")]
public class MobilePasswordField extends EventDispatcher
{
    public var hideCharacterDelay:Number = 1000;
    public var maskCharacter:String = String.fromCharCode(0x2022); // U+2022 BULLET
    private var _text:String;
    
    private var textField:TextField;
    private var textFieldSemaphore:int = 1;
    
    private var selectionStart:int;
    private var selectionEnd:int;
    private var insertedText:String;
    private var action:uint = UNKNOWN;
    private var hideTimeoutId:uint;
    private var hideWaiting:Boolean = false;
    
    private static const UNKNOWN:uint = 0;
    private static const INSERT:uint = 1;
    private static const DELETE_BEFORE:uint = 2;
    private static const DELETE_AFTER:uint = 3;

    public function MobilePasswordField(textField:TextField)
    {
        super();
        this.textField = textField;
        endInternalEdit();
        textField.text = _text = ""; 
    }

    private function onFieldKeyUp(event:KeyboardEvent):void
    {
        updateSelectionRange();
    }

    private function onFieldMouseDown(event:MouseEvent):void
    {
        textField.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, true);
        updateSelectionRange();
    }

    private function onStageMouseUp(event:MouseEvent):void
    {
        textField.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, true);
        updateSelectionRange();
    }

    private function onFieldKeyDown(event:KeyboardEvent):void
    {
        updateSelectionRange();
        switch (event.keyCode)
        {
        case Keyboard.DELETE:
            action = DELETE_AFTER;
            break;
        case Keyboard.BACKSPACE:
            action = DELETE_BEFORE;
            break;
        }
    }

    private function onFieldTextInput(event:TextEvent):void
    {
        updateSelectionRange();
        action = INSERT;
        insertedText = event.text;
    }

    private function onFieldChange(event:Event):void
    {
        beginInternalEdit();
        
        if (action == INSERT)
        {
            _text = StringUtil.splice(_text, selectionStart, selectionEnd, insertedText);
        }
        else if (textField.length < _text.length)
        {
            if (selectionStart == selectionEnd)
            {
                if (action == DELETE_AFTER)
                {
                    _text = StringUtil.splice(_text, selectionStart, selectionStart + 1, "");
                }
                else if (action == DELETE_BEFORE)
                {
                    _text = StringUtil.splice(_text, selectionStart - 1, selectionStart, "");
                }
                else
                {
                    // some text has been deleted without a selection and 
                    // without recognizing a keypress. in this case we can't 
                    // tell which chars should be deleted, so panic and clear 
                    // everything rather than potentially corrupting the stored
                    // text
                    _text = "";
                }
            }
            else
            {
                _text = StringUtil.splice(_text, selectionStart, selectionEnd, "");
            }
        }
        
        if (insertedText)
        {
            revealCharacter(selectionStart + insertedText.length - 1);
            insertedText = null;
        }
        else
        {
            hideAllCharacters();
        }
        
        action = UNKNOWN;
        insertedText = null;
        endInternalEdit();
        trace(_text);
    }

    private function revealCharacter(charIndex:int):void
    {
        clearHideTimeout();
        
        hideTimeoutId = setTimeout(hideAllCharacters, hideCharacterDelay);
        hideWaiting = true;
        
        beginInternalEdit();
        if (_text.length == 0)
        {
            textField.text = "";
        }
        else
        {
            textField.text = StringUtil.repeat(maskCharacter, charIndex) +
                             _text.charAt(charIndex) +
                             StringUtil.repeat(maskCharacter, _text.length - charIndex - 1);
        }
        endInternalEdit();
    }

    private function hideAllCharacters():void
    {
        clearHideTimeout();
        
        beginInternalEdit();
        textField.text = StringUtil.repeat(maskCharacter, _text.length);
        endInternalEdit();
    }

    private function clearHideTimeout():void
    {
        if (hideWaiting)
        {
            clearTimeout(hideTimeoutId);
        }
    }

    private function updateSelectionRange():void
    {
        selectionStart = textField.selectionBeginIndex;
        selectionEnd = textField.selectionEndIndex;
    }

    public function get text():String
    {
        return _text;
    }

    public function set text(new_text:String):void
    {
        if (new_text != _text)
        {
            _text = new_text;
            hideAllCharacters();
            dispatchEvent(new Event(Event.CHANGE));
        }
    }

    private function endInternalEdit():void
    {
        textFieldSemaphore--;
        if (textFieldSemaphore == 0)
        {
            // listen for these events and update changes to selection range.
            // this must be done because not all text changes result in an
            // event that allows us to read the state of the selection before
            // it is changed. most commonly, deletes and backspaces with and
            // without selected text, and cutting/pasting using the context menu
            
            // changes can be made without any keyboard events at all; i.e.
            // mousedown -> highlight text -> mouseup -> context menu -> delete
            textField.addEventListener(MouseEvent.MOUSE_DOWN, onFieldMouseDown);
            textField.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
            
            // these are listed in the order they occur
            textField.addEventListener(KeyboardEvent.KEY_DOWN, onFieldKeyDown);
            
            // dispatched only by operations that add text, before the change is
            // made. we can read the pre-change selection state here
            textField.addEventListener(TextEvent.TEXT_INPUT, onFieldTextInput);
            
            // after the change is made
            textField.addEventListener(Event.CHANGE, onFieldChange);
            textField.addEventListener(KeyboardEvent.KEY_UP, onFieldKeyUp);
        }
    }

    private function beginInternalEdit():void
    {
        if (textFieldSemaphore == 0)
        {
            textField.removeEventListener(MouseEvent.MOUSE_DOWN, onFieldMouseDown);
            textField.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
            textField.removeEventListener(KeyboardEvent.KEY_DOWN, onFieldKeyDown);
            textField.removeEventListener(KeyboardEvent.KEY_UP, onFieldKeyUp);
            textField.removeEventListener(TextEvent.TEXT_INPUT, onFieldTextInput);
            textField.removeEventListener(Event.CHANGE, onFieldChange);
        }
        textFieldSemaphore++;
    }
}
}
