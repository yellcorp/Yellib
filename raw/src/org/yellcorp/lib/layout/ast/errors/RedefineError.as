package org.yellcorp.lib.layout.ast.errors
{
import org.yellcorp.lib.layout.adapters.BaseAdapter;


public class RedefineError extends Error
{
    private var _object:BaseAdapter;
    private var _property:String;

    public function RedefineError(newObject:BaseAdapter, newProperty:String)
    {
        _object = newObject;
        _property = newProperty;
        super("Object/Property combination already defined", 0);
    }

    public function get object():BaseAdapter
    {
        return _object;
    }

    public function get property():String
    {
        return _property;
    }
}
}
