package org.yellcorp.map
{
import flash.utils.Dictionary;


/**
 * A generic mapping of key values to ordered <code>Arrays</code>.
 * Implemented as a Dictionary, therefore keys can be of any type and
 * are matched using strict equality (===).
 *
 * @see flash.utils.Dictionary
 */
public class MultiMap
{
    private var dict:Dictionary;

    public function MultiMap()
    {
        clear();
    }

    /**
     * Clears all keys and values.
     */
    public function clear():void
    {
        dict = new Dictionary();
    }

    /**
     * Adds one or more values to the end of the array for a given key.
     * If <code>key</code> does not exist, it is created with an empty
     * array and the values are then added.
     *
     * @return The new length of the key's array.
     * @see Array#push()
     */
    public function push(key:*, ... values):uint
    {
        var list:Array = getList(key);
        if (!list)
        {
            list = setList(key, [ ]);
        }
        return list.push.apply(list, values);
    }

    /**
     * Removes the last value of an array for a given key and returns it.
     * If the key doesn't exist, returns <code>null</code>.  If the key
     * exists but has no values (an empty array), returns
     * <code>undefined</code>.
     *
     * @see Array#pop()
     */
    public function pop(key:*):*
    {
        return dict[key] ? getList(key).pop() : null;
    }

    /**
     * Inserts one or more values at the start of the array for a given key.
     * If <code>key</code> does not exist, it is created with an empty
     * array and the values are then added.
     *
     * @return The new length of the key's array.
     * @see Array#unshift()
     */
    public function unshift(key:*, ... values):uint
    {
        var list:Array = getList(key);
        if (!list)
        {
            list = setList(key, [ ]);
        }
        return list.unshift.apply(list, values);
    }

    /**
     * Removes the first value of an array for a given key and returns it.
     * If the key doesn't exist, returns <code>null</code>.  If the key
     * exists but has no values (an empty array), returns
     * <code>undefined</code>.
     *
     * @see Array#shift()
     */
    public function shift(key:*):*
    {
        return dict[key] ? getList(key).shift() : null;
    }

    /**
     * Tests for existence of a key.  Will return <code>true</code> if the
     * key exists, even if it points to an empty array.
     */
    public function hasList(key:*):Boolean
    {
        return dict[key] is Array;
    }

    /**
     * Returns the array for a given key, or <code>undefined</code> if the
     * key doesn't exist.  The returned array is not copied - therefore
     * changes made to the array will also be reflected in the
     * <code>MultiMap</code> instance it came from.
     */
    public function getList(key:*):Array
    {
        return dict[key] as Array;
    }

    /**
     * Returns the array for a given key, or a new empty array associated
     * with the key if it doesn't exist.  The returned array is not copied -
     * therefore changes made to the array will also be reflected in the
     * <code>MultiMap</code> instance it came from.  This applies even if
     * a new empty array was created.
     */
    public function getListNew(key:*):Array
    {
        var list:Array = dict[key] as Array;
        if (!list)
        {
            return setList(key, [ ]);
        }
        else
        {
            return list;
        }
    }

    /**
     * Sets the array for a given key.  If the key already exists, the
     * entire array is replaced and the old array is lost.
     *
     * @return The new array.
     */
    public function setList(key:*, newList:Array):Array
    {
        dict[key] = newList;
        return newList;
    }

    /**
     * Deletes the key and its associated array.
     *
     * @return <code>true</code> if the deletion succeded,
     *         <code>false</code> otherwise.
     */
    public function deleteList(key:*):Boolean
    {
        return delete dict[key];
    }

    /**
     * Returns an array of all keys in the <code>MultiMap</code>. This
     * includes keys that have empty arrays.  The order of the returned
     * keys is not defined.
     */
    public function getKeys():Array
    {
        var key:*;
        var keyList:Array;

        keyList = [ ];

        for (key in dict)
        {
            keyList.push(key);
        }

        return keyList;
    }
}
}
