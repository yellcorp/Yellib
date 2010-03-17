package org.yellcorp.layout2.ast.nodes
{
public class Getter implements ASTNode
{
    private var getFunc:Function;
    private var debugName:String;

    public function Getter(getFunc:Function, debugName:String = "unknown")
    {
        this.getFunc = getFunc;
        this.debugName = debugName;
    }
    public function evaluate():Number
    {
        return getFunc();
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
        return "object." + debugName;
    }
}
}
