package org.yellcorp.lib.xml.validator.types
{
import org.yellcorp.lib.collections.QNameMap;
import org.yellcorp.lib.xml.validator.utils.NamespacePrefixMap;


public class SchemaAttributeSet
{
    private var _byOrder:Array;
    private var _byName:QNameMap;

    public function SchemaAttributeSet(jsonAttrArray:Array, parentNamespaces:NamespacePrefixMap)
    {
        clear();
        if (jsonAttrArray)
        {
            for (var i:int = 0; i < jsonAttrArray.length; i++)
            {
                add(new SchemaAttribute(jsonAttrArray[i], parentNamespaces));
            }
        }
    }

    public function clear():void
    {
        _byOrder = [ ];
        _byName = new QNameMap();
    }

    public function add(attribute:SchemaAttribute):void
    {
        if (_byName[attribute.name])
        {
            throw new ArgumentError("Attribute '" + attribute.name + "' already defined");
        }
        else
        {
            _byOrder.push(attribute);
            _byName[attribute.name] = attribute;
        }
    }

    public function get length():int
    {
        return _byOrder.length;
    }

    public function getByIndex(index:int):SchemaAttribute
    {
        return _byOrder[index];
    }

    public function getByName(name:QName):SchemaAttribute
    {
        return _byName[name];
    }
}
}
