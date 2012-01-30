package org.yellcorp.lib.validation.forms.controls
{
import flash.events.Event;
import flash.events.FocusEvent;
import flash.text.TextField;


public class TextFieldValidator extends ControlValidator
{
    private var changedSinceFocus:Boolean;
    private var textField:TextField;

    public function TextFieldValidator(validateFunction:Function, control:TextField, name:String)
    {
        super(validateFunction, control, name);

        textField = control;
        textField.addEventListener(Event.CHANGE, onChange);
        textField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
        textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
    }

    public override function dispose():void
    {
        textField.removeEventListener(Event.CHANGE, onChange);
        textField.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
        textField.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
        textField = null;

        super.dispose();
    }

    protected override function getControlValue():*
    {
        return textField.text;
    }

    protected override function setControlValue(newValue:*):void
    {
        textField.text = String(newValue) || "";
    }

    private function onFocusIn(event:FocusEvent):void
    {
        changedSinceFocus = false;
    }

    private function onFocusOut(event:FocusEvent):void
    {
        if (changedSinceFocus)
        {
            dispatchChangeComplete();
        }
    }

    private function onChange(event:Event):void
    {
        changedSinceFocus = true;
        dispatchChange();
    }
}
}
