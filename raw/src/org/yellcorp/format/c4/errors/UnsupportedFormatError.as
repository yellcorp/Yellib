package org.yellcorp.format.c4.errors
{
import org.yellcorp.format.c4.lexer.Token;


public class UnsupportedFormatError extends FormatTokenError
{
    private var _specifierName:String;

    public function UnsupportedFormatError(message:String, token:Token, specifierName:String)
    {
        super(message, token);
        _specifierName = specifierName;
    }

    public function get specifierName():String
    {
        return _specifierName;
    }
}
}
