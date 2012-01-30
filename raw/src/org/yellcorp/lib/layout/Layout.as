package org.yellcorp.lib.layout
{
import org.yellcorp.lib.layout.properties.*;

import flash.utils.Dictionary;


public class Layout
{
    private static var _propToAxis:Object;
    private static var _propToVirtualProp:Object;

    private var propertyConstraints:Dictionary;

    private var xAxis:SingleAxisLayout;
    private var yAxis:SingleAxisLayout;

    private var rounding:Boolean;
    private var propertyAdapter:PropertyAdapter;

    public function Layout(rounding:Boolean = false, propertyAdapter:PropertyAdapter = null)
    {
        this.rounding = rounding;
        this.propertyAdapter = propertyAdapter || new DefaultPropertyAdapter();
        clear();
    }

    public function clear():void
    {
        propertyConstraints = new Dictionary(true);
        xAxis = new SingleAxisLayout(X, rounding, propertyAdapter);
        yAxis = new SingleAxisLayout(Y, rounding, propertyAdapter);
    }

    public function constrain(
            target:Object, targetProperty:String,
            relative:Object, relativeProperty:String,
            constraintType:String):void
    {
        var axis:String = getAxis(targetProperty);
        var relativeAxis:String = getAxis(relativeProperty);

        if (isPropertyConstrained(target, targetProperty))
        {
            throw new ArgumentError("Target's " + targetProperty + " property is already constrained");
        }
        else if (axis != relativeAxis)
        {
            throw new ArgumentError("Can't constrain properties on different axes");
        }

        var targetVirtualProp:uint = getVirtualProperty(targetProperty);
        var relativeVirtualProp:uint = getVirtualProperty(relativeProperty);

        getAxisLayout(axis).constrain(target, targetVirtualProp, relative, relativeVirtualProp, constraintType);

        setPropertyConstrained(target, targetProperty);
    }

    public function isPropertyConstrained(target:Object, property:String):Boolean
    {
        var targetSet:Object = propertyConstraints[target];
        return targetSet && targetSet[property];
    }

    public function canConstrain(target:Object, property:String):Boolean
    {
        var axis:String = getAxis(property);
        return getAxisLayout(axis).canConstrain(target);
    }

    public function measure():void
    {
        xAxis.measure();
        yAxis.measure();
    }

    public function update():void
    {
        xAxis.update();
        yAxis.update();
    }

    public function optimize():void
    {
        xAxis.optimize();
        yAxis.optimize();
    }

    private function setPropertyConstrained(target:Object, property:String):void
    {
        var targetSet:Object = propertyConstraints[target];
        if (!targetSet)
        {
            targetSet = propertyConstraints[target] = { };
        }
        targetSet[property] = true;
    }

    private function getAxisLayout(axis:String):SingleAxisLayout
    {
        return axis == X ? xAxis : yAxis;
    }

    private static function getAxis(property:String):String
    {
        if (!_propToAxis)
        {
            var p:Object = _propToAxis = { };
            p[X] =
            p[LEFT] =
            p[HCENTER] =
            p[RIGHT] =
            p[WIDTH] = X;

            p[Y] =
            p[TOP] =
            p[VCENTER] =
            p[BOTTOM] =
            p[HEIGHT] = Y;
        }

        var axis:String = _propToAxis[property];
        if (!axis) throw new ArgumentError("Not a valid property: " + property);

        return axis;
    }

    private static function getVirtualProperty(property:String):uint
    {
        if (!_propToVirtualProp)
        {
            var p:Object = _propToVirtualProp = { };
            p[X] =
            p[LEFT] =
            p[Y] =
            p[TOP] = MIN;

            p[HCENTER] =
            p[VCENTER] = MID;

            p[RIGHT] =
            p[BOTTOM] = MAX;

            p[WIDTH] =
            p[HEIGHT] = SPAN;
        }
        return _propToVirtualProp[property];
    }
}
}



import org.yellcorp.lib.error.AbstractCallError;
import org.yellcorp.lib.error.assert;
import org.yellcorp.lib.layout.ConstraintType;
import org.yellcorp.lib.layout.PropertyAdapter;

import flash.utils.Dictionary;


