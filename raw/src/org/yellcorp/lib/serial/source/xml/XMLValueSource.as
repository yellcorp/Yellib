package org.yellcorp.lib.serial.source.xml
{
import org.yellcorp.lib.serial.source.ValueSource;


public class XMLValueSource implements ValueSource
{
    public var root:XML;
    private var _readPrimitivesFromAttributes:Boolean;

    public function XMLValueSource(root:XML, readPrimitivesFromAttributes:Boolean = false)
    {
        this.root = root;
        _readPrimitivesFromAttributes = readPrimitivesFromAttributes;
    }

    public function getPrimitiveValue(key:*):*
    {
        var values:XMLList;
        var expr:String;

        if (_readPrimitivesFromAttributes)
        {
            values = root.attribute(key);
            expr = "@" + key;
        }
        else
        {
            values = root[key];
            expr = key;
        }
        return XMLSourceUtil.assertSingle(values, expr);
    }

    public function getStructuredValue(key:*):*
    {
        return XMLSourceUtil.assertSingle(root[key], key);
    }

    public function get readPrimitivesFromAttributes():Boolean
    {
        return _readPrimitivesFromAttributes;
    }
}
}
