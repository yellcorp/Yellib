package org.yellcorp.lib.layout.helpers
{
import flash.utils.Dictionary;
import org.yellcorp.lib.layout.properties.BOTTOM;
import org.yellcorp.lib.layout.properties.HCENTER;
import org.yellcorp.lib.layout.properties.HEIGHT;
import org.yellcorp.lib.layout.properties.LEFT;
import org.yellcorp.lib.layout.properties.RIGHT;
import org.yellcorp.lib.layout.properties.TOP;
import org.yellcorp.lib.layout.properties.VCENTER;
import org.yellcorp.lib.layout.properties.WIDTH;
import org.yellcorp.lib.layout.properties.X;
import org.yellcorp.lib.layout.properties.Y;



public class ConstraintInfo
{
    private var propertyConstraints:Dictionary;
    private var axisConstraintCount:Object;
    
    public function ConstraintInfo()
    {
        clear();
    }
    
    public function clear():void
    {
        propertyConstraints = new Dictionary(true);
        axisConstraintCount = { };
        axisConstraintCount[X] = new Dictionary(true);
        axisConstraintCount[Y] = new Dictionary(true);
    }
    
    public function isPropertyConstrained(target:Object, property:String):Boolean
    {
        var targetSet:Object = propertyConstraints[target];
        return targetSet && targetSet[property];
    }
    
    public function setPropertyConstrained(target:Object, property:String):void
    {
        var targetSet:Object = propertyConstraints[target];
        if (!targetSet)
        {
            targetSet = propertyConstraints[target] = { };
        }
        targetSet[property] = true;
    }

    public function canConstrainAxis(target:Object, axis:String):Boolean
    {
        var axisDict:Dictionary = axisConstraintCount[axis];
        if (!axisDict) return false;
        
        var constrainCount:Number = axisDict[target];
        
        // doing it backwards like this means we return true for
        // NaN as well, which constrainCount will be if we have
        // no record at all for target
        return !(constrainCount >= 2);
    }

    public function addAxisConstraint(target:Object, axis:String):void
    {
        var axisDict:Dictionary = axisConstraintCount[axis];
        if (!axisDict) return;
        
        var constrainCount:Number = axisDict[target];
        axisDict[target] = isNaN(constrainCount) ? 1 : constrainCount + 1;
    }
}
}
