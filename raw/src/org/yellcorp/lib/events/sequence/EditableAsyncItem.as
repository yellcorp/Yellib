package org.yellcorp.lib.events.sequence
{
import flash.events.IEventDispatcher;


internal class EditableAsyncItem extends AsyncItem
{
    public function EditableAsyncItem()
    {
        super();
    }

    public function set target(target:IEventDispatcher):void
    {
        _target = target;
    }

    public function set startFunction(startFunction:Function):void
    {
        _startFunction = startFunction;
    }

    public function set startArgs(startArgs:Array):void
    {
        _startArgs = startArgs;
    }

    public function set continueEventName(continueEventName:String):void
    {
        _continueEventName = continueEventName;
    }

    public function set ifReturnsTrue(ifReturnsTrue:Function):void
    {
        _ifReturnsTrue = ifReturnsTrue;
    }

    public function set errorEventNames(errorEventNames:Array):void
    {
        _errorEventNames = errorEventNames;
    }
}
}