const NONE:int = 0;
const MIN:int = 1;
const MID:int = 2;
const MAX:int = 4;
const SPAN:int = 8;

const MIN_MID:int =  MIN | MID;
const MIN_MAX:int =  MIN | MAX;
const MIN_SPAN:int = MIN | SPAN;

const MID_MAX:int =  MID | MAX;
const MID_SPAN:int = MID | SPAN;

const MAX_SPAN:int = MAX | SPAN;

const axisToSpan:Object = {
    x: "width",
    y: "height"
};


class SingleAxisLayout
{
    private var _axis:String;
    private var span:String;

    private var rounding:Boolean;
    private var propertyAdapter:PropertyAdapter;

    private var virtualGetResolver:VirtualGetResolver;
    private var propertyTransformer:PropertyTransformer;

    private var constrainCount:Dictionary;

    private var regs:Registers;

    private var virtualMeasureProgram:Vector.<ASTNode>;
    private var measureProgram:Vector.<ASTNode>;

    private var virtualSettersByTarget:Dictionary;
    private var virtualUpdateProgram:Vector.<SetVirtualProps>;
    private var updateProgram:Vector.<ASTNode>;

    private var measuredUpdateProgram:Vector.<ASTNode>;

    private var _nodeFactories:Object;

    public function SingleAxisLayout(axis:String, rounding:Boolean, propertyAdapter:PropertyAdapter)
    {
        _axis = axis;
        span = axisToSpan[_axis];

        this.rounding = rounding;
        this.propertyAdapter = propertyAdapter;

        virtualGetResolver = new VirtualGetResolver(_axis);
        propertyTransformer = new PropertyTransformer(propertyAdapter);

        constrainCount = new Dictionary(true);
        regs = new Registers();

        virtualMeasureProgram = new Vector.<ASTNode>();
        measureProgram = null;

        virtualSettersByTarget = new Dictionary();
        virtualUpdateProgram = new Vector.<SetVirtualProps>();
        updateProgram = null;
        measuredUpdateProgram = null;
    }

    public function get axis():String
    {
        return _axis;
    }

    public function constrain(
            target:Object, targetVirtualProp:uint,
            relative:Object, relativeVirtualProp:uint,
            constraintType:String):void
    {
        if (!canConstrain(target))
        {
            throw new ArgumentError("Target cannot accept any more constraints in the " + _axis + " axis");
        }

        var nodeFactory:NodeFactory = getNodeFactory(constraintType);

        var regIndex:uint = regs.nextFreeIndex();
        var measureNode:ASTNode = nodeFactory.measure(target, targetVirtualProp, relative, relativeVirtualProp);
        var storeNode:ASTNode = new SetVector(regs.regv, regIndex, measureNode);
        var calculateNode:ASTNode = nodeFactory.calculate(regIndex, relative, relativeVirtualProp);

        virtualMeasureProgram.push(storeNode);
        measureProgram = null;

        var existingSetter:SetVirtualProps = virtualSettersByTarget[target];

        if (existingSetter)
        {
            existingSetter.vprop1 = targetVirtualProp;
            existingSetter.child1 = calculateNode;
            delete virtualSettersByTarget[target];
        }
        else
        {
            virtualSettersByTarget[target] = existingSetter =
                new SetVirtualProps(target, targetVirtualProp, calculateNode);
            virtualUpdateProgram.push(existingSetter);
        }
        incrementConstraint(target);
    }

    public function canConstrain(target:Object):Boolean
    {
        var count:int = constrainCount[target];
        return count < 2;
    }

    public function measure():void
    {
        if (!measureProgram) compileMeasureProgram();
        run(measureProgram);
        measuredUpdateProgram = null;
    }

    public function update():void
    {
        if (!measureProgram) measure();
        if (!updateProgram) compileUpdateProgram();
        run(measuredUpdateProgram || updateProgram);
    }

    public function optimize():void
    {
        if (!measureProgram) measure();
        if (!updateProgram) compileUpdateProgram();
        measuredUpdateProgram = filterProgramCopy(updateProgram, new ReadOnlyEvaluator());
        filterProgramInPlace(measuredUpdateProgram, new ArithmeticConstFolder());
        filterProgramInPlace(measuredUpdateProgram, new ArithmeticOptimizer());
    }

