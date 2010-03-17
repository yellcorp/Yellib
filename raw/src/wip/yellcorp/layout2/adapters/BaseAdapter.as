package wip.yellcorp.layout2.adapters
{
import org.yellcorp.error.AbstractCallError;

import wip.yellcorp.layout2.LayoutAxis;
import wip.yellcorp.layout2.LayoutProperty;


public class BaseAdapter
{
    public final function getAccessor(axis:String, property:String, wantSetter:Boolean):Function
    {
        switch (axis)
        {
            case LayoutAxis.X :
            {
                switch (property)
                {
                    case LayoutProperty.MIN :
                        return wantSetter ? setX : getX;
                    case LayoutProperty.SIZE :
                        return wantSetter ? setWidth : getWidth;
                }
            }
            case LayoutAxis.Y :
            {
                switch (property)
                {
                    case LayoutProperty.MIN :
                        return wantSetter ? setY : getY;
                    case LayoutProperty.SIZE :
                        return wantSetter ? setHeight : getHeight;
                }
            }
            default :
            {
                throw new ArgumentError("Unsupported axis");
            }
        }
        throw new ArgumentError("Unsupported property");
    }
    public function getX():Number
    {
        throw new AbstractCallError();
    };
    public function getY():Number
    {
        throw new AbstractCallError();
    };
    public function getWidth():Number
    {
        throw new AbstractCallError();
    };
    public function getHeight():Number
    {
        throw new AbstractCallError();
    };
    public function setX(n:Number):void
    {
        throw new AbstractCallError();
    };
    public function setY(n:Number):void
    {
        throw new AbstractCallError();
    };
    public function setWidth(n:Number):void
    {
        throw new AbstractCallError();
    };
    public function setHeight(n:Number):void
    {
        throw new AbstractCallError();
    };
}
}
