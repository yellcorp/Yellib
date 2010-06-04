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
        // note: QNames do non-strict equality comparison (==) by value.
        // So different instances of a QName with the same URIs and
        // localNames are true for == and false for ===
        if (node.name() != root.name)
        {
            throw new ContentValidationError(
                "Root element incorrectly named. Expected " +
                root.name + " got " + node.name()
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