    private function compileMeasureProgram():void
    {
        measureProgram = filterProgramCopy(virtualMeasureProgram, virtualGetResolver);
    }

    private function compileUpdateProgram():void
    {
        resolveVirtualSetters();
        filterProgramInPlace(updateProgram, virtualGetResolver);
        filterProgramInPlace(updateProgram, new Max0SpanSetters());
        if (rounding)
        {
            filterProgramInPlace(updateProgram, new RoundSetters());
        }
        filterProgramInPlace(updateProgram, propertyTransformer);
    }

    private function resolveVirtualSetters():void
    {
        var vset:SetVirtualProps;
        updateProgram = new Vector.<ASTNode>();
        for each (vset in virtualUpdateProgram)
        {
            resolveVirtualSetter(vset);
        }
    }

    private function resolveVirtualSetter(vset:SetVirtualProps):void
    {
        var properties:int = vset.vprop0 | vset.vprop1;
        var target:Object = vset.object;

        var a:ASTNode;
        var b:ASTNode;

        if (vset.vprop1 > 0 && vset.vprop0 > vset.vprop1)
        {
            a = vset.child1;
            b = vset.child0;
        }
        else
        {
            a = vset.child0;
            b = vset.child1;
        }

        switch (properties)
        {
        case MIN:
            // target.axis = a
            updateProgram.push(
                new SetRuntimeProp(target, _axis, a)
            );
            break;

        case MID:
            // target.axis = a - target.span * .5
            updateProgram.push(
                new SetRuntimeProp(target, _axis,
                    new Subtract(
                        a,
                        new Multiply(
                            new GetRuntimeProp(target, span),
                            new Value(.5)
                        )
                    )
                )
            );
            break;

        case MAX:
            // target.axis = a - object.span
            updateProgram.push(
                new SetRuntimeProp(target, _axis,
                    new Subtract(
                        a,
                        new GetRuntimeProp(target, span)
                    )
                )
            );
            break;

        case SPAN:
            // object.span = a
            updateProgram.push(
                new SetRuntimeProp(target, span, a)
            );
            break;

        case MIN_MID:
            // a is min
            // b is mid
            // target.axis = a
            // target.span = (b - a) * 2
            updateProgram.push(
                new SetRuntimeProp(target, _axis, a),
                new SetRuntimeProp(target, span,
                    new Multiply(
                        new Subtract(b, a),
                        new Value(2)
                    )
                )
            );
            break;

        case MIN_MAX:
            // a is min
            // b is max
            // target.axis = a
            // target.span = b - a
            updateProgram.push(
                new SetRuntimeProp(target, _axis, a),
                new SetRuntimeProp(target, span,
                    new Subtract(b, a)
                )
            );
            break;

        case MIN_SPAN:
            // a is min
            // b is span
            // target.axis = a
            // target.span = b
            updateProgram.push(
                new SetRuntimeProp(target, _axis, a),
                new SetRuntimeProp(target, span, b)
            );
            break;

        case MID_MAX:
            // a is mid
            // b is max
            // target.axis = (2 * a) - b
            // target.span = 2 * (b - a)
            updateProgram.push(
                new SetRuntimeProp(target, _axis,
                    new Subtract(
                        new Multiply(
                            new Value(2),
                            a
                        ),
                        b
                    )
                ),
                new SetRuntimeProp(target, span,
                    new Multiply(
                        new Value(2),
                        new Subtract(
                            b,
                            a
                        )
                    )
                )
            );
            break;

        case MID_SPAN:
            // a is mid
            // b is span
            // target.axis = a - (b * .5)
            // target.span = b
            updateProgram.push(
                new SetRuntimeProp(target, _axis,
                     new Subtract(
                        a,
                        new Multiply(
                            b,
                            new Value(.5)
                        )
                     )
                ),
                new SetRuntimeProp(target, span, b)
            );
            break;

        case MAX_SPAN:
            // a is max
            // b is span
            // target.axis = a - b
            // target.span = b
            updateProgram.push(
                new SetRuntimeProp(target, _axis,
                    new Subtract(
                        a,
                        b
                    )
                ),
                new SetRuntimeProp(target, span, b)
            );
            break;

        default:
            assert(false, "Unknown property combination: " + properties);
        }
    }

