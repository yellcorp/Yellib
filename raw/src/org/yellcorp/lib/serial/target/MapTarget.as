package org.yellcorp.lib.serial.target
{
import flash.utils.getQualifiedClassName;


public class MapTarget implements KeyValueTarget
{
    private var _map:*;
    private var keys:Array;
    private var valueType:String;

    public function MapTarget(map:*, keys:Array, valueType:String)
    {
        _map = map;
        this.keys = keys;
        this.valueType = valueType;
    }

    public function getType():String
    {
        return getQualifiedClassName(_map);
    }

    public function getKeys():Array
    {
        return keys;
    }

    public function getValueType(key:*):String
    {
        return valueType;
    }

    public function setValue(key:*, value:*):void
    {
        _map[key] = value;
    }
}
}
