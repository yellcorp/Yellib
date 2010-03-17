package org.yellcorp.layout2.ast.nodes
{

public class Multiply extends BinaryNode implements ASTNode
{
    public function Multiply(left:ASTNode, right:ASTNode)
    {
        super(left, right);
    }
    public override function evaluate():Number
    {
        return left.evaluate() * right.evaluate();
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
        else if (leftConst)
        {
            switch (left.evaluate())
            {
                case 0: return new Constant(0);
                case 1: return right;
            }
        }
        else if (rightConst)
        {
            switch (right.evaluate())
            {
                case 0: return new Constant(0);
                case 1: return left;
            }
        }
        return this;
    }
    public override function toString():String
    {
        return binOpToString("*");
    }
}
}
