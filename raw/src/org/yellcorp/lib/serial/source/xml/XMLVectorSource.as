package org.yellcorp.lib.serial.source.xml
{
import org.yellcorp.lib.serial.source.VectorSource;


public class XMLVectorSource implements VectorSource
{
    public var root:XML;

    public function XMLVectorSource(root:XML)
    {
        this.root = root;
    }

    public function getPrimitiveValue(key:*):*
    {
        return getStructuredValue(key);
    }

    public function getStructuredValue(key:*):*
    {
        return root.children()[key];
    }

    public function get length():int
    {
        return root.children().length();
    }
}
}
