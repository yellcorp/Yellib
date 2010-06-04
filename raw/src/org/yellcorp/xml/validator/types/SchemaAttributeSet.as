package org.yellcorp.xml.validator.types
{
public class SchemaAttributeSet
{
    private var _byOrder:Array;
    private var _byName:Object;

    public function SchemaAttributeSet(jsonAttrArray:Array)
    {
        clear();
        if (jsonAttrArray)
        {
            for (var i:int = 0; i < jsonAttrArray.length; i++)
            {
                add(new SchemaAttribute(jsonAttrArray[i]));
            }
        }
    }

    public function clear():void
    {
        _byOrder = [ ];
        _byName = { };
    }

    public function add(attribute:SchemaAttribute):void
    {
        if (hasName(attribute.name))
        {
            throw new ArgumentError("Attribute '" + attribute.name + "' already defined");
        }
        else
        {
            _byOrder.push(attribute);
            _byName[attribute.name] = attribute;
        }
    }

    public function get length():int
    {
        return _byOrder.length;
    }

    public function getByIndex(index:int):SchemaAttribute
    {
        return _byOrder[index];
    }

    public function getByName(name:String):SchemaAttribute
    {
        return _byName[name];
    }

    public function hasName(name:String):Boolean
    {
        return _byName.hasOwnProperty(name);
    }
}
}
