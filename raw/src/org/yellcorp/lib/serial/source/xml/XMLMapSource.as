package org.yellcorp.lib.serial.source.xml
{
import org.yellcorp.lib.serial.error.SourceError;
import org.yellcorp.lib.serial.source.MapSource;


public class XMLMapSource extends BaseXMLSource implements MapSource
{
    public function XMLMapSource(root:XML)
    {
        super(root);
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

    protected override function getValue(key:*):*
    {
        var values:XMLList = root.*.(@id == key);

        if (values.length() != 1)
        {
            throw new SourceError(
                "Non-unique id attribute " + key +
                " (found" + values.length() +")");
        }
        return values[0];
    }
}
}
