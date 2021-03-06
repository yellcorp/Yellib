package org.yellcorp.lib.xml.validator.types
{
import org.yellcorp.lib.collections.QNameMap;
import org.yellcorp.lib.xml.validator.utils.NamespacePrefixMap;


public class SchemaElementSet
{
    private var _byOrder:Array;
    private var _byName:QNameMap;

    public function SchemaElementSet(jsonElementArray:Array, parentNamespaces:NamespacePrefixMap)
    {
        clear();
        if (jsonElementArray)
        {
            for (var i:int = 0; i < jsonElementArray.length; i++)
            {
                add(new SchemaElement(jsonElementArray[i], parentNamespaces));
            }
        }
    }

    public function clear():void
    {
        _byOrder = [ ];
        _byName = new QNameMap();
    }

    public function add(element:SchemaElement):void
    {
        if (_byName[element.name])
        {
            throw new ArgumentError("Element '" + element.name + "' already defined");
        }
        else
        {
            _byOrder.push(element);
            _byName[element.name] = element;
        }
    }

    public function get length():int
    {
        return _byOrder.length;
    }

    public function getByIndex(index:int):SchemaElement
    {
        return _byOrder[index];
    }

    public function getByName(name:QName):SchemaElement
    {
        return _byName[name];
    }
}
}
