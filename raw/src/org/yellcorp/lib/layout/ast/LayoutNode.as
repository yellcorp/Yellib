package org.yellcorp.lib.layout.ast
{
import org.yellcorp.lib.error.AbstractCallError;
public class LayoutNode
{
    public var children:Vector.<LayoutNode>;
    
    public function LayoutNode()
    {
        children = new Vector.<LayoutNode>();
    }
    
    public function clone():LayoutNode
    {
        var c:LayoutNode = new LayoutNode();
        for each (var child:LayoutNode in children)
        {
            c.children.push(child.clone());
        }
        return c;
    }
    
    public function eval():*
    {
        throw new AbstractCallError();
    }
}
}
