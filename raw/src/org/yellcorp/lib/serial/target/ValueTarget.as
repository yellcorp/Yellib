package org.yellcorp.lib.serial.target
{
public interface ValueTarget
{
    function getKeys():Array;
    function getValueType(key:*):String;
    function setValue(key:*, value:*):void;
}
}
