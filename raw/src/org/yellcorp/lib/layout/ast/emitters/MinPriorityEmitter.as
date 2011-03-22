package org.yellcorp.lib.layout.ast.emitters
{
import org.yellcorp.lib.layout.LayoutProperty;
import org.yellcorp.lib.layout.adapters.BaseAdapter;
import org.yellcorp.lib.layout.ast.factories.NodeFactory;
import org.yellcorp.lib.layout.ast.nodes.ASTNode;


public class MinPriorityEmitter extends BaseEmitter
{
    public function MinPriorityEmitter(target:BaseAdapter, evalNode:ASTNode)
    {
        super(target, evalNode);
    }
    public override function emit(f:NodeFactory, property2:String, evalNode2:ASTNode, out:Array):void
    {
        switch (property2)
        {
            case LayoutProperty.MIN :
                redefineError(property2);
                break;
            case LayoutProperty.MAX :
                emitMinMax(f, evalNode, evalNode2, out);
                break;
            case LayoutProperty.MID :
                emitMinMid(f, evalNode, evalNode2, out);
                break;
            case LayoutProperty.SIZE :
                emitMinSize(f, evalNode, evalNode2, out);
                break;
            default :
                propertyError(property2);
                break;
        }
    }
    public override function emitSingle(f:NodeFactory, out:Array):void
    {
        out.push(
            f.setter(target, LayoutProperty.MIN, evalNode)
        );
    }
}
}