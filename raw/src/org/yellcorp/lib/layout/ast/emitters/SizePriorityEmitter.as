package org.yellcorp.lib.layout.ast.emitters
{
import org.yellcorp.lib.layout.LayoutProperty;
import org.yellcorp.lib.layout.adapters.BaseAdapter;
import org.yellcorp.lib.layout.ast.factories.NodeFactory;
import org.yellcorp.lib.layout.ast.nodes.ASTNode;


public class SizePriorityEmitter extends BaseEmitter
{
    public function SizePriorityEmitter(target:BaseAdapter, evalNode:ASTNode)
    {
        super(target, evalNode);
    }
    public override function emit(f:NodeFactory, property2:String, evalNode2:ASTNode, out:Array):void
    {
        switch (property2)
        {
        case LayoutProperty.MIN :
            emitMinSize(f, evalNode2, evalNode, out);
            break;
        case LayoutProperty.MAX :
            emitMaxSize(f, evalNode2, evalNode, out);
            break;
        case LayoutProperty.MID :
            emitMidSize(f, evalNode2, evalNode, out);
            break;
        case LayoutProperty.SIZE :
            redefineError(property2);
            break;
        default :
            propertyError(property2);
            break;
        }
    }
    public override function emitSingle(f:NodeFactory, out:Array):void
    {
        out.push(
            f.setter(target, LayoutProperty.SIZE, evalNode)
        );
    }
}
}
