package org.yellcorp.lib.layout
{
import org.yellcorp.lib.layout.ast.LayoutNode;
import org.yellcorp.lib.layout.axprops.*;
import org.yellcorp.lib.layout.helpers.ConstraintInfo;
import org.yellcorp.lib.layout.helpers.Registers;
import org.yellcorp.lib.layout.nodefac.NodeFactory;
import org.yellcorp.lib.layout.nodefac.OffsetNodeFactory;
import org.yellcorp.lib.layout.nodefac.ProportionalNodeFactory;
import org.yellcorp.lib.layout.properties.*;


public class Layout
{
    private static var _propToAxis:Object;
    private static var _propToAxProp:Object;
    private static var _nodeFactories:Object;
    
    private var info:ConstraintInfo;
    private var regs:Registers;
    
    public function Layout()
    {
        clear();
    }

    public function clear():void
    {
        info = new ConstraintInfo();
        regs = new Registers();
    }
    
    public function constrain(
            target:Object, targetProperty:String,
            relative:Object, relativeProperty:String,
            constraintType:String):void
    {
        var axis:String = getAxis(targetProperty);
        var relativeAxis:String = getAxis(relativeProperty);
        
        if (!info.isPropertyConstrained(target, targetProperty))
        {
            throw new ArgumentError("Target's " + targetProperty + " property is already constrained");
        }
        else if (axis !== relativeAxis)
        {
            throw new ArgumentError("Can't constrain properties on different axes");
        }

        var targetAxialProp:String = getAxialProperty(targetProperty);
        var relativeAxialProp:String = getAxialProperty(relativeProperty);
        
        if (!info.canConstrainAxis(target, axis))
        {
            throw new ArgumentError("Target cannot accept any more constraints in the " + axis + " axis");            
        }
        
        // constrain_(axis, target, targetAxialProp, relative, relativeAxialProp, constraintType);
        var nodeFactory:NodeFactory = getNodeFactory(constraintType);

        var reg:uint = regs.nextFreeIndex();
        var measureNode:LayoutNode = nodeFactory.measure(target, targetProperty, relative, relativeProperty);
        var calculateNode:LayoutNode = nodeFactory.apply(reg, relative, relativeProperty);
        
        info.setPropertyConstrained(target, targetProperty);
        info.addAxisConstraint(target, axis);
    }
    
    public function isPropertyConstrained(target:Object, targetProperty:String):Boolean
    {
        return info.isPropertyConstrained(target, targetProperty);
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

    private static function getAxialProperty(property:String):String
    {
        if (!_propToAxProp)
        {
            var p:Object = _propToAxProp = { };
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
        return _propToAxProp[property];
    }

    private static function getNodeFactory(constraintType:String):NodeFactory
    {
        if (!_nodeFactories)
        {
            var nf:Object = _nodeFactories = { };
            nf[ConstraintType.OFFSET] = new OffsetNodeFactory();
            nf[ConstraintType.PROPORTIONAL] = new ProportionalNodeFactory();
        }
        var f:NodeFactory = _nodeFactories[constraintType];
        if (!f) throw new ArgumentError("Invalid constraint type: " + constraintType);
        return f;
    }
}
}
