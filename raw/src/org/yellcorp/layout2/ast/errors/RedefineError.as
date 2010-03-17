package org.yellcorp.layout2.ast.errors
{
import org.yellcorp.layout2.adapters.BaseAdapter;


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
