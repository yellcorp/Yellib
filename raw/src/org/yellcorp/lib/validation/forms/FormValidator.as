package org.yellcorp.lib.validation.forms
{
import org.yellcorp.lib.validation.forms.controls.ControlValidator;
import org.yellcorp.lib.validation.forms.controls.ValidateControlEvent;

import flash.events.EventDispatcher;
import flash.utils.Dictionary;


[Event(name="accepted", type="org.yellcorp.lib.validation.forms.ValidateEvent")]
[Event(name="rejected", type="org.yellcorp.lib.validation.forms.ValidateEvent")]
public class FormValidator extends EventDispatcher
{
    private var validators:Array;
    private var touchedControls:Dictionary;

    public function FormValidator()
    {
        clear();
    }

    public function clear():void
    {
        if (validators)
        {
            while (validators.length > 0)
            {
                ControlValidator(validators.pop()).dispose();
            }
        }
        else
        {
            validators = [ ];
        }
        reset();
    }

    public function reset():void
    {
        touchedControls = new Dictionary(true);
    }

    public function add(validator:ControlValidator):void
    {
        validator.addEventListener(ValidateControlEvent.CHANGE, onControlChange, false, 0, true);
        validator.addEventListener(ValidateControlEvent.CHANGE_COMPLETE, onControlChangeComplete, false, 0, true);
        validators.push(validator);
    }

    public function validate():Boolean
    {
        var accepted:Boolean = true;

        for each (var validator:ControlValidator in validators)
        {
            accepted = validate1(validator, true) && accepted;
        }
        return accepted;
    }

    private function validate1(validator:ControlValidator, changesComplete:Boolean):Boolean
    {
        var result:ValidationValue = validator.validate(changesComplete);

        if (result.accepted)
        {
            dispatchEvent(
                new ValidateEvent(ValidateEvent.ACCEPTED,
                                  validator.control,
                                  result.controlValue,
                                  "",
                                  true));
            return true;
        }
        else
        {
            dispatchEvent(
                new ValidateEvent(ValidateEvent.REJECTED,
                                  validator.control,
                                  result.controlValue,
                                  result.message,
                                  false));
            return false;
        }
    }

    private function onControlChange(event:ValidateControlEvent):void
    {
        if (touchedControls[event.target])
        {
            validate1(ControlValidator(event.target), false);
        }
    }

    private function onControlChangeComplete(event:ValidateControlEvent):void
    {
        touchedControls[event.target] = true;
        validate1(ControlValidator(event.target), true);
    }
}
}
