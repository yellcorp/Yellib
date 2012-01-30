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

    public function dumpPrograms():String
    {
        var linebuf:Array = [ ];
        xAxis.dumpPrograms(linebuf);
        yAxis.dumpPrograms(linebuf);
        return linebuf.join("\n");
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
import flash.utils.getQualifiedClassName;


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

function vpropBitfieldToString(vprop:uint):String
{
    switch (vprop)
    {
    case NONE:     return "NONE";
    case MIN:      return "MIN";
    case MID:      return "MID";
    case MAX:      return "MAX";
    case SPAN:     return "SPAN";

    case MIN_MID:  return "MIN |MID";
    case MIN_MAX:  return "MIN | MAX";
    case MIN_SPAN: return "MIN | SPAN";

    case MID_MAX:  return "MID | MAX";
    case MID_SPAN: return "MID | SPAN";

    case MAX_SPAN: return "MAX | SPAN";

    default:       return "<INVALID>";
    }
}

const DUMP_SEPARATOR:String = "--------------------";


class SingleAxisLayout
{
    private var _axis:String;
    private var span:String;

    private var rounding:Boolean;
    private var propertyAdapter:PropertyAdapter;

    private var virtualGetResolver:VirtualGetResolver;
    private var propertyTransformer:PropertyTransformer;

    private var constrainCount:Dictionary;

    private var registers:Vector.<Number>;

    private var virtualMeasureProgram:Program;
    private var measureProgram:Program;

    private var virtualSettersByTarget:Dictionary;
    private var virtualUpdateProgram:Program;
    private var updateProgram:Program;

    private var measuredUpdateProgram:Program;

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
        registers = new Vector.<Number>();

        virtualMeasureProgram = new Program();
        measureProgram = null;

        virtualSettersByTarget = new Dictionary();
        virtualUpdateProgram = new Program();
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

        var regIndex:uint = allocateRegister();
        var measureNode:ASTNode = nodeFactory.measure(target, targetVirtualProp, relative, relativeVirtualProp);
        var storeNode:ASTNode = new SetRegister(registers, regIndex, measureNode);
        var calculateNode:ASTNode = nodeFactory.calculate(regIndex, relative, relativeVirtualProp);

        virtualMeasureProgram.nodes.push(storeNode);
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
            virtualUpdateProgram.nodes.push(existingSetter);
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
        measureProgram.run();
        measuredUpdateProgram = null;
    }

    public function update():void
    {
        if (!measureProgram) measure();
        if (!updateProgram) compileUpdateProgram();

        if (measuredUpdateProgram)
            measuredUpdateProgram.run();
        else
            updateProgram.run();
    }

    public function optimize():void
    {
        if (!measureProgram) measure();
        if (!updateProgram) compileUpdateProgram();
        measuredUpdateProgram = updateProgram.clone();
        measuredUpdateProgram.filter(new ReadOnlyEvaluator());
        measuredUpdateProgram.filter(new ArithmeticConstFolder());
        measuredUpdateProgram.filter(new ArithmeticOptimizer());
    }

    public function dumpPrograms(linebuf:Array):void
    {
        linebuf.push(DUMP_SEPARATOR, "Programs for " + _axis + " axis:");
        var dumper:ASTDumper = new ASTDumper();

        linebuf.push(DUMP_SEPARATOR, "virtualMeasureProgram:");
        dumpAST(dumper, virtualMeasureProgram, linebuf);

        linebuf.push(DUMP_SEPARATOR, "measureProgram:");
        dumpAST(dumper, measureProgram, linebuf);

        linebuf.push(DUMP_SEPARATOR, "virtualUpdateProgram:");
        dumpAST(dumper, virtualUpdateProgram, linebuf);

        linebuf.push(DUMP_SEPARATOR, "updateProgram:");
        dumpAST(dumper, updateProgram, linebuf);

        linebuf.push(DUMP_SEPARATOR, "measuredUpdateProgram:");
        dumpAST(dumper, measuredUpdateProgram, linebuf);
    }

    private function compileMeasureProgram():void
    {
        measureProgram = virtualMeasureProgram.clone();
        measureProgram.filter(virtualGetResolver);
        measureProgram.filter(propertyTransformer);
    }

    private function compileUpdateProgram():void
    {
        resolveVirtualSetters();
        updateProgram.filter(virtualGetResolver);
        updateProgram.filter(new Max0SpanSetters());
        if (rounding)
        {
            updateProgram.filter(new RoundSetters());
        }
        updateProgram.filter(propertyTransformer);
    }

    private function resolveVirtualSetters():void
    {
        var vset:SetVirtualProps;
        updateProgram = new Program();
        for each (vset in virtualUpdateProgram.nodes)
        {
            resolveVirtualSetter(vset);
        }
    }

    private function resolveVirtualSetter(vset:SetVirtualProps):void
    {
        var properties:int = vset.vprop0 | vset.vprop1;
        var target:Object = vset.object;
        var programNodes:Vector.<ASTNode> = updateProgram.nodes;

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
            programNodes.push(
                new SetRuntimeProp(target, _axis, a)
            );
            break;

        case MID:
            // target.axis = a - target.span * .5
            programNodes.push(
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
            programNodes.push(
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
            programNodes.push(
                new SetRuntimeProp(target, span, a)
            );
            break;

        case MIN_MID:
            // a is min
            // b is mid
            // target.axis = a
            // target.span = (b - a) * 2
            programNodes.push(
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
            programNodes.push(
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
            programNodes.push(
                new SetRuntimeProp(target, _axis, a),
                new SetRuntimeProp(target, span, b)
            );
            break;

        case MID_MAX:
            // a is mid
            // b is max
            // target.axis = (2 * a) - b
            // target.span = 2 * (b - a)
            programNodes.push(
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
            programNodes.push(
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
            programNodes.push(
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

    private function allocateRegister():uint
    {
        registers.push(0);
        return registers.length - 1;
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
            nf[ConstraintType.OFFSET] = new OffsetNodeFactory(registers);
            nf[ConstraintType.PROPORTIONAL] = new ProportionalNodeFactory(registers);
        }
        var f:NodeFactory = _nodeFactories[constraintType];
        if (!f) throw new ArgumentError("Invalid constraint type: " + constraintType);
        return f;
    }

    private static function dumpAST(dumper:ASTDumper, program:Program, out:Array):void
    {
        if (program)
        {
            dumper.clear();
            program.filter(dumper);
            out.push.apply(out, dumper.lines);
        }
        else
        {
            out.push("null");
        }
    }
}


class Program
{
    public var nodes:Vector.<ASTNode>;

    public function Program(length:int = 0)
    {
        if (length > 0)
        {
            nodes = new Vector.<ASTNode>(length, true);
        }
        else
        {
            nodes = new Vector.<ASTNode>();
        }
    }

    public function filter(astFilter:ASTFilter):void
    {
        for (var i:int = 0; i < nodes.length; i++)
        {
            nodes[i] = astFilter.filter(nodes[i]);
        }
    }

    public function clone():Program
    {
        var c:Program = new Program(nodes.length);
        var deepCopier:DeepCopier = new DeepCopier();
        for (var i:int = 0; i < nodes.length; i++)
        {
            c.nodes[i] = deepCopier.filter(nodes[i]);
        }
        return c;
    }

    public function run():void
    {
        for each (var node:ASTNode in nodes)
        {
            node.eval();
        }
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
            new ReadOnly(new GetRegister(regv, registerIndex))
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
            new ReadOnly(new GetRegister(regv, registerIndex))
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


/**
 * Base class for binary mathematical operations
 */
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


/**
 * Returns a + b
 */
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


/**
 * Returns a - b
 */
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


/**
 * Returns a * b
 */
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


/**
 * Returns a / b
 */
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


/**
 * Rounds the value of a node to the nearest integer, with half-integer values
 * rounding towards positive infinity.
 */
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


/**
 * Returns the value of a node, unless that value is less than 0, in which case
 * returns 0.
 */
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
        return e < 0 ? 0 : e;
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


/**
 * Returns the value of an actual property on an object.
 */
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


/**
 * Returns a virtual property of an object.  A virtual property is an
 * intermediate abstraction that does not exist in the runtime, but will later
 * be transformed into runtime terms by the VirtualGetResolver AST filter.
 *
 * Virtual property  |  X axis   |  Transformed into
 * MID               |  HCENTER  |  object.x + object.width * 0.5
 * MAX               |  RIGHT    |  object.x + object.width
 */
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


/**
 * Sets an actual property on an object to the value of a node.
 */
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


/**
 * Sets up to two virtual properties.  This is represented as a single node as
 * both constraints must be known when generating SetRuntimeProp nodes.  When
 * generating SetRuntimeProps, if only one property is given, the span
 * (width/height) property of the target object should remain untouched unless
 * specifically nominated.
 */
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
        if (child0) child0 = filter.filter(child0);
        if (child1) child1 = filter.filter(child1);
    }
}


/**
 * When evaluated, simply returns the result of its child node.  The existence
 * of a ReadOnly node indicates this node can be replaced with its evaluated
 * child node in the optimization phase.
 */
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


/**
 * Returns the value of a register.
 */
class GetRegister implements ASTNode
{
    public var regv:Vector.<Number>;
    public var index:uint;
    public function GetRegister(regv:Vector.<Number>, index:uint)
    {
        this.regv = regv;
        this.index = index;
    }
    public function eval():*
    {
        return regv[index];
    }
    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterGetRegisterNode(this);
    }
    public function filterChildren(filter:ASTFilter):void { }
}


/**
 * Sets a register with the result of another node.
 */
class SetRegister implements ASTNode
{
    public var regv:Vector.<Number>;
    public var index:uint;
    public var child:ASTNode;
    public function SetRegister(regv:Vector.<Number>, index:uint, child:ASTNode)
    {
        this.regv = regv;
        this.index = index;
        this.child = child;
    }
    public function eval():*
    {
        return regv[index] = child.eval();
    }
    public function acceptFilter(filter:ASTFilter):ASTNode
    {
        return filter.filterSetRegisterNode(this);
    }
    public function filterChildren(filter:ASTFilter):void
    {
        child = filter.filter(child);
    }
}


/**
 * Stores a constant value.
 */
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
    public function filterSetRegisterNode(n:SetRegister):ASTNode { return n; }
    public function filterGetRegisterNode(n:GetRegister):ASTNode { return n; }
    public function filterReadOnlyNode(n:ReadOnly):ASTNode { return n; }
    public function filterValueNode(n:Value):ASTNode { return n; }
}


class DeepCopier extends ASTFilter
{
    public override function filterAddNode(n:Add):ASTNode { return new Add(n.a, n.b); }
    public override function filterSubtractNode(n:Subtract):ASTNode { return new Subtract(n.a, n.b); }
    public override function filterMultiplyNode(n:Multiply):ASTNode { return new Multiply(n.a, n.b); }
    public override function filterDivideNode(n:Divide):ASTNode { return new Divide(n.a, n.b); }
    public override function filterRoundNode(n:Round):ASTNode { return new Round(n.child); }
    public override function filterMax0Node(n:Max0):ASTNode { return new Max0(n.child); }
    public override function filterGetRuntimePropNode(n:GetRuntimeProp):ASTNode { return new GetRuntimeProp(n.object, n.prop); }
    public override function filterSetRuntimePropNode(n:SetRuntimeProp):ASTNode { return new SetRuntimeProp(n.object, n.prop, n.child); }
    public override function filterGetVirtualPropNode(n:GetVirtualProp):ASTNode { return new GetVirtualProp(n.object, n.vprop); }
    public override function filterSetVirtualPropsNode(n:SetVirtualProps):ASTNode { return new SetVirtualProps(n.object, n.vprop0, n.child0, n.vprop1, n.child1); }
    public override function filterSetRegisterNode(n:SetRegister):ASTNode { return new SetRegister(n.regv, n.index, n.child); }
    public override function filterGetRegisterNode(n:GetRegister):ASTNode { return new GetRegister(n.regv, n.index); }
    public override function filterReadOnlyNode(n:ReadOnly):ASTNode { return new ReadOnly(n.child); }
    public override function filterValueNode(n:Value):ASTNode { return new Value(n.value); }
}


/**
 * Resolves GetVirtualProp nodes into GetRuntimeProp nodes.
 */
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


/**
 * Uses an instance of PropertyAdapter to replace runtime property getters
 * and setters with alternate property names.  This is motivated by the
 * usefulness of transforming stage.width -> stage.stageWidth, etc.
 */
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


/**
 * Inserts Max0 nodes between a SetRuntimeProp node and its value, if the
 * SetRuntimeProp node writes to a 'width' or 'height' property.  This must be
 * applied before PropertyTransformer as it has no concept of replaced property
 * names.
 */
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


/**
 * Inserts Round nodes between a SetRuntimeProp node and its value
 */
class RoundSetters extends ASTFilter
{
    public override function filterSetRuntimePropNode(n:SetRuntimeProp):ASTNode
    {
        return new SetRuntimeProp(n.object, n.prop, new Round(n.child));
    }
}


/**
 * Replaces ReadOnly nodes with the evaluated value of their child node.
 */
class ReadOnlyEvaluator extends ASTFilter
{
    public override function filterReadOnlyNode(n:ReadOnly):ASTNode
    {
        return new Value(n.eval());
    }
}


/**
 * Evaluates an arithmetic node if all its children are Value nodes.
 */
class ArithmeticConstFolder extends ASTFilter
{
    private var _replacements:int;

    public function clear():void
    {
        _replacements = 0;
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


/**
 * Performs some simple transformations to eliminate unnecessary arithmetic
 * operations:
 *
 * n +/- 0 or 0 +/- n  ->  n
 * n * 0 or 0 * n  ->  0
 * n * 1 or 1 * n  ->  n
 * n / 1  ->  n
 * 0 / n, n != 0  -> 0
 */
class ArithmeticOptimizer extends ASTFilter
{
    private var _replacements:int;

    public function clear():void
    {
        _replacements = 0;
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


/**
 * Accumulates a string representation of an AST and otherwise passes the
 * AST unfiltered.  The result is an array of Strings, each representing a line
 * of output.  For plaintext tracing, the lines array should be joined with "\n"
 */
class ASTDumper extends ASTFilter
{
    public var lines:Array = [ ];
    private var indent:Array = [ ];

    public function clear():void
    {
        lines = [ ];
        indent = [ ];
    }

    protected function println(line:String):void
    {
        lines.push(indent.join("") + line);
    }

    public override function filter(root:ASTNode):ASTNode
    {
        var n:ASTNode = root.acceptFilter(this);
        indent.push(" ");
        n.filterChildren(this);
        indent.pop();
        return n;
    }

    public override function filterAddNode(n:Add):ASTNode
    {
        println("Add");
        return n;
    }

    public override function filterSubtractNode(n:Subtract):ASTNode
    {
        println("Subtract");
        return n;
    }

    public override function filterMultiplyNode(n:Multiply):ASTNode
    {
        println("Multiply");
        return n;
    }

    public override function filterDivideNode(n:Divide):ASTNode
    {
        println("Divide");
        return n;
    }

    public override function filterRoundNode(n:Round):ASTNode
    {
        println("Round");
        return n;
    }

    public override function filterMax0Node(n:Max0):ASTNode
    {
        println("Max0");
        return n;
    }

    public override function filterGetRuntimePropNode(n:GetRuntimeProp):ASTNode
    {
        println("GetRuntimeProp(" + getQualifiedClassName(n.object) + ", " + n.prop + ")");
        return n;
    }

    public override function filterSetRuntimePropNode(n:SetRuntimeProp):ASTNode
    {
        println("SetRuntimeProp(" + getQualifiedClassName(n.object) + ", " + n.prop + ")");
        return n;
    }

    public override function filterGetVirtualPropNode(n:GetVirtualProp):ASTNode
    {
        println("GetVirtualProp(" + getQualifiedClassName(n.object) + ", " + vpropBitfieldToString(n.vprop) + ")");
        return n;
    }

    public override function filterSetVirtualPropsNode(n:SetVirtualProps):ASTNode
    {
        println("SetVirtualProps(" + getQualifiedClassName(n.object) +
                ", 0=" + vpropBitfieldToString(n.vprop0) +
                ", 1=" + vpropBitfieldToString(n.vprop1) + ")");
        return n;
    }

    public override  function filterSetRegisterNode(n:SetRegister):ASTNode
    {
        println("SetRegister(" + n.index + ")");
        return n;
    }

    public override function filterGetRegisterNode(n:GetRegister):ASTNode
    {
        println("GetRegister(" + n.index + ")");
        return n;
    }

    public override function filterReadOnlyNode(n:ReadOnly):ASTNode
    {
        println("ReadOnly");
        return n;
    }

    public override function filterValueNode(n:Value):ASTNode
    {
        println("Value(" + n.value + ")");
        return n;
    }
}
