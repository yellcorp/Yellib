package org.yellcorp.lib.serial.source.xml
{
import org.yellcorp.lib.error.AbstractCallError;
import org.yellcorp.lib.serial.source.KeyValueSource;
import org.yellcorp.lib.serial.source.MapSource;
import org.yellcorp.lib.serial.source.VectorSource;


public class BaseXMLSource
{
    public var root:XML;

    public function BaseXMLSource(root:XML)
    {
        this.root = root;
    }

    public function getPrimitiveValue(key:*):*
    {
        return getValue(key);
    }

    public function getKeyValueSource(key:*):KeyValueSource
    {
        return new XMLSource(getValue(key));
    }

    public function getVectorSource(key:*):VectorSource
    {
        return new XMLVectorSource(getValue(key));
    }

    public function getMapSource(key:*):MapSource
    {
        return new XMLMapSource(getValue(key));
    }

    protected function getValue(key:*):*
    {
        throw new AbstractCallError();
    }
}
}
