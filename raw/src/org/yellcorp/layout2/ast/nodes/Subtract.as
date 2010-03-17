package org.yellcorp.layout2.ast.nodes
{

public class Subtract extends BinaryNode implements ASTNode
{
    public function Subtract(left:ASTNode, right:ASTNode)
    {
        super(left, right);
    }
    public override function evaluate():Number
    {
        return left.evaluate() - right.evaluate();
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
        else if (rightConst && right.evaluate() == 0)
        {
            return left;
        }
        return this;
    }
    public override function toString():String
    {
        return binOpToString("-");
    }
}
}