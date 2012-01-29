package org.yellcorp.lib.layout_old.ast.nodes
{
/**
 * @private
 */
public class Add extends BinaryNode implements ASTNode
{
    public function Add(left:ASTNode, right:ASTNode)
    {
        super(left, right);
    }
    public override function evaluate():Number
    {
        return left.evaluate() + right.evaluate();
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
            return right;
        }
        else if (rightConst && right.evaluate() == 0)
        {
            return left;
        }
        return this;
    }
    public override function toString():String
    {
        return binOpToString("+");
    }
}
}
