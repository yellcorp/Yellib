package org.yellcorp.lib.validation.forms.controls
{
import org.yellcorp.lib.core.Disposable;
import org.yellcorp.lib.error.AbstractCallError;
import org.yellcorp.lib.validation.forms.ValidationValue;

import flash.events.Event;
import flash.events.EventDispatcher;


public class ControlValidator extends EventDispatcher implements Disposable
{
    private var validateFunction:Function;
    private var _control:*;
    private var _name:String;

    public function ControlValidator(validateFunction:Function, control:*, name:String)
    {
        this.validateFunction = validateFunction;
        _control = control;
        _name = name;
        super();
    }

    public function validate(changesComplete:Boolean):ValidationValue
    {
        var value:ValidationValue = new ValidationValue(getControlValue(), _name);

        validateFunction(value);

        if (changesComplete && value.accepted && value.modified)
        {
            setControlValue(value.controlValue);
        }
        return value;
    }

    public function dispose():void
    {
        validateFunction = null;
        _control = null;
    }

    public function get control():*
    {
        return _control;
    }

    public function get name():String
    {
        return _name;
    }

    protected function getControlValue():*
    {
        throw new AbstractCallError();
    }

    protected function setControlValue(newValue:*):void
    {
        throw new AbstractCallError();
    }

    protected final function dispatchChange(event:Event = null):void
    {
        dispatchEvent(new ValidateControlEvent(ValidateControlEvent.CHANGE));
    }

    protected final function dispatchChangeComplete(event:Event = null):void
    {
        dispatchEvent(new ValidateControlEvent(ValidateControlEvent.CHANGE_COMPLETE));
    }
}
}