    private function incrementConstraint(target:Object):void
    {
        var count:int = constrainCount[target];
        constrainCount[target] = count + 1;
    }

    private function getNodeFactory(constraintType:String):NodeFactory
    {
        if (!_nodeFactories)
        {
            var nf:Object = _nodeFactories = { };
            nf[ConstraintType.OFFSET] = new OffsetNodeFactory(regs.regv);
            nf[ConstraintType.PROPORTIONAL] = new ProportionalNodeFactory(regs.regv);
        }
        var f:NodeFactory = _nodeFactories[constraintType];
        if (!f) throw new ArgumentError("Invalid constraint type: " + constraintType);
        return f;
    }

    private static function run(program:Vector.<ASTNode>):void
    {
        var node:ASTNode;
        for each (node in program)
        {
            node.eval();
        }
    }

    private static function filterProgramInPlace(program:Vector.<ASTNode>, filter:ASTFilter):void
    {
        for (var i:int = 0; i < program.length; i++)
        {
            program[i] = filter.filter(program[i]);
        }
    }

    private static function filterProgramCopy(program:Vector.<ASTNode>, filter:ASTFilter):Vector.<ASTNode>
    {
        var copy:Vector.<ASTNode> = new Vector.<ASTNode>(program.length, true);
        for (var i:int = 0; i < program.length; i++)
        {
            copy[i] = filter.filter(program[i]);
        }
        return copy;
    }
}


class Registers
{
    public var regv:Vector.<Number>;

    public function Registers()
    {
        regv = new Vector.<Number>();
    }

    public function nextFreeIndex():uint
    {
        regv.push(0);
        return regv.length - 1;
    }
}


/*
 * NODE FACTORIES
 */


interface NodeFactory
{
    function measure(targetObject:Object, targetProperty:uint, relativeObject:Object, relativeProperty:uint):ASTNode;
    function calculate(registerIndex:uint, relativeObject:Object, relativeProperty:uint):ASTNode;
}


class OffsetNodeFactory implements NodeFactory
{
    private var regv:Vector.<Number>;

    public function OffsetNodeFactory(regv:Vector.<Number>)
    {
        this.regv = regv;
    }

    public function measure(targetObject:Object, targetProperty:uint, relativeObject:Object, relativeProperty:uint):ASTNode
    {
        return new Subtract(
            new GetVirtualProp(targetObject, targetProperty),
            new GetVirtualProp(relativeObject, relativeProperty)
        );
    }

    public function calculate(registerIndex:uint, relativeObject:Object, relativeProperty:uint):ASTNode
    {
        return new Add(
            new GetVirtualProp(relativeObject, relativeProperty),
            new ReadOnly(new GetVector(regv, registerIndex))
        );
    }
}


class ProportionalNodeFactory implements NodeFactory
{
    private var regv:Vector.<Number>;

    public function ProportionalNodeFactory(regv:Vector.<Number>)
    {
        this.regv = regv;
    }

    public function measure(targetObject:Object, targetProperty:uint, relativeObject:Object, relativeProperty:uint):ASTNode
    {
        return new Divide(
            new GetVirtualProp(targetObject, targetProperty),
            new GetVirtualProp(relativeObject, relativeProperty)
        );
    }

    public function calculate(registerIndex:uint, relativeObject:Object, relativeProperty:uint):ASTNode
    {
        return new Multiply(
            new GetVirtualProp(relativeObject, relativeProperty),
            new ReadOnly(new GetVector(regv, registerIndex))
        );
    }
}


/*
 * AST
 */


interface ASTNode
{
    function eval():*
    function acceptFilter(filter:ASTFilter):ASTNode;
    function filterChildren(filter:ASTFilter):void;
}


class BinOp implements ASTNode
{
    public var a:ASTNode;
    public var b:ASTNode;
    public function BinOp(a:ASTNode, b:ASTNode)
    {
        this.a = a;
        this.b = b;
    }
    public function eval():*
    {
        throw new AbstractCallError();
    }
    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        throw new AbstractCallError();
    }
    public function filterChildren(filter:ASTFilter):void
    {
        a = filter.filter(a);
        b = filter.filter(b);
    }
}


