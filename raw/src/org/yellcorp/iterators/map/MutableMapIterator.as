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
        // disallow changing the current key to one that exists

        // check like this instead of calling hasOwnProperty because
        // this class does iterate through all props on the prototype chain
        if (map[newKey] === undefined)
        {
            delete map[currentKey];
            map[newKey] = currentValue;
            currentKey = newKey;
            keys[index - 1] = newKey;
        }
        else
        {
            throw new KeyExistsError("Key already exists", newKey);
        }
    }

    public function set value(newValue:*):void
    {
        currentValue = map[currentKey] = newValue;
    }

    public function insert(key:*, value:*):void
    {
        if (map[key] === undefined)
        {
            map[key] = value;
            keys.splice(index, 0, key);
            next();
        }
        else
        {
            throw new KeyExistsError("Key already exists", key);
        }
    }
}
}
