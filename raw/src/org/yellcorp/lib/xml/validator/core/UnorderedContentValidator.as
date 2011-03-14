package org.yellcorp.lib.xml.validator.core
{
import org.yellcorp.lib.core.Range;
import org.yellcorp.lib.xml.validator.errors.ContentValidationError;
import org.yellcorp.lib.xml.validator.types.SchemaElement;
import org.yellcorp.lib.xml.validator.types.SchemaElementSet;
import org.yellcorp.lib.xml.validator.utils.QNameCounter;


public class UnorderedContentValidator implements ContentValidator
{
    private var children:SchemaElementSet;
    private var nameCounter:QNameCounter;

    public function UnorderedContentValidator(children:SchemaElementSet)
    {
        this.children = children;
        nameCounter = new QNameCounter();
    }

    public function onChildElement(node:XML):void
    {
        var name:QName = node.name();

        if (children.getByName(name))
        {
            nameCounter.inc(name);
        }
        else
        {
            throw new ContentValidationError("Unexpected child element " + name);
        }
    }

    public function onText(node:XML):void
    {
    }

    public function onCloseElement():void
    {
        var i:int;
        var schemaElement:SchemaElement;
        var occurrenceRange:Range;
        var actualCount:int;

        for (i = 0; i < children.length; i++)
        {
            schemaElement = children.getByIndex(i);
            occurrenceRange = schemaElement.count;
            actualCount = nameCounter.getCount(schemaElement.name);

            if (!occurrenceRange.contains(actualCount))
            {
                throw new ContentValidationError(
                    "Wrong number of " + schemaElement.name +
                    " elements. Expected " + rangeToString(occurrenceRange) +
                    ", found " + actualCount);
            }
        }
    }

    private static function rangeToString(range:Range):String
    {
        if (range.min == range.max)
        {
            return "exactly " + range.min;
        }
        else if (range.max > 0 && !isFinite(range.max))
        {
            return "at least " + range.min;
        }
        else
        {
            return "between " + range.min + " and " + range.max;
        }
    }
}
}
