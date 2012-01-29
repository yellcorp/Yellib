package org.yellcorp.lib.layout_old.ast.factories
{
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.geom.Rectangle;
import org.yellcorp.lib.layout_old.adapters.BaseAdapter;
import org.yellcorp.lib.layout_old.adapters.DisplayAdapter;
import org.yellcorp.lib.layout_old.adapters.RectangleAdapter;
import org.yellcorp.lib.layout_old.adapters.StageAdapter;



/**
 * @private
 */
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
