package org.yellcorp.xml
{

public class XMLTraverser
{
    public var openElementHandler:Function = null;
    public var closeElementHandler:Function = null;
    public var textHandler:Function = null;
    public var commentHandler:Function = null;
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
                if (textHandler) textHandler(node);
                break;
            case XMLNodeKind.COMMENT :
                if (commentHandler) commentHandler(node);
                break;
            case XMLNodeKind.PROCESSING_INSTRUCTION :
                if (processingInstructionHandler)
                    processingInstructionHandler(node);
                break;
            default :
                throw new Error("Internal error: Unsupported node");
        }
    }

    private function processElement(node:XML):void
    {
        if (openElementHandler) openElementHandler(node);
        for each (var child:XML in node.children())
        {
            process(child);
        }
        if (closeElementHandler) closeElementHandler(node);
    }
}
}
