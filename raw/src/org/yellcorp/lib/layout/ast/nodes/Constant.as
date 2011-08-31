package org.yellcorp.lib.layout.ast.nodes
{
/**
 * @private
 */
public class Constant implements ASTNode
{
    private var _value:Number;
    public function Constant(value:Number)
    {
        _value = value;
    }
    public function evaluate():Number
    {
        return _value;
    }
    public function capture():void
    {
    }
    public function optimize():ASTNode
    {
        return this;
    }
    public function toString():String
    {
        return _value.toString();
    }
}
}
