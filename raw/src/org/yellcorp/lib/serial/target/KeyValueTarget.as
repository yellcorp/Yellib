package org.yellcorp.lib.serial.target
{
public interface KeyValueTarget
{
    function getKeys():Array;
    function getValueType(key:*):String;
    function setValue(key:*, value:*):void;
}
}
