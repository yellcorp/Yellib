package org.yellcorp.layout
{
import org.yellcorp.layout.adapters.*;

import flash.display.DisplayObject;
import flash.display.Stage;
import flash.geom.Rectangle;


public class LayoutLink implements Layout
{
    private var target:LayoutAdapter;
    private var source:LayoutAdapter;

    private var sourceGetter:Function;
    private var targetGetter:Function;
    private var targetSetter:Function;

    private var difference:Number;

    public function LayoutLink(targetObject:Object, targetProperty:String,
                               sourceObject:Object, sourceProperty:String)
    {
        target = createAdapter(targetObject);
        source = createAdapter(sourceObject);

        sourceGetter = getClosure(source, sourceProperty, true);
        targetSetter = getClosure(target, targetProperty, false);
        targetGetter = getClosure(target, targetProperty, true);

        //should this be automatic?
        captureLayout();
    }

    public function captureLayout():void
    {
        difference = targetGetter() - sourceGetter();
    }

    public function updateLayout():void
    {
        targetSetter(sourceGetter() + difference);
    }

    private function getClosure(subject:LayoutAdapter, propString:String, getter:Boolean):Function
    {
        switch (propString)
        {
            case LayoutProperty.X :
                return getter ? subject.getX : subject.setX;
                break;

            case LayoutProperty.Y :
                return getter ? subject.getY : subject.setY;
                break;

            case LayoutProperty.WIDTH :
                return getter ? subject.getWidth : subject.setWidth;
                break;

            case LayoutProperty.HEIGHT :
                return getter ? subject.getHeight : subject.setHeight;
                break;

            case LayoutProperty.CENTER_X :
                return getter ? subject.getCenterX : subject.setCenterX;
                break;

            case LayoutProperty.CENTER_Y :
                return getter ? subject.getCenterY : subject.setCenterY;
                break;

            default :
                throw new ArgumentError("Unsupported property");
                break;
        }
    }

    private function createAdapter(subject:Object):LayoutAdapter
    {
        if (subject is Rectangle)
        {
            return new AdapterRectangle(Rectangle(subject));
        }
        else if (subject is Stage)
        {
            return new AdapterStage(Stage(subject));
        }
        else if (subject is DisplayObject)
        {
            return new AdapterDisplay(DisplayObject(subject));
        }
        else
        {
            throw new ArgumentError("Unsupported type");
        }
    }
}
}
