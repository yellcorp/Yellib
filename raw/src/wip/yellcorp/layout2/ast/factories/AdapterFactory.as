package wip.yellcorp.layout2.ast.factories
{
import wip.yellcorp.layout2.adapters.*;

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
