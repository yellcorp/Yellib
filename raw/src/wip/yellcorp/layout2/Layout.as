package wip.yellcorp.layout2
{
import org.yellcorp.iterators.readonly.ArrayIterator;

import wip.yellcorp.layout2.adapters.BaseAdapter;


import wip.yellcorp.layout2.ast.emitters.*;
import wip.yellcorp.layout2.ast.factories.AdapterFactory;
import wip.yellcorp.layout2.ast.factories.NodeFactory;
import wip.yellcorp.layout2.ast.nodes.ASTNode;

import flash.utils.Dictionary;


public class Layout
{
    private var emitters:Object;
    private var maxedTargets:Object;
    private var layoutForest:Array;
    private var nodeIterator:ArrayIterator;
    private var _captured:Boolean;

    public function Layout()
    {
        clear();
    }

    public function clear():void
    {
        emitters = { };
        emitters[LayoutAxis.X] = new Dictionary();
        emitters[LayoutAxis.Y] = new Dictionary();

        maxedTargets = { };
        maxedTargets[LayoutAxis.X] = new Dictionary();
        maxedTargets[LayoutAxis.Y] = new Dictionary();

        layoutForest = [ ];
        nodeIterator = new ArrayIterator(layoutForest);

        _captured = false;
    }

    public function addConstraint(axis:String,
                                  targetObject:Object, targetProp:String,
                                  sourceObject:Object, sourceProp:String,
                                  type:String):void
    {
        var adapter:AdapterFactory = new AdapterFactory();
        var f:NodeFactory = new NodeFactory(axis);

        var captureNode:ASTNode;
        var evalNode:ASTNode;

        var axisMaxedTargets:Dictionary = maxedTargets[axis];
        var axisEmitters:Dictionary = emitters[axis];

        var target:BaseAdapter;
        var source:BaseAdapter;

        var emitter:BaseEmitter;

        if (axisMaxedTargets[targetObject])
        {
            throw new ArgumentError("Target cannot support any more constraints in the " + axis + "axis");
        }

        target = adapter.wrap(targetObject);
        source = adapter.wrap(sourceObject);

        switch (type)
        {
            case ConstraintType.OFFSET :
            {
                captureNode =
                f.capture(
                    f.subtract(
                        f.getter(target, targetProp),
                        f.getter(source, sourceProp)
                    )
                );

                evalNode =
                f.add(
                    f.getter(source, sourceProp),
                    captureNode
                );
                break;
            }
            default :
            {
                captureNode =
                f.capture(
                    f.divide(
                        f.getter(target, targetProp),
                        f.getter(source, sourceProp)
                    )
                );

                evalNode =
                f.multiply(
                    f.getter(source, sourceProp),
                    captureNode
                );
                break;
            }
        }

        emitter = axisEmitters[targetObject];
        if (emitter)
        {
            emitter.emit(f, targetProp, evalNode, layoutForest);
            axisMaxedTargets[targetObject] = true;
            delete axisEmitters[targetObject];
        }
        else
        {
            switch (targetProp)
            {
                case LayoutProperty.MIN :
                    emitter = new MinPriorityEmitter(target, evalNode);
                    break;
                case LayoutProperty.MID :
                    emitter = new MidPriorityEmitter(target, evalNode);
                    break;
                case LayoutProperty.MAX :
                    emitter = new MaxPriorityEmitter(target, evalNode);
                    break;
                case LayoutProperty.SIZE :
                    emitter = new SizePriorityEmitter(target, evalNode);
                    break;
            }
            axisEmitters[targetObject] = emitter;
        }
    }

    public function evaluate():void
    {
        if (!_captured) capture();
        for (nodeIterator.reset(); nodeIterator.valid; nodeIterator.next())
        {
            ASTNode(nodeIterator.current).evaluate();
        }
    }

    public function capture():void
    {
        flush();
        for (nodeIterator.reset(); nodeIterator.valid; nodeIterator.next())
        {
            ASTNode(nodeIterator.current).capture();
        }
        _captured = true;
    }

    public function optimize():void
    {
        flush();
        for (nodeIterator.reset(); nodeIterator.valid; nodeIterator.next())
        {
            ASTNode(nodeIterator.current).optimize();
        }
        _captured = true;
    }

    public function get captured():Boolean
    {
        return _captured;
    }

    private function flush():void
    {
        var axis:String;
        var emitter:BaseEmitter;
        var f:NodeFactory;

        for (axis in emitters)
        {
            f = new NodeFactory(axis);
            for each (emitter in emitters[axis])
            {
                emitter.emitSingle(f, layoutForest);
            }
        }
    }
}
}
