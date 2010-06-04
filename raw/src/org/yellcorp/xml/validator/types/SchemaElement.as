package org.yellcorp.xml.validator.types
{
import org.yellcorp.xml.validator.utils.Range;


public class SchemaElement
{
    public var name:String;
    public var count:Range;
    private var _attributes:SchemaAttributeSet;
    private var _children:SchemaElementSet;

    public function SchemaElement(jsonSchema:Object)
    {
        name = jsonSchema["name"];
        count = toRange(jsonSchema["count"]);

        _attributes = new SchemaAttributeSet(jsonSchema["attributes"]);
        _children = new SchemaElementSet(jsonSchema["children"]);
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
}
}
