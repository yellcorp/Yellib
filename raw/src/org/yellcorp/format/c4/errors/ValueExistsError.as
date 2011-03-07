package org.yellcorp.format.c4.errors
{
import org.yellcorp.format.c4.lexer.Token;


public class ValueExistsError extends FormatTokenError
{
    private var _value:*;
    private var _newValue:*;
    private var _newToken:Token;

    public function ValueExistsError(message:String, value:*, token:Token, newValue:*, newToken:Token)
    {
        super(message, token);
        _value = value;
        _newValue = newValue;
        _newToken = newToken;
    }

    public function get value():*
    {
        return _value;
    }

    public function get newValue():*
    {
        return _newValue;
    }

    public function get newToken():Token
    {
        return _newToken;
    }
}
}
