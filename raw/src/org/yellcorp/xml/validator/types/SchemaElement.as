package org.yellcorp.xml.validator.types
{
import org.yellcorp.math.Range;
import org.yellcorp.string.StringUtil;
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
        count = count.map(castRangeNumber);
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

    private static function castRangeNumber(input:*, i:*, a:*):Number
    {
        var asString:String;
        if (input is Number)
        {
            return input;
        }
        else
        {
            asString = StringUtil.trim(input).toLowerCase();
            switch (asString)
            {
                case "inf" :
                case "infinity" :
                case "+infinity" :
                case "+inf" :
                case "unlimited" :
                case "unbounded" :
                case "number.positive_infinity" :
                case "positive_infinity" :
                    return Number.POSITIVE_INFINITY;
                default :
                    return Number.NaN;
            }
        }

        // compiler complains that a value isn't returned
        return Number.NaN;
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
