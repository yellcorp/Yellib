package org.yellcorp.xml.validator.types
{
import org.yellcorp.math.Range;
import org.yellcorp.xml.validator.utils.NamespacePrefixMap;


public class SchemaElement
{
    public var name:QName;
    public var count:Range;
    private var _attributes:SchemaAttributeSet;
    private var _children:SchemaElementSet;
    private var namespaces:NamespacePrefixMap;
    private var _anyChildren:Boolean;

    public function SchemaElement(jsonSchema:Object, parentNamespaces:NamespacePrefixMap = null)
    {
        namespaces = joinNSMaps(jsonSchema["namespaces"], parentNamespaces);
        name = namespaces.parseName(require(jsonSchema, "name"));
        count = toRange(require(jsonSchema, "count"));

        _anyChildren = jsonSchema["any_children"];
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

    public function get anyChildren():Boolean
    {
        return _anyChildren;
    }

    private static function toRange(count:Array):Range
    {
        if (count.length == 1)
        {
            return new Range(count[0], count[0], true, true);
        }
        else if (count.length == 2)
        {
            return new Range(count[0], count[1], true, true);
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
