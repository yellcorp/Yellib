package org.yellcorp.lib.validate.controls
{
import fl.controls.ComboBox;

import flash.events.Event;


public class ComboBoxValidator extends ControlValidator
{
    private var comboBox:ComboBox;

    public function ComboBoxValidator(validateFunction:Function, control:ComboBox, name:String)
    {
        super(validateFunction, control, name);

        comboBox = control;
        comboBox.addEventListener(Event.CHANGE, dispatchChangeComplete);
    }

    public override function dispose():void
    {
        comboBox.removeEventListener(Event.CHANGE, dispatchChangeComplete);
        comboBox = control;

        super.dispose();
    }

    protected override function getControlValue():*
    {
        return comboBox.selectedItem;
    }

    protected override function setControlValue(newValue:*):void
    {
        comboBox.selectedItem = newValue;
    }
}
}
