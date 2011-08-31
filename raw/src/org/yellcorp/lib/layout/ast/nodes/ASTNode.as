package org.yellcorp.lib.layout.ast.nodes
{
/**
 * @private
 */
public interface ASTNode
{
    function evaluate():Number;
    function capture():void;
    function optimize():ASTNode;
    function toString():String;
}
}
