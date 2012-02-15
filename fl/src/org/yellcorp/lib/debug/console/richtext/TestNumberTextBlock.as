package org.yellcorp.lib.debug.console.richtext
{
public class TestNumberTextBlock extends TextBlock
{
    private var n:int;

    public function TestNumberTextBlock()
    {
        super();
        n = 0;
    }

    public override function getText():String
    {
        return "+ " + n.toString() + "\n";
    }

    public override function interact(data:Object):void
    {
        n++;
        notifyChange();
    }
}
}
