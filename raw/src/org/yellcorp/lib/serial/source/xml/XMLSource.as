package org.yellcorp.lib.serial.source.xml
{
import org.yellcorp.lib.serial.error.SourceError;
import org.yellcorp.lib.serial.source.KeyValueSource;


public class XMLSource extends BaseXMLSource implements KeyValueSource
{
    public function XMLSource(root:XML)
    {
        super(root);
    }

    protected override function getValue(key:*):*
    {
        var values:XMLList = root[key];

        if (values.length() != 1)
        {
            throw new SourceError(
                "Wrong number of values defined for key " + key +
                " (found " + values.length() +")");
        }
        return values[0];
    }
}
}
