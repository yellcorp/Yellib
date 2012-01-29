package org.yellcorp.lib.layout.nodefac
{
import org.yellcorp.lib.layout.ast.LayoutNode;


public interface NodeFactory
{
    function measure(targetObject:Object, targetProperty:String, relativeObject:Object, relativeProperty:String):LayoutNode;
    function apply(registerIndex:uint, relativeObject:Object, relativeProperty:String):LayoutNode;
}
}
