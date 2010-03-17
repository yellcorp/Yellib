package wip.yellcorp.layout2.ast.emitters
{
import wip.yellcorp.layout2.LayoutProperty;
import wip.yellcorp.layout2.adapters.BaseAdapter;
import wip.yellcorp.layout2.ast.factories.NodeFactory;
import wip.yellcorp.layout2.ast.nodes.ASTNode;


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
        emitMidSize(f, evalNode, f.getter(target, LayoutProperty.SIZE), out);
    }
}
}
