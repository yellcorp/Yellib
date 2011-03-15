package org.yellcorp.lib.display
{
import flash.accessibility.AccessibilityProperties;
import flash.display.DisplayObject;
import flash.geom.Rectangle;
import flash.geom.Transform;
import flash.utils.Dictionary;


/**
 * A non-hierarchical group of display objects.  Recreates the DisplayObject interface
 * so a set of DisplayObjects can have properties set quickly, easily, hopefully
 */
public class DisplayObjectGroup
{
    private var members:Dictionary;
    private var keyOrder:Array;

    private static const LOGICAL_OR:int = 1;
    private static const LOGICAL_AND:int = 2;

    public function DisplayObjectGroup(initialMembers:Array = null)
    {
        clear();
        if (initialMembers && initialMembers.length > 0)
        {
            addFromArray(initialMembers);
        }
    }

    public function hasObject(query:DisplayObject):Boolean
    {
        return Boolean(members[query]);
    }

    public function addObject(newMember:DisplayObject):void
    {
        if (!hasObject(newMember))
        {
            members[newMember] = true;
            keyOrder.push(newMember);
        }
    }

    public function addFromArray(newMembers:Array):int
    {
        var i:int;
        var added:int = 0;

        for (i = 0; i < newMembers.length; i++)
        {
            if (addObject(DisplayObject(newMembers[i])))
            {
                added++;
            }
        }

        return added;
    }

    public function removeObject(member:DisplayObject):DisplayObject
    {
        var index:int;

        if (hasObject(member))
        {
            index = keyOrder.indexOf(member);
            keyOrder.splice(index, 1);
            delete members[member];
            return member;
        }
        else
        {
            return null;
        }
    }

    public function removeObjectAt(index:int):DisplayObject
    {
        var removed:DisplayObject;

        if (index >= 0 && index < members.length)
        {
            removed = keyOrder[index];
            keyOrder.splice(index, 1);
            delete members[removed];
            return removed;
        }
        else
        {
            return null;
        }
    }

    public function clear():void
    {
        members = new Dictionary();
        keyOrder = [ ];
    }

    // DisplayObject interface
    public function set accessibilityProperties(value:AccessibilityProperties):void
    {
        iterateSetter('accessibilityProperties', value);
    }

    public function set alpha(value:Number):void
    {
        iterateSetter('alpha', value);
    }

    public function set blendMode(value:String):void
    {
        iterateSetter('blendMode', value);
    }

    public function set cacheAsBitmap(value:Boolean):void
    {
        iterateSetter('cacheAsBitmap', value);
    }

    public function set filters(value:Array):void
    {
        iterateSetter('filters', value);
    }

    // TODO: make these get total rectangle
    /*
    public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle
    {

    }

    public function getRect(targetCoordinateSpace:DisplayObject):Rectangle
    {

    }
     */

    public function set height(value:Number):void
    {
        iterateSetter('height', value);
    }

    public function hitTestObject(obj:DisplayObject):Boolean
    {
        return iterateBooleanFunc('hitTestObject', [ obj ], LOGICAL_OR);
    }

    public function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false):Boolean
    {
        return iterateBooleanFunc('hitTestPoint', [x, y, shapeFlag], LOGICAL_OR);
    }

    public function set opaqueBackground(value:Object):void
    {
        iterateSetter('opaqueBackground', value);
    }

    public function set rotation(value:Number):void
    {
        iterateSetter('rotation', value);
    }

    public function set scale9Grid(innerRectangle:Rectangle):void
    {
        iterateSetter('scale9Grid', innerRectangle);
    }

    public function set scaleX(value:Number):void
    {
        iterateSetter('scaleX', value);
    }

    public function set scaleY(value:Number):void
    {
        iterateSetter('scaleY', value);
    }

    public function set scrollRect(value:Rectangle):void
    {
        iterateSetter('scrollRect', value);
    }

    public function set transform(value:Transform):void
    {
        iterateSetter('transform', value);
    }

    public function set visible(value:Boolean):void
    {
        iterateSetter('visible', value);
    }

    public function set width(value:Number):void
    {
        iterateSetter('width', value);
    }

    public function set x(value:Number):void
    {
        iterateSetter('x', value);
    }

    public function set y(value:Number):void
    {
        iterateSetter('y', value);
    }

    private function iterateSetter(property:String, value:*):void
    {
        var i:int;
        for (i=0; i < keyOrder.length; i++)
        {
            keyOrder[i][property] = value;
        }
    }

    private function iterateBooleanFunc(funcName:String, args:Array, logicType:int):Boolean
    {
        var decider:Boolean;
        var i:int;
        var test:DisplayObject;
        var func:Function;

        if (logicType == LOGICAL_OR)
        {
            decider = true;
        }
        else if (logicType == LOGICAL_AND)
        {
            decider = false;
        }
        else
        {
            throw new ArgumentError("Invalid value for logicType");
        }

        for (i=0; i < keyOrder.length; i++)
        {
            test = keyOrder[i];
            func = test[funcName];
            if (func.apply(test, args) === decider)
            {
                return decider;
            }
        }
        return !decider;
    }
}
}
