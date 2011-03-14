package org.yellcorp.lib.layout.ast.nodes
{
import org.yellcorp.lib.error.AbstractCallError;


public class BinaryNode implements ASTNode
{
    protected var left:ASTNode;
    protected var right:ASTNode;

    public function BinaryNode(left:ASTNode, right:ASTNode)
    {
        this.left = left;
        this.right = right;
    }
    public function evaluate():Number
    {
        throw new AbstractCallError();
    }
    public function capture():void
    {
        propagateCapture();
    }
    public function optimize():ASTNode
    {
        throw new AbstractCallError();
    }
    public function toString():String
    {
        return "BinaryNode("+left.toString()+", "+right.toString()+")";
    }
    protected function propagateCapture():void
    {
        left.capture();
        right.capture();
    }
    protected function propagateOptimize():void
    {
        left = left.optimize();
        right = right.optimize();
    }
    protected function binOpToString(operator:String):String
    {
        return "(" + left.toString() + " " + operator +
               " " + right.toString() + ")";
    }
}
}
