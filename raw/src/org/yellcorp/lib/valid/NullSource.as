package org.yellcorp.lib.valid
{
public class NullSource implements ValueSource
{
    public function getValue(key:String):*
    {
        return null;
    }
}
}
