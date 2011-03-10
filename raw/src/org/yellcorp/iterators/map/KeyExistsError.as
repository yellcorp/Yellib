package org.yellcorp.iterators.map
{
public class KeyExistsError extends ArgumentError
{
    private var _existingKey:*;

    public function KeyExistsError(message:String, existingKey:*)
    {
        name = "KeyExistsError";
        _existingKey = existingKey;
        super(message);
    }

    public function get existingKey():*
    {
        return _existingKey;
    }
}
}
