package org.yellcorp.xml.validator.core
{
import org.yellcorp.xml.validator.types.SchemaElement;


public class ValidatorState
{
    private var attribute:AttributeValidator;
    private var content:ContentValidator;

    public function ValidatorState(
        node:SchemaElement,
        attribute:AttributeValidator,
        content:ContentValidator)
    {
        this.attribute = attribute;
        this.content = content;
    }

    public function onOpenElement(node:XML):void
    {
        if (attribute) attribute.validate(node);
    }

    public function onChildElement(node:XML):void
    {
        if (content) content.onChildElement(node);
    }

    public function onCloseElement():void
    {
        if (content) content.onCloseElement();
    }

    public function onText(node:XML):void
    {
        if (content) content.onText(node);
    }
}
}
