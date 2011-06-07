package org.yellcorp.lib.serial.source.xml
{
import org.yellcorp.lib.serial.source.MapSource;


public class XMLMapSource implements MapSource
{
    public var root:XML;

    public function XMLMapSource(root:XML)
    {
        this.root = root;
    }

    public function getPrimitiveValue(key:*):*
    {
        return getStructuredValue(key);
    }

    public function getStructuredValue(key:*):*
    {
        var values:XMLList = root.*.(@id == key);
        return XMLSourceUtil.assertSingle(values, "*.@id==" + key);
    }

    public function get keys():Array
    {
        var keys:Array = [];

        for each (var value:XML in root.*.(@id != ""))
        {
            keys.push(value.@id);
        }
        return keys;
    }
}
}
