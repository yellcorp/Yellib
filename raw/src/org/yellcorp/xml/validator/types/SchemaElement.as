package org.yellcorp.xml.validator.types
{
import org.yellcorp.xml.validator.utils.NamespacePrefixMap;
import org.yellcorp.xml.validator.utils.Range;


public class SchemaElement
{
    public var name:QName;
    public var count:Range;
    private var _attributes:SchemaAttributeSet;
    private var _children:SchemaElementSet;
    private var namespaces:NamespacePrefixMap;

    public function SchemaElement(jsonSchema:Object, parentNamespaces:NamespacePrefixMap = null)
    {
        namespaces = joinNSMaps(jsonSchema["namespaces"], parentNamespaces);
        name = namespaces.parseName(require(jsonSchema, "name"));
        count = toRange(require(jsonSchema, "count"));

        _attributes = new SchemaAttributeSet(jsonSchema["attributes"], namespaces);
        _children = new SchemaElementSet(jsonSchema["children"], namespaces);
    }

    public function get attributes():SchemaAttributeSet
    {
        return _attributes;
    }

    public function get children():SchemaElementSet
    {
        return _children;
    }

    private static function toRange(count:Array):Range
    {
        if (count.length == 1)
        {
            return new Range(count[0], count[0]);
        }
        else if (count.length == 2)
        {
            return new Range(count[0], count[1]);
        }
        else
        {
            throw ArgumentError("Bad range element count");
        }
    }

    private static function joinNSMaps(nsPrefixMap:*, parentNamespaces:NamespacePrefixMap):NamespacePrefixMap
    {
        if (!nsPrefixMap && parentNamespaces)
        {
            return parentNamespaces;
        }
        else
        {
            return new NamespacePrefixMap(nsPrefixMap, parentNamespaces);
        }
    }

    private static function require(map:Object, property:String):*
    {
        if (!map.hasOwnProperty(property))
        {
            throw new ArgumentError("Missing required property '" + property + "'");
        }
        return map[property];
    }
}
}
