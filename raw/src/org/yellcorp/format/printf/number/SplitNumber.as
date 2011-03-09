package org.yellcorp.format.printf.number
{
public interface SplitNumber
{
    function get isNotANumber():Boolean;
    function get isFiniteNumber():Boolean;
    function get leadSign():String;
    function get basePrefix():String;
    function get integerPart():String;
    function get groupingCharacter():String;
    function get groupingSize():int;
    function get integerWidth():Number;
    function get forceRadixPoint():Boolean;
    function get fractionalPart():String;
    function get fractionalWidth():Number;
    function get exponentDelimiter():String;
    function get exponentLeadSign():String;
    function get exponent():String;
    function get exponentTrailSign():String;
    function get exponentWidth():Number;
    function get trailSign():String;
    function get minWidth():uint;
    function get paddingCharacter():String;
    function get leftJustify():Boolean;
    function get base():uint;
    function get uppercase():Boolean;
}
}
