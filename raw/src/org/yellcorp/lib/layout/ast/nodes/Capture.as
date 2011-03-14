package org.yellcorp.lib.layout.ast.nodes
{
public class Capture implements ASTNode
{
    private var node:ASTNode;
    private var _captured:Boolean;
    private var _capturedValue:Number;

    public function Capture(newNode:ASTNode)
    {
        node = newNode;
    }
    public function evaluate():Number
    {
        if (!_captured)
        {
            capture();
        }
        return _capturedValue;
    }
    public function capture():void
    {
        node.capture();
        _capturedValue = node.evaluate();
        _captured = true;
    }
    public function optimize():ASTNode
    {
        return new Constant(evaluate());
    }
    public function toString():String
    {
        return "capture(" + node.toString() + ")";
    }
}
}
