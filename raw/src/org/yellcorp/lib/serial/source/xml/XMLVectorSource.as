package org.yellcorp.lib.serial.source.xml
{
import org.yellcorp.lib.serial.source.VectorSource;


public class XMLVectorSource extends BaseXMLSource implements VectorSource
{
    public function XMLVectorSource(root:XML)
    {
        super(root);
    }

    protected override function getValue(key:*):*
    {
        return root.children()[key];
    }

    public function get length():int
    {
        return root.children().length();
    }
}
}
