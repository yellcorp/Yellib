package org.yellcorp.lib.serial.source.object
{
import org.yellcorp.lib.serial.source.MapSource;


public class ObjectMapSource extends ObjectSource implements MapSource
{
    public function ObjectMapSource(source:Object)
    {
        super(source);
    }

    public function get keys():Array
    {
        var result:Array = [];
        for (var key:String in source)
        {
            result.push(key);
        }
        return result;
    }
}
}
