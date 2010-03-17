package org.yellcorp.layout2.ast.emitters
{
import org.yellcorp.error.AbstractCallError;
import org.yellcorp.layout2.LayoutProperty;
import org.yellcorp.layout2.adapters.BaseAdapter;
import org.yellcorp.layout2.ast.errors.PropertyError;
import org.yellcorp.layout2.ast.errors.RedefineError;
import org.yellcorp.layout2.ast.factories.NodeFactory;
import org.yellcorp.layout2.ast.nodes.ASTNode;


public class BaseEmitter
{
    protected var target:BaseAdapter;
    protected var evalNode:ASTNode;

    public function BaseEmitter(target:BaseAdapter, evalNode:ASTNode)
    {
        this.target = target;
        this.evalNode = evalNode;
    }
    public function emit(f:NodeFactory, property2:String, evalNode2:ASTNode, out:Array):void
    {
        throw new AbstractCallError();
    }
    public function emitSingle(f:NodeFactory, out:Array):void
    {
        throw new AbstractCallError();
    }
    protected function redefineError(property:String):void
    {
        throw new RedefineError(target, property);
    }
    protected function propertyError(property:String):void
    {
        throw new PropertyError(property);
    }

    protected function emitMinMax(f:NodeFactory, minNode:ASTNode, maxNode:ASTNode, out:Array):void
    {
        out.push(
            f.setter(target, LayoutProperty.MIN, minNode),
            f.setter(target, LayoutProperty.SIZE,
                f.subtract(maxNode, minNode)
            )
        );
    }

    protected function emitMinMid(f:NodeFactory, minNode:ASTNode, midNode:ASTNode, out:Array):void
    {
        out.push(
            f.setter(target, LayoutProperty.MIN, minNode),
            f.setter(target, LayoutProperty.SIZE,
                f.multiply(
                    f.constant(2),
                    f.subtract(midNode, minNode)
                )
            )
        );
    }

    protected function emitMinSize(f:NodeFactory, minNode:ASTNode, sizeNode:ASTNode, out:Array):void
    {
        out.push(
            f.setter(target, LayoutProperty.MIN, minNode),
            f.setter(target, LayoutProperty.SIZE, sizeNode)
        );
    }

    protected function emitMidSize(f:NodeFactory, midNode:ASTNode, sizeNode:ASTNode, out:Array):void
    {
        out.push(
            f.setter(target, LayoutProperty.MIN,
                f.subtract(
                    midNode,
                    f.multiply(
                        f.constant(.5),
                        sizeNode
                    )
                )
            ),
            f.setter(target, LayoutProperty.SIZE, sizeNode)
        );
    }

    protected function emitMidMax(f:NodeFactory, midNode:ASTNode, maxNode:ASTNode, out:Array):void
    {
        var sizeNode:ASTNode = f.multiply(
            f.constant(2),
            f.subtract(maxNode, midNode)
        );

        out.push(
            f.setter(target, LayoutProperty.MIN,
                f.subtract(maxNode, sizeNode)
            ),
            f.setter(target, LayoutProperty.SIZE, sizeNode)
        );
    }

    protected function emitMaxSize(f:NodeFactory, maxNode:ASTNode, sizeNode:ASTNode, out:Array):void
    {
        out.push(
            f.setter(target, LayoutProperty.MIN,
                f.subtract(maxNode, sizeNode)
            ),
            f.setter(target, LayoutProperty.SIZE, sizeNode)
        );
    }
}
}
