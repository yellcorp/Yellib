package org.yellcorp.lib.display
{
import flash.display.DisplayObject;
import flash.geom.Point;
import flash.utils.Dictionary;


public class DisplaySort
{
    public static const UP:String = "up";
    public static const DOWN:String = "down";
    public static const LEFT:String = "left";
    public static const RIGHT:String = "right";

    private static var sortMemo:Dictionary;
    private static var zero:Point = new Point();

    public static function sortByCoordinates(arrayOfDisplayObjects:Array,
        primary:String, secondary:String):void
    {
        var prop1:String = primary == UP || primary == DOWN ? "y" : "x";
        var lower1:int = primary == DOWN || primary == RIGHT ? -1 : 1;

        var prop2:String = secondary == LEFT || secondary == RIGHT ? "x" : "y";
        var lower2:int = secondary == DOWN || secondary == RIGHT ? -1 : 1;

        sortMemo = new Dictionary(true);

        function getMemoPoint(displayObject:DisplayObject):Point
        {
            var point:Point = sortMemo[displayObject];

            if (!point)
            {
                sortMemo[displayObject] = point = displayObject.localToGlobal(zero);
            }

            return point;
        }

        function compare(a:DisplayObject, b:DisplayObject):int
        {
            var aPoint:Point = getMemoPoint(a);
            var bPoint:Point = getMemoPoint(b);

            var a1:Number = aPoint[prop1];
            var b1:Number = bPoint[prop1];
            var a2:Number;
            var b2:Number;

            if (a1 < b1)
            {
                return lower1;
            }
            else if (a1 > b1)
            {
                return -lower1;
            }
            else
            {
                a2 = aPoint[prop2];
                b2 = bPoint[prop2];

                if (a2 < b2)
                {
                    return lower2;
                }
                else if (a2 > b2)
                {
                    return -lower2;
                }
                else
                {
                    return 0;
                }
            }
        }

        arrayOfDisplayObjects.sort(compare);
    }
}
}
