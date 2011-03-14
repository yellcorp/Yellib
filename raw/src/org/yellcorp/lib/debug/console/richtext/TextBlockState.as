package org.yellcorp.lib.debug.console.richtext
{
public class TextBlockState
{
    public var next:TextBlockState;
    public var prev:TextBlockState;

    public var textBlock:TextBlock;
    public var start:int;
    public var length:Number;
    public var dirty:Boolean;
    public var id:String;

    public function TextBlockState(textBlock:TextBlock, id:String)
    {
        this.textBlock = textBlock;
        this.id = id;
        start = 0;
        length = 0;
    }

    public static function insertAfter(reference:TextBlockState, insert:TextBlockState):void
    {
        var following:TextBlockState = reference.next;

        link(reference, insert);
        link(insert, following);
    }

    public static function remove(removeBlock:TextBlockState):void
    {
        var preceding:TextBlockState = removeBlock.prev;
        var following:TextBlockState = removeBlock.next;

        link(preceding, following);

        removeBlock.next = removeBlock.prev = null;
    }

    public static function link(first:TextBlockState, second:TextBlockState):void
    {
        if (first) first.next = second;
        if (second) second.prev = first;
    }
}
}
