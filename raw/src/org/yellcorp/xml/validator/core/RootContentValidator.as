package org.yellcorp.xml.validator.core
{
import org.yellcorp.xml.validator.errors.ContentValidationError;
import org.yellcorp.xml.validator.types.SchemaElement;


public class RootContentValidator implements ContentValidator
{
    private var root:SchemaElement;

    public function RootContentValidator(root:SchemaElement)
    {
        this.root = root;
    }

    public function onChildElement(node:XML):void
    {
        if (node.localName() != root.name)
        {
            throw new ContentValidationError(
                "Root element incorrectly named. Expected " +
                root.name + " got " + node.localName()
            );
        }
    }

    public function onCloseElement():void
    {
    }

    public function onText(node:XML):void
    {
    }
}
}
