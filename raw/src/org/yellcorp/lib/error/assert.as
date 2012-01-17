package org.yellcorp.lib.error
{
public function assert(condition:Boolean, errorMessageIfFalse:String):Boolean
{
    if (!condition)
    {
        throw new AssertError(errorMessageIfFalse);
    }
    return condition;
}
}
