package org.yellcorp.layout2.ast.factories
{
import org.yellcorp.layout2.LayoutProperty;
import org.yellcorp.layout2.adapters.BaseAdapter;


import org.yellcorp.layout2.ast.nodes.*;

public class NodeFactory
{
    private var axis:String;

    public function NodeFactory(axis:String)
    {
        this.axis = axis;
    }
    public function add(left:ASTNode, right:ASTNode):ASTNode
    {
        return new Add(left, right);
    }
    public function subtract(left:ASTNode, right:ASTNode):ASTNode
    {
        return new Subtract(left, right);
    }
    public function multiply(left:ASTNode, right:ASTNode):ASTNode
    {
        return new Multiply(left, right);
    }
    public function divide(left:ASTNode, right:ASTNode):ASTNode
    {
        return new Divide(left, right);
    }
    public function capture(node:ASTNode):ASTNode
    {
        return new Capture(node);
    }
    public function constant(value:Number):ASTNode
    {
        return new Constant(value);
    }
    public function getter(adapter:BaseAdapter, property:String):ASTNode
    {
        switch (property)
        {
            case LayoutProperty.MID :
                return add(
                    _getter(adapter, LayoutProperty.MIN),
                    multiply(
                        constant(.5),
                        _getter(adapter, LayoutProperty.SIZE)
                    )
                );
            case LayoutProperty.MAX :
                return add(
                    _getter(adapter, LayoutProperty.MIN),
                    _getter(adapter, LayoutProperty.SIZE)
                );
            default :
                return _getter(adapter, property);
        }
    }
    private function _getter(adapter:BaseAdapter, property:String):ASTNode
    {
        return new Getter(adapter.getAccessor(axis, property, false), property);
    }
    public function setter(adapter:BaseAdapter, property:String, value:ASTNode):ASTNode
    {
        return new Setter(adapter.getAccessor(axis, property, true), value, property);
    }
}
}