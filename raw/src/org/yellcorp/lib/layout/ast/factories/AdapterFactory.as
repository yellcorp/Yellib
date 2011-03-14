package org.yellcorp.lib.layout.ast.factories
{
import org.yellcorp.lib.layout.adapters.BaseAdapter;
import org.yellcorp.lib.layout.adapters.DisplayAdapter;
import org.yellcorp.lib.layout.adapters.RectangleAdapter;
import org.yellcorp.lib.layout.adapters.StageAdapter;

import flash.display.DisplayObject;
import flash.display.Stage;
import flash.geom.Rectangle;


public class AdapterFactory
{
    public function wrap(subject:Object):BaseAdapter
    {
        if (subject is Rectangle)
        {
            return new RectangleAdapter(Rectangle(subject));
        }
        else if (subject is Stage)
        {
            return new StageAdapter(Stage(subject));
        }
        else if (subject is DisplayObject)
        {
            return new DisplayAdapter(DisplayObject(subject));
        }
        else
        {
            throw new ArgumentError("Unsupported type");
        }
    }
}
}
