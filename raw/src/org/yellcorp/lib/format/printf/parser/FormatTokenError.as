package org.yellcorp.lib.format.printf.parser
{
import org.yellcorp.lib.relexer.Token;


public class FormatTokenError extends Error
{
    private var _token:Token;

    public function FormatTokenError(message:String, token:Token)
    {
        super(message);
        _token = token;
        name = "FormatTokenError";
    }

    public function get token():Token
    {
        return _token;
    }
}
}
