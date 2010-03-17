package org.yellcorp.layout2.ast.nodes
{

public class Divide extends BinaryNode implements ASTNode
{
    public function Divide(left:ASTNode, right:ASTNode)
    {
        super(left, right);
    }
    public override function evaluate():Number
    {
        return left.evaluate() / right.evaluate();
    }
    public override function optimize():ASTNode
    {
        propagateOptimize();

        var leftConst:Boolean = left is Constant;
        var rightConst:Boolean = right is Constant;

        if (leftConst && rightConst)
        {
            return new Constant(evaluate());
        }
        else if (leftConst && left.evaluate() == 0)
        {
            return new Constant(0);
        }
        else if (rightConst && right.evaluate() == 1)
        {
            return left;
        }
        return this;
    }
    public override function toString():String
    {
        return binOpToString("/");
    }
}
}
