package org.yellcorp.lib.layout
{
import flash.display.Stage;


public class DefaultPropertyAdapter implements PropertyAdapter
{
    public function substitutePropertyName(object:Object, propertyName:String):String
    {
        if (object is Stage)
        {
            return propertyName == "width"  ? "stageWidth"  :
                   propertyName == "height" ? "stageHeight" :
                                              propertyName;
        }
        else
        {
            return propertyName;
        }
    }
}
}
