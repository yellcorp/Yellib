package org.yellcorp.xml.validator.types
{
public class SchemaAttribute
{
    public var name:String;
    public var required:Boolean;

    public function SchemaAttribute(jsonSchema:Object)
    {
        name = jsonSchema["name"];
        required = jsonSchema["required"];
    }
}
}
