package org.yellcorp.text.highlighter.shapes
{
import org.yellcorp.text.highlighter.TextRunShape;

import flash.geom.Rectangle;


public class SingleLineTextRun implements TextRunShape
{
    private var rect:Rectangle;

    public function SingleLineTextRun(start:Rectangle, end:Rectangle)
    {
        if (start && end)
        {
            rect = start.union(end);
        }
        else if (start)
        {
            rect = start.clone();
        }
        else if (end)
        {
            rect = end.clone();
        }
    }

    public function getRectangleList():Array
    {
        return rect ? [ rect ] : [ ];
    }
}
}
