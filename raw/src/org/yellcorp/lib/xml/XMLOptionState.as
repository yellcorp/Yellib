package org.yellcorp.lib.xml
{
public class XMLOptionState
{
    private var ignoreComments:Boolean;
    private var ignoreProcessingInstructions:Boolean;
    private var ignoreWhitespace:Boolean;
    private var prettyIndent:int;
    private var prettyPrinting:Boolean;

    public function XMLOptionState()
    {
        ignoreComments = XML.ignoreComments;
        ignoreProcessingInstructions = XML.ignoreProcessingInstructions;
        ignoreWhitespace = XML.ignoreWhitespace;
        prettyIndent = XML.prettyIndent;
        prettyPrinting = XML.prettyPrinting;
    }

    public function restore():void
    {
        XML.ignoreComments = ignoreComments;
        XML.ignoreProcessingInstructions = ignoreProcessingInstructions;
        XML.ignoreWhitespace = ignoreWhitespace;
        XML.prettyIndent = prettyIndent;
        XML.prettyPrinting = prettyPrinting;
    }
}
}
