package org.yellcorp.format.c4.parser
{
import org.yellcorp.format.c4.errors.ValueExistsError;
import org.yellcorp.format.c4.lexer.Token;


public class Property
{
    public var defaultValue:*;

    private var _value:*;
    private var _token:Token;
    private var _isSet:Boolean;

    public function Property(defaultValue:* = undefined)
    {
        this.defaultValue = defaultValue;
    }

    public function clear():void
    {
        _value = undefined;
        _token = null;
        _isSet = false;
    }

    public function setValue(value:*, token:Token):void
    {
        if (_isSet)
        {
            throw new ValueExistsError("Property already set", _value, _token, value, token);
        }
        else
        {
            _value = value;
            _token = token;
            _isSet = true;
        }
    }

    public function get value():*
    {
        return _isSet ? _value : defaultValue;
    }

    public function get token():Token
    {
        return _token;
    }

    public function get isSet():Boolean
    {
        return _isSet;
    }
}
}
