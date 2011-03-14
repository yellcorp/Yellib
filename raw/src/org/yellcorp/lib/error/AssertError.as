package org.yellcorp.lib.error
{
public class AssertError extends Error
{
    public function AssertError(message:* = "", id:* = 0)
    {
        super(message, id);
        name = "AssertError";
    }

    public static function assert(condition:Boolean, errorMessageIfFalse:String):Boolean
    {
        if (!condition)
        {
            throw new AssertError(errorMessageIfFalse);
        }
        return condition;
    }
}
}
