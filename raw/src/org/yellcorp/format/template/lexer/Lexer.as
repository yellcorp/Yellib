package org.yellcorp.format.template.lexer
{
public interface Lexer
{
    function start(string:String):void;
    function nextToken():Token;
    function get inputString():String;
    function get currentChar():int;
}
}
