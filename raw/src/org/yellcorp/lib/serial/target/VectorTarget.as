package org.yellcorp.lib.serial.target
{
public class VectorTarget implements KeyValueTarget
{
    private var _vector:*;
    private var keys:Array;
    private var valueType:String;

    public function VectorTarget(vector:*, length:int, valueType:String)
    {
        _vector = vector;
        keys = [ ];
        for (var i:int = 0; i < length; i++)
        {
            keys.push(i);
        }
        this.valueType = valueType;
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
        _vector[key] = value;
    }
}
}
