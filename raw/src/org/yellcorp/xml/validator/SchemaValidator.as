package org.yellcorp.xml.validator
{
import org.yellcorp.xml.XMLTraverser;
import org.yellcorp.xml.XMLUtil;
import org.yellcorp.xml.validator.core.AttributeValidator;
import org.yellcorp.xml.validator.core.ContentValidator;
import org.yellcorp.xml.validator.core.RootContentValidator;
import org.yellcorp.xml.validator.core.TagAttributeValidator;
import org.yellcorp.xml.validator.core.UnorderedContentValidator;
import org.yellcorp.xml.validator.core.ValidatorState;
import org.yellcorp.xml.validator.errors.SchemaValidationError;
import org.yellcorp.xml.validator.types.SchemaElement;
import org.yellcorp.xml.validator.utils.Stack;


public class SchemaValidator
{
    private var _schema:SchemaElement;

    private var traverser:XMLTraverser;

    private var stateStack:Stack;
    private var schemaStack:Stack;

    private var currentTag:XML;

    private var _errors:Array;

    public function SchemaValidator(schema:SchemaElement)
    {
        traverser = new XMLTraverser();
        traverser.closeElementHandler = onCloseElement;
        traverser.openElementHandler = onOpenElement;
        traverser.textHandler = onText;

        _schema = schema;
    }

    public function validate(doc:XML):Boolean
    {
        stateStack = new Stack();
        stateStack.push(createRootState(_schema));

        schemaStack = new Stack();

        _errors = [ ];
        traverser.traverse(doc);
        return _errors.length == 0;
    }

    public function get errors():Array
    {
        return _errors.slice();
    }

    private function onOpenElement(node:XML):void
    {
        try {
            stateStack.top.onChildElement(node);
        }
        catch (sve:SchemaValidationError)
        {
            saveError(sve, node.parent());
        }

        var nextSchema:SchemaElement = getChildSchemaNode(node.name());

        schemaStack.push(nextSchema);
        stateStack.push(createState(nextSchema));
        currentTag = node;

        try {
            stateStack.top.onOpenElement(node);
        }
        catch (sve:SchemaValidationError)
        {
            saveError(sve, node);
        }
    }

    private function onCloseElement(node:XML):void
    {
        try {
            stateStack.top.onCloseElement();
        }
        catch (sve:SchemaValidationError)
        {
            saveError(sve, node);
        }
        stateStack.pop();
        schemaStack.pop();
        currentTag = currentTag.parent();
    }

    private function onText(node:XML):void
    {
        stateStack.top.onText(node);
    }

    private function getChildSchemaNode(name:QName):SchemaElement
    {
        var current:SchemaElement = schemaStack.top;
        if (current == null)
        {
            return schemaStack.length == 0 ? _schema : null;
        }
        else
        {
            return current.children.getByName(name);
        }
    }

    private function createState(node:SchemaElement):ValidatorState
    {
        var av:AttributeValidator;
        var cv:ContentValidator;

        if (node)
        {
            av = new TagAttributeValidator(node.attributes);
            cv = new UnorderedContentValidator(node.children);
        }

        return new ValidatorState(node, av, cv);
    }

    private function createRootState(root:SchemaElement):ValidatorState
    {
        return new ValidatorState(null, null, new RootContentValidator(root));
    }

    private function saveError(sve:SchemaValidationError, context:XML):void
    {
        var path:String = context ? XMLUtil.getTagPath(context) : "(root)";
        _errors.push(path + ": " + sve.message);
    }
}
}
