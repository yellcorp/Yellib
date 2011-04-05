package org.yellcorp.lib.events.sequence
{
public class AsyncSequence
{
    private var currentItem:int;
    private var sequence:Array;

    public function AsyncSequence()
    {
        sequence = [];
        currentItem = 0;
    }

    public function run():void
    {
        currentItem = 0;
        runCurrent();
    }

    public function push(item:EditableAsyncItem):void
    {
        item.owner = this;
        sequence.push(item);
    }

    internal function next():void
    {
        currentItem++;
        runCurrent();
    }

    internal function cancel():void
    {
        // TODO
    }

    private function runCurrent():void
    {
        var item:AsyncItem;

        if (currentItem >= sequence.length)
        {
            // TODO: complete
        }
        else
        {
            item = sequence[currentItem];
            item.run();
        }
    }
}
}