class Add extends BinOp
{
    public function Add(a:ASTNode, b:ASTNode) { super(a, b); }
    public override function eval():*
    {
        return a.eval() + b.eval();
    }
    public override function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterAddNode(this);
    }
}

class Subtract extends BinOp
{
    public function Subtract(a:ASTNode, b:ASTNode) { super(a, b); }
    public override function eval():*
    {
        return a.eval() - b.eval();
    }
    public override function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterSubtractNode(this);
    }
}


class Multiply extends BinOp
{
    public function Multiply(a:ASTNode, b:ASTNode) { super(a, b); }
    public override function eval():*
    {
        return a.eval() * b.eval();
    }
    public override function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterMultiplyNode(this);
    }
}


class Divide extends BinOp
{
    public function Divide(a:ASTNode, b:ASTNode) { super(a, b); }
    public override function eval():*
    {
        return a.eval() / b.eval();
    }
    public override function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterDivideNode(this);
    }
}


class Round implements ASTNode
{
    public var child:ASTNode;

    public function Round(child:ASTNode)
    {
        this.child = child;
    }

    public function eval():*
    {
        return int(child.eval() + .5);
    }

    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterRoundNode(this);
    }

    public function filterChildren(filter:ASTFilter):void
    {
        child = filter.filter(child);
    }
}


class Max0 implements ASTNode
{
    public var child:ASTNode;

    public function Max0(child:ASTNode)
    {
        this.child = child;
    }

    public function eval():*
    {
        var e:* = child.eval();
        return e > 0 ? e : 0;
    }

    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterMax0Node(this);
    }

    public function filterChildren(filter:ASTFilter):void
    {
        child = filter.filter(child);
    }
}


class GetRuntimeProp implements ASTNode
{
    public var object:Object;
    public var prop:String;
    public function GetRuntimeProp(object:Object, prop:String)
    {
        this.object = object;
        this.prop = prop;
    }
    public function eval():*
    {
        return object[prop];
    }
    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterGetRuntimePropNode(this);
    }
    public function filterChildren(filter:ASTFilter):void { }
}


class GetVirtualProp implements ASTNode
{
    public var object:Object;
    public var vprop:uint;
    public function GetVirtualProp(object:Object, vprop:uint)
    {
        this.object = object;
        this.vprop = vprop;
    }
    public function eval():*
    {
        assert(false, "This node must be transformed");
    }
    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterGetVirtualPropNode(this);
    }
    public function filterChildren(filter:ASTFilter):void { }
}


class SetRuntimeProp implements ASTNode
{
    public var object:Object;
    public var prop:String;
    public var child:ASTNode;
    public function SetRuntimeProp(object:Object, prop:String, child:ASTNode)
    {
        this.object = object;
        this.prop = prop;
        this.child = child;
    }
    public function eval():*
    {
        return object[prop] = child.eval();
    }
    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterSetRuntimePropNode(this);
    }
    public function filterChildren(filter:ASTFilter):void
    {
        child = filter.filter(child);
    }
}


class SetVirtualProps implements ASTNode
{
    public var object:Object;

    public var vprop0:uint;
    public var child0:ASTNode;

    public var vprop1:uint;
    public var child1:ASTNode;

    public function SetVirtualProps(object:Object,
            vprop0:uint, child0:ASTNode,
            vprop1:uint = 0, child1:ASTNode = null)
    {
        this.object = object;

        this.vprop0 = vprop0;
        this.child0 = child0;

        this.vprop1 = vprop1;
        this.child1 = child1;
    }
    public function eval():*
    {
        assert(false, "This node must be transformed");
    }
    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterSetVirtualPropsNode(this);
    }
    public function filterChildren(filter:ASTFilter):void
    {
        child0 = filter.filter(child0);
        child1 = filter.filter(child1);
    }
}


class ReadOnly implements ASTNode
{
    public var child:ASTNode;
    public function ReadOnly(child:ASTNode)
    {
        this.child = child;
    }
    public function eval():*
    {
        return child.eval();
    }
    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterReadOnlyNode(this);
    }
    public function filterChildren(filter:ASTFilter):void
    {
        child = filter.filter(child);
    }
}


