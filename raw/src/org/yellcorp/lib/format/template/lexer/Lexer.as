package org.yellcorp.lib.format.template.lexer
{
/**
 * @private
 */
public interface Lexer
{
    function start(string:String):void;
    function nextToken():Token;
    function get inputString():String;
    function get currentChar():int;
}
}
