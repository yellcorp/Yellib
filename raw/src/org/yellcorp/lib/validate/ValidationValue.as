package org.yellcorp.lib.validate
{
public class ValidationValue
{
    private var _controlValue:*;
    private var _accepted:Boolean;
    private var _modified:Boolean;
    private var _message:String;
    private var _name:String;

    public function ValidationValue(controlValue:*, name:String)
    {
        _controlValue = controlValue;
        _name = name;
        _accepted = true;
        _modified = false;
        _message = "";
    }

    public function reject(message:String):void
    {
        _accepted = false;
        _message = message.replace("{name}", _name);
    }

    public function get accepted():Boolean
    {
        return _accepted;
    }

    public function get controlValue():*
    {
        return _controlValue;
    }

    public function set controlValue(new_controlValue:*):void
    {
        _modified = true;
        _controlValue = new_controlValue;
    }

    public function get modified():Boolean
    {
        return _modified;
    }

    public function get message():String
    {
        return _message;
    }

    public function get name():String
    {
        return _name;
    }
}
}
