package org.yellcorp.xml.validator.types
{
public class SchemaElementSet
{
    private var _byOrder:Array;
    private var _byName:Object;

    public function SchemaElementSet(jsonElementArray:Array)
    {
        clear();
        if (jsonElementArray)
        {
            for (var i:int = 0; i < jsonElementArray.length; i++)
            {
                add(new SchemaElement(jsonElementArray[i]));
            }
        }
    }

    public function clear():void
    {
        _byOrder = [ ];
        _byName = { };
    }

    public function add(element:SchemaElement):void
    {
        if (hasName(element.name))
        {
            throw new ArgumentError("Element '" + element.name + "' already defined");
        }
        else
        {
            _byOrder.push(element);
            _byName[element.name] = element;
        }
    }

    public function get length():int
    {
        return _byOrder.length;
    }

    public function getByIndex(index:int):SchemaElement
    {
        return _byOrder[index];
    }

    public function getByName(name:String):SchemaElement
    {
        return _byName[name];
    }

    public function hasName(name:String):Boolean
    {
        return _byName.hasOwnProperty(name);
    }
}
}
