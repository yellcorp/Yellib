package org.yellcorp.valid
{
import org.yellcorp.valid.ValueSource;


public class NullSource implements ValueSource
{
    public function getValue(key:String):*
    {
        return null;
    }
}
}
