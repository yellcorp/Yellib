package org.yellcorp.lib.xml.validator.core
{
import org.yellcorp.lib.xml.validator.errors.AttributeValidationError;
import org.yellcorp.lib.xml.validator.types.SchemaAttribute;
import org.yellcorp.lib.xml.validator.types.SchemaAttributeSet;
import org.yellcorp.lib.xml.validator.utils.QNameCounter;


public class TagAttributeValidator implements AttributeValidator
{
    private var attributes:SchemaAttributeSet;
    private var nameCounter:QNameCounter;

    public function TagAttributeValidator(attributes:SchemaAttributeSet)
    {
        this.attributes = attributes;
    }

    public function validate(node:XML):void
    {
        nameCounter = new QNameCounter();
        countPresent(node);
        checkAbsent();
    }

    private function countPresent(node:XML):void
    {
        var attr:XML;
        var name:QName;

        for each (attr in node.attributes())
        {
            name = attr.name();
            if (attributes.getByName(name))
            {
                nameCounter.inc(name);
            }
            else
            {
                throw new AttributeValidationError("Unexpected attribute " + name);
            }
        }
    }

    private function checkAbsent():void
    {
        var i:int;
        var schemaAttr:SchemaAttribute;

        for (i = 0; i < attributes.length; i++)
        {
            schemaAttr = attributes.getByIndex(i);
            if (schemaAttr.required && nameCounter.getCount(schemaAttr.name) != 1)
            {
                throw new AttributeValidationError("Missing attribute " + schemaAttr.name);
            }
        }
    }
}
}
