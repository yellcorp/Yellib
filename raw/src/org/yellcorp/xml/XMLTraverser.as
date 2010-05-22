package org.yellcorp.xml
{
public class XMLTraverser
{
    private var dispatch:Object;

    public function XMLTraverser()
    {
        dispatch = { };
        dispatch[XMLNodeKind.ELEMENT] = processElement;
        dispatch[XMLNodeKind.TEXT] = processText;
        dispatch[XMLNodeKind.COMMENT] = processComment;
        dispatch[XMLNodeKind.PROCESSING_INSTRUCTION] = processPI;
    }

    protected function traverse(source:XML):void
    {
        var options:XMLOptionState = new XMLOptionState();
        XML.ignoreComments = false;
        XML.ignoreProcessingInstructions = false;
        XML.ignoreWhitespace = false;
        XML.prettyPrinting = false;

        process(source);

        options.restore();
    }

    protected function processOpenElement(node:XML):void
    {
    }

    protected function processCloseElement(node:XML):void
    {
    }

    protected function processText(node:XML):void
    {
    }

    protected function processComment(node:XML):void
    {
    }

    protected function processPI(node:XML):void
    {
    }

    private function process(node:XML):void
    {
        dispatch[node.nodeKind()](node);
    }

    private function processElement(node:XML):void
    {
        var child:XML;
        processOpenElement(node);
        for each (child in node.children())
        {
            process(child);
        }
        processCloseElement(node);
    }
}
}
