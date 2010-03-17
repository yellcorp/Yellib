package wip.yellcorp.layout2.ast.nodes
{
public interface ASTNode
{
    function evaluate():Number;
    function capture():void;
    function optimize():ASTNode;
    function toString():String;
}
}