class GetVector implements ASTNode
{
    public var vector:Vector.<Number>;
    public var index:uint;
    public function GetVector(vector:Vector.<Number>, index:uint)
    {
        this.vector = vector;
        this.index = index;
    }
    public function eval():*
    {
        return vector[index];
    }
    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterGetVectorNode(this);
    }
    public function filterChildren(filter:ASTFilter):void { }
}


class SetVector implements ASTNode
{
    public var vector:Vector.<Number>;
    public var index:uint;
    public var child:ASTNode;
    public function SetVector(vector:Vector.<Number>, index:uint, child:ASTNode)
    {
        this.vector = vector;
        this.index = index;
        this.child = child;
    }
    public function eval():*
    {
        return vector[index] = child.eval();
    }
    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterSetVectorNode(this);
    }
    public function filterChildren(filter:ASTFilter):void
    {
        child = filter.filter(child);
    }
}


class Value implements ASTNode
{
    public var value:*;
    public function Value(value:*)
    {
        this.value = value;
    }
    public function eval():*
    {
        return value;
    }
    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterValueNode(this);
    }
    public function filterChildren(filter:ASTFilter):void { }
}


/*
 * AST FITLERS
 */


class ASTFilter
{
    public function filter(root:ASTNode):ASTNode
    {
        var n:ASTNode = root.acceptFilter(this);
        n.filterChildren(this);
        return n;
    }
    public function filterAddNode(n:Add):ASTNode { return n; }
    public function filterSubtractNode(n:Subtract):ASTNode { return n; }
    public function filterMultiplyNode(n:Multiply):ASTNode { return n; }
    public function filterDivideNode(n:Divide):ASTNode { return n; }
    public function filterRoundNode(n:Round):ASTNode { return n; }
    public function filterMax0Node(n:Max0):ASTNode { return n; }
    public function filterGetRuntimePropNode(n:GetRuntimeProp):ASTNode { return n; }
    public function filterSetRuntimePropNode(n:SetRuntimeProp):ASTNode { return n; }
    public function filterGetVirtualPropNode(n:GetVirtualProp):ASTNode { return n; }
    public function filterSetVirtualPropsNode(n:SetVirtualProps):ASTNode { return n; }
    public function filterSetVectorNode(n:SetVector):ASTNode { return n; }
    public function filterGetVectorNode(n:GetVector):ASTNode { return n; }
    public function filterReadOnlyNode(n:ReadOnly):ASTNode { return n; }
    public function filterValueNode(n:Value):ASTNode { return n; }
}


class VirtualGetResolver extends ASTFilter
{
    private var _axis:String;
    private var span:String;
    public function VirtualGetResolver(axis:String)
    {
        _axis = axis;
        span = axisToSpan[_axis];
    }

    public override function filterGetVirtualPropNode(n:GetVirtualProp):ASTNode
    {
        switch (n.vprop)
        {
        case MIN:
            return new GetRuntimeProp(n.object, _axis);
        case MID:
            return new Add(
                new GetRuntimeProp(n.object, _axis),
                new Multiply(
                    new GetRuntimeProp(n.object, span),
                    new Value(.5)
                )
            );
        case MAX:
            return new Add(
                new GetRuntimeProp(n.object, _axis),
                new GetRuntimeProp(n.object, span)
            );
        case SPAN:
            return new GetRuntimeProp(n.object, span);
        default:
            assert(false, "Unknown virtual property: " + n.vprop);
        }
        return null;
    }
}


class PropertyTransformer extends ASTFilter
{
    private var propertyAdapter:PropertyAdapter;

    public function PropertyTransformer(propertyAdapter:PropertyAdapter)
    {
        this.propertyAdapter = propertyAdapter;
    }

    public override function filterGetRuntimePropNode(n:GetRuntimeProp):ASTNode
    {
        return new GetRuntimeProp(
            n.object,
            propertyAdapter.substitutePropertyName(n.object, n.prop)
        );
    }

