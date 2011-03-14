package org.yellcorp.lib.format.printf.options
{
public interface Flags
{
    function get width():Number;
    function get precision():Number;
    function get leftJustify():Boolean;
    function get alternateForm():Boolean;
    function get positivePlus():Boolean;
    function get positiveSpace():Boolean;
    function get zeroPad():Boolean;
    function get grouping():Boolean;
    function get negativeParens():Boolean;
    function get uppercase():Boolean;
}
}
