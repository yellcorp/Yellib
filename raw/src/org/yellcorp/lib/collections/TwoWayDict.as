package org.yellcorp.lib.collections
{
import org.yellcorp.lib.core.MapUtil;

import flash.utils.Dictionary;


/**
 * An object that stores mutual relationships between keys and values.
 * Values can be set and retrieved by key, and vice versa.  Note that
 * in addition to the usual requirement that keys are unique, all values
 * must be unique too.
 */
public class TwoWayDict
{
    private var keyToVal:Dictionary;
    private var valToKey:Dictionary;

    public function TwoWayDict()
    {
        clear();
    }

    public function clear():void
    {
        keyToVal = new Dictionary();
        valToKey = new Dictionary();
    }

    public function hasValue(value:*):Boolean
    {
        return valToKey.hasOwnProperty(value);
    }

    public function hasKey(key:*):Boolean
    {
        return keyToVal.hasOwnProperty(key);
    }

    public function getValue(key:*):*
    {
        return keyToVal[key];
    }

    public function getKey(value:*):*
    {
        return valToKey[value];
    }

    public function removeByValue(value:*):void
    {
        if (hasValue(value)) removePair(getKey(value), value);
    }

    public function removeByKey(key:*):void
    {
        if (hasKey(key)) removePair(key, getValue(key));
    }

    public function setPair(key:*, value:*):void
    {
        removePair(key, value);

        keyToVal[key] = value;
        valToKey[value] = key;
    }

    public function getAllValues():Array
    {
        return MapUtil.getKeys(keyToVal);
    }

    public function getAllKeys():Array
    {
        return MapUtil.getValues(keyToVal);
    }

    public function toDictionary():Dictionary
    {
        var newDict:Dictionary = new Dictionary();
        MapUtil.merge(keyToVal, newDict);
        return newDict;
    }

    public function isPair(key:*, value:*):Boolean
    {
        return (key != null) && (value != null) &&
               (keyToVal[key] = value) &&
               (valToKey[value] = key);
    }

    private function removePair(key:*, value:*):void
    {
        delete keyToVal[key];
        delete valToKey[value];
    }
}
}
