package org.yellcorp.lib.layout.ast.emitters
{
import org.yellcorp.lib.layout.LayoutProperty;
import org.yellcorp.lib.layout.adapters.BaseAdapter;
import org.yellcorp.lib.layout.ast.factories.NodeFactory;
import org.yellcorp.lib.layout.ast.nodes.ASTNode;


/**
 * @private
 */
public class MaxPriorityEmitter extends BaseEmitter
{
    public function MaxPriorityEmitter(target:BaseAdapter, evalNode:ASTNode)
    {
        super(target, evalNode);
    }
    public override function emit(f:NodeFactory, property2:String, evalNode2:ASTNode, out:Array):void
    {
        switch (property2)
        {
        case LayoutProperty.MIN :
            emitMinMax(f, evalNode2, evalNode, out);
            break;

        case LayoutProperty.MAX :
            redefineError(property2);
            break;

        case LayoutProperty.MID :
            emitMidMax(f, evalNode2, evalNode, out);
            break;

        case LayoutProperty.SIZE :
            emitMaxSize(f, evalNode, evalNode2, out);
            break;

        default :
            propertyError(property2);
            break;
        }
    }
    public override function emitSingle(f:NodeFactory, out:Array):void
    {
        out.push(
            f.setter(target, LayoutProperty.MIN,
                f.subtract(
                    evalNode,
                    f.getter(target, LayoutProperty.SIZE)
                )
            )
        );
    }
}
}
