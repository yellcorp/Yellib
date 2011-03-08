package org.yellcorp.format.printf.parser
{
import org.yellcorp.format.printf.lexer.Token;


public class FormatTokenError extends Error
{
    private var _token:Token;

    public function FormatTokenError(message:String, token:Token)
    {
        super(message);
        _token = token;
    }

    public function get token():Token
    {
        return _token;
    }
}
}
