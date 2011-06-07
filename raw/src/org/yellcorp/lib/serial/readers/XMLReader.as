package org.yellcorp.lib.serial.readers
{
import org.yellcorp.lib.serial.source.MapSource;
import org.yellcorp.lib.serial.source.ValueSource;
import org.yellcorp.lib.serial.source.VectorSource;
import org.yellcorp.lib.serial.source.xml.XMLMapSource;
import org.yellcorp.lib.serial.source.xml.XMLValueSource;
import org.yellcorp.lib.serial.source.xml.XMLVectorSource;


public class XMLReader implements Reader
{
    private var _readPrimitivesFromAttributes:Boolean;

    public function XMLReader(readPrimitivesFromAttributes:Boolean = false)
    {
        _readPrimitivesFromAttributes = readPrimitivesFromAttributes;
    }

    public function createValueSource(source:*):ValueSource
    {
        return new XMLValueSource(source, _readPrimitivesFromAttributes);
    }

    public function createVectorSource(source:*):VectorSource
    {
        return new XMLVectorSource(source);
    }

    public function createMapSource(source:*):MapSource
    {
        return new XMLMapSource(source);
    }

    public function get readPrimitivesFromAttributes():Boolean
    {
        return _readPrimitivesFromAttributes;
    }
}
}
