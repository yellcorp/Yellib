package org.yellcorp.lib.layout_old.ast.errors
{
public class PropertyError extends Error
{
    private var _property:String;

    public function PropertyError(newProperty:String)
    {
        super("Unsupported property: " + newProperty);
        _property = newProperty;
    }
    public function get property():String
    {
        return _property;
    }
}
}
