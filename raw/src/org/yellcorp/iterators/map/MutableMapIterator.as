package org.yellcorp.iterators.map
{
public class MutableMapIterator extends MapIterator
{
    public function remove():void
    {
        delete map[currentKey];
        keys.splice(index - 1, 1);
        currentKey = null;
        currentValue = null;
    }

    public function set key(newKey:*):void
    {
        // FIXME how to treat setting the current key to another
        // key that already exists?
        delete map[currentKey];
        map[newKey] = currentValue;
        currentKey = newKey;
        keys[index - 1] = newKey;
    }

    public function set value(newValue:*):void
    {
        currentValue = map[currentKey] = newValue;
    }
}
}
