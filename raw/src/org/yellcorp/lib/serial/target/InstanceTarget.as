package org.yellcorp.lib.serial.target
{
import org.yellcorp.lib.serial.enum.Access;

import flash.utils.describeType;
import flash.utils.getQualifiedClassName;


public class InstanceTarget implements KeyValueTarget
{
    private var _instance:*;
    private var keys:Array;
    private var keyToType:Object;

    public function InstanceTarget(instance:*)
    {
        _instance = instance;
        keys = [ ];
        keyToType = { };
        buildIndex();
    }

    public function getType():String
    {
        return getQualifiedClassName(_instance);
    }

    public function getKeys():Array
    {
        return keys;
    }

    public function getValueType(key:*):String
    {
        return keyToType[key];
    }

    public function setValue(key:*, value:*):void
    {
        _instance[key] = value;
    }

    private function buildIndex():void
    {
        var type:XML = describeType(_instance);
        var setter:XML;

        for each (setter in type.variable)
        {
            indexVariable(setter);
        }
        for each (setter in type.accessor.(
            @access == Access.READ_WRITE || @access == Access.WRITE_ONLY))
        {
            indexVariable(setter);
        }
    }

    private function indexVariable(setter:XML):void
    {
        keys.push(String(setter.@name));
        keyToType[String(setter.@name)] = String(setter.@type);
    }
}
}
