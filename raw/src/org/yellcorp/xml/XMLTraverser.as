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
        dispatch[XMLNodeKind.PROCESSING_INSTRUCTION] = processProcInstr;
    }

    public function traverse(source:XML):void
    {
        var options:XMLOptionState = new XMLOptionState();
        XML.ignoreComments = false;
        XML.ignoreProcessingInstructions = false;
        XML.ignoreWhitespace = false;
        XML.prettyPrinting = false;

        process(source);

        options.restore();
    }

    protected function openElement(node:XML):void
    {
    }

    protected function closeElement(node:XML):void
    {
    }

    protected function processText(node:XML):void
    {
    }

    protected function processComment(node:XML):void
    {
    }

    protected function processProcInstr(node:XML):void
    {
    }

    private function process(node:XML):void
    {
        dispatch[node.nodeKind()](node);
    }

    private function processElement(node:XML):void
    {
        var child:XML;
        openElement(node);
        for each (child in node.children())
        {
            process(child);
        }
        closeElement(node);
    }
}
}
