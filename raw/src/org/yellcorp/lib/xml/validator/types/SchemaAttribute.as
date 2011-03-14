package org.yellcorp.lib.xml.validator.types
{
import org.yellcorp.lib.xml.validator.utils.NamespacePrefixMap;


public class SchemaAttribute
{
    public var name:QName;
    public var required:Boolean;

    public function SchemaAttribute(jsonSchema:Object, parentNamespaces:NamespacePrefixMap)
    {
        // default namespaces do not apply to attribute names, so create a
        // temporary resolver that cancels out any default prefixes
        var namespaces:NamespacePrefixMap =
            new NamespacePrefixMap({ xmlns: "" }, parentNamespaces);

        name = namespaces.parseName(require(jsonSchema, "name"));
        required = jsonSchema["required"];
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
