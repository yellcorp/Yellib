package org.yellcorp.debug.console.richtext
{
public class TestExpandBlock extends TextBlock
{
    private var expanded:Boolean;

    public function TestExpandBlock()
    {
        super();
    }

    public override function getText():String
    {
        return expanded ? "- Here is the full text, wow\nAnd another!\n" : "+ more...\n";
    }

    public override function interact(data:Object):void
    {
        expanded = !expanded;
        notifyChange();
    }
}
}
