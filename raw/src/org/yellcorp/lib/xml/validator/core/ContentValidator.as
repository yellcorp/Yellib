package org.yellcorp.lib.xml.validator.core
{
public interface ContentValidator
{
    function onChildElement(node:XML):void;
    function onCloseElement():void;
    function onText(node:XML):void;
}
}
