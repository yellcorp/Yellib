package org.yellcorp.lib.xml
{
/**
 * Walks an XML tree in document order, optionally calling handlers for
 * each type of node.
 */
public class XMLTraverser
{
    /**
     * A function that will be called when an opening tag is encountered.
     * Should take one parameter of type XML.
     */
    public var openElementHandler:Function = null;

    /**
     * A function that will be called when a closing tag is encountered.
     * Should take one parameter of type XML.
     */
    public var closeElementHandler:Function = null;

    /**
     * A function that will be called when a text node is encountered.
     * Should take one parameter of type XML.
     */
    public var textHandler:Function = null;

    /**
     * A function that will be called when a comment node is encountered.
     * Should take one parameter of type XML.
     */
    public var commentHandler:Function = null;

    /**
     * A function that will be called when a processing instruction node is
     * encountered.  Should take one parameter of type XML.
     */
    public var processingInstructionHandler:Function = null;

    public function XMLTraverser() { }

    public function traverse(source:XML):void
    {
        var options:XMLOptionState = new XMLOptionState();
        XML.ignoreComments = commentHandler === null;
        XML.ignoreProcessingInstructions = processingInstructionHandler === null;
        XML.ignoreWhitespace = false;
        XML.prettyPrinting = false;

        process(source);

        options.restore();
    }

    private function process(node:XML):void
    {
        switch (node.nodeKind())
        {
        case XMLNodeKind.ELEMENT :
            processElement(node);
            break;

        case XMLNodeKind.TEXT :
            if (Boolean(textHandler)) textHandler(node);
            break;

        case XMLNodeKind.COMMENT :
            if (Boolean(commentHandler)) commentHandler(node);
            break;

        case XMLNodeKind.PROCESSING_INSTRUCTION :
            if (Boolean(processingInstructionHandler))
                processingInstructionHandler(node);
            break;

        default :
            throw new Error("Internal error: Unsupported node");
        }
    }

    private function processElement(node:XML):void
    {
        if (Boolean(openElementHandler)) openElementHandler(node);
        for each (var child:XML in node.children())
        {
            process(child);
        }
        if (Boolean(closeElementHandler)) closeElementHandler(node);
    }
}
}
