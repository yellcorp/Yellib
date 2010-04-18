package org.yellcorp.text.highlighter.shapes
{
import org.yellcorp.text.highlighter.TextRunShape;

import flash.geom.Rectangle;


public class MultiLineTextRun implements TextRunShape
{
    private var head:Rectangle;
    private var tail:Rectangle;
    private var body:Rectangle;

    private var rectList:Array;

    public function MultiLineTextRun(start:Rectangle, end:Rectangle, wrapXMin:Number, wrapXMax:Number)
    {
        if (end.y == start.y)
        {
            head = start.union(end);
        }
        else
        {
            head = new Rectangle(start.x, start.y, wrapXMax - start.x, start.height);
            tail = new Rectangle(wrapXMin, end.y, end.x + end.width, end.height);

            if (tail.y > head.y + head.height)
            {
                body = new Rectangle(wrapXMin, head.y + head.height, wrapXMax - wrapXMin, tail.y - (head.y + head.height));
            }
        }
        makeRectList();
    }

    private function makeRectList():void
    {
        // make an array and filter out nulls
        rectList = [ head, body, tail ].filter(
            function (item:*, i:int, a:Array):Boolean
            {
                return Boolean(item);
            }
        );
    }

    public function getRectangleList():Array
    {
        return rectList.slice();
    }
}
}