    public override function filterSetRuntimePropNode(n:SetRuntimeProp):ASTNode
    {
        return new SetRuntimeProp(
            n.object,
            propertyAdapter.substitutePropertyName(n.object, n.prop),
            n.child
        );
    }
}


class Max0SpanSetters extends ASTFilter
{
    public override function filterSetRuntimePropNode(n:SetRuntimeProp):ASTNode
    {
        if (n.prop == "width" || n.prop == "height")
        {
            return new SetRuntimeProp(n.object, n.prop, new Max0(n.child));
        }
        else
        {
            return n;
        }
    }
}


class RoundSetters extends ASTFilter
{
    public override function filterSetRuntimePropNode(n:SetRuntimeProp):ASTNode
    {
        return new SetRuntimeProp(n.object, n.prop, new Round(n.child));
    }
}


class ReadOnlyEvaluator extends ASTFilter
{
    public override function filterReadOnlyNode(n:ReadOnly):ASTNode
    {
        return new Value(n.eval());
    }
}


class ArithmeticConstFolder extends ASTFilter
{
    private var _replacements:int;
    public override function filter(root:ASTNode):ASTNode
    {
        _replacements = 0;
        return super.filter(root);
    }
    public function get replacements():int
    {
        return _replacements;
    }
    public override function filterAddNode(n:Add):ASTNode
    {
        return filterBinOp(n);
    }
    public override function filterSubtractNode(n:Subtract):ASTNode
    {
        return filterBinOp(n);
    }
    public override function filterMultiplyNode(n:Multiply):ASTNode
    {
        return filterBinOp(n);
    }
    public override function filterDivideNode(n:Divide):ASTNode
    {
        return filterBinOp(n);
    }
    private function filterBinOp(n:BinOp):ASTNode
    {
        var av:Value = n.a as Value;
        var bv:Value = n.b as Value;

        if (av && bv)
        {
            _replacements++;
            return new Value(n.eval());
        }
        else
        {
            return n;
        }
    }
    public override function filterRoundNode(n:Round):ASTNode
    {
        if (n.child is Value)
        {
            _replacements++;
            return new Value(n.eval());
        }
        else
        {
            return n;
        }
    }
    public override function filterMax0Node(n:Max0):ASTNode
    {
        if (n.child is Value)
        {
            _replacements++;
            return new Value(n.eval());
        }
        else
        {
            return n;
        }
    }
}


class ArithmeticOptimizer extends ASTFilter
{
    private var _replacements:int;
    public override function filter(root:ASTNode):ASTNode
    {
        _replacements = 0;
        return super.filter(root);
    }
    public function get replacements():int
    {
        return _replacements;
    }
    public override function filterAddNode(n:Add):ASTNode
    {
        return filterAdditiveNode(n);
    }
    public override function filterSubtractNode(n:Subtract):ASTNode
    {
        return filterAdditiveNode(n);
    }
    private function filterAdditiveNode(n:BinOp):ASTNode
    {
        var av:Value = n.a as Value;
        var bv:Value = n.b as Value;

        if (av && av.value == 0)
        {
            _replacements++;
            return filter(n.b);
        }
        else if (bv && bv.value == 0)
        {
            _replacements++;
            return filter(n.a);
        }
        else
        {
            return n;
        }
    }
    public override function filterMultiplyNode(n:Multiply):ASTNode
    {
        var av:Value = n.a as Value;
        var bv:Value = n.b as Value;

        if (av)
        {
            if (av.value == 0)
            {
                _replacements++;
                return new Value(0);
            }
            else if (av.value == 1)
            {
                _replacements++;
                return filter(n.b);
            }
        }

        if (bv)
        {
            if (bv.value == 0)
            {
                _replacements++;
                return new Value(0);
            }
            else if (bv.value == 1)
            {
                _replacements++;
                return filter(n.a);
            }
        }

        return n;
    }
    public override function filterDivideNode(n:Divide):ASTNode
    {
        var av:Value = n.a as Value;
        var bv:Value = n.b as Value;

        if (bv)
        {
            if (bv.value == 1)
            {
                _replacements++;
                return filter(n.a);
            }
            else if (av && av.value == 0 && bv.value != 0)
            {
                _replacements++;
                return new Value(0);
            }
        }

        return n;
    }
}
