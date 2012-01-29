package org.yellcorp.lib.layout_old
{
import org.yellcorp.lib.collections.LinkedSet;
import org.yellcorp.lib.iterators.readonly.Iterator;

import flash.display.DisplayObject;
import flash.geom.Point;


public class HorizontalFlow
{
    public var topLeft:Point;
    public var xGutter:Number;
    public var yGutter:Number;
    public var width:Number;
    public var rowVerticalAlignment:Number;

    private var members:LinkedSet;

    public function HorizontalFlow(topLeft:Point = null,
        xGutter:Number = 0, yGutter:Number = 0,
        rowVerticalAlignment:Number = 1,
        width:Number = Number.POSITIVE_INFINITY)
    {
        this.topLeft = topLeft;
        this.xGutter = xGutter;
        this.yGutter = yGutter;
        this.width = width;
        this.rowVerticalAlignment = rowVerticalAlignment;

        members = new LinkedSet();
    }

    public function clear():void
    {
        members.clear();
    }

    public function append(member:DisplayObject):void
    {
        members.pushBack(member);
    }

    public function insertAfter(
        newMember:DisplayObject, referenceMember:DisplayObject):void
    {
        members.insertAfter(newMember, referenceMember);
    }

    public function insertBefore(
        newMember:DisplayObject, referenceMember:DisplayObject):void
    {
        members.insertBefore(newMember, referenceMember);
    }

    public function appendMany(newMembers:*):void
    {
        for each (var d:DisplayObject in newMembers)
        {
            members.pushBack(d);
        }
    }

    public function remove(member:DisplayObject):Boolean
    {
        return members.remove(member);
    }

    public function contains(member:DisplayObject):Boolean
    {
        return members.contains(member);
    }

    public function getMemberAt(index:int):DisplayObject
    {
        return DisplayObject(members.get(index));
    }

    public function removeAt(index:int):Boolean
    {
        return members.removeAt(index);
    }

    public function insertAt(newMember:DisplayObject, index:int):void
    {
        members.insertAt(newMember, index);
    }

    public function layout():void
    {
        var i:Iterator;
        var d:DisplayObject;

        var cx:Number = topLeft ? topLeft.x : 0;
        var cy:Number = topLeft ? topLeft.y : 0;

        var gx:Number = isFinite(xGutter) ? xGutter : 0;
        var gy:Number = isFinite(yGutter) ? yGutter : 0;

        var row:Array = [ ];
        var rowHeight:Number = 0;
        var rowAlignment:Number = isFinite(rowVerticalAlignment) ? rowVerticalAlignment : 0;

        for (i = members.iterator; i.valid; i.next())
        {
            d = i.current;

            if (row.length > 0 && cx + d.width > width)
            {
                alignRow(row, cy, rowHeight, rowAlignment);
                cx = 0;
                cy += rowHeight + gy;
                row = [ ];
                rowHeight = 0;
            }

            if (d.height > rowHeight)
            {
                rowHeight = d.height;
            }
            d.x = cx;
            cx += d.width + gx;
            row.push(d);
        }
        alignRow(row, cy, rowHeight, rowAlignment);
    }

    private function alignRow(row:Array, cy:Number,
        rowHeight:Number, rowAlignment:Number):void
    {
        if (row.length == 0)
        {
            return;
        }
        for each (var d:DisplayObject in row)
        {
            d.y = cy + rowAlignment * (rowHeight - d.height);
        }
    }
}
}
