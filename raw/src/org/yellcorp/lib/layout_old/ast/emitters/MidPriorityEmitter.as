package org.yellcorp.lib.layout_old.ast.emitters
{
import org.yellcorp.lib.layout_old.LayoutProperty;
import org.yellcorp.lib.layout_old.adapters.BaseAdapter;
import org.yellcorp.lib.layout_old.ast.factories.NodeFactory;
import org.yellcorp.lib.layout_old.ast.nodes.ASTNode;


/**
 * @private
 */
public class MidPriorityEmitter extends BaseEmitter
{
    public function MidPriorityEmitter(target:BaseAdapter, evalNode:ASTNode)
    {
        super(target, evalNode);
    }
    public override function emit(f:NodeFactory, property2:String, evalNode2:ASTNode, out:Array):void
    {
        switch (property2)
        {
        case LayoutProperty.MIN :
            emitMinMid(f, evalNode2, evalNode, out);
            break;

        case LayoutProperty.MAX :
            emitMidMax(f, evalNode, evalNode2, out);
            break;

        case LayoutProperty.MID :
            redefineError(property2);
            break;

        case LayoutProperty.SIZE :
            emitMidSize(f, evalNode, evalNode2, out);
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
                    f.multiply(
                        f.constant(.5),
                        f.getter(target, LayoutProperty.SIZE)
                    )
                )
            )
        );
    }
}
}
