package org.yellcorp.format.printf.context
{
public class RenderContext
{
    private var args:Array;
    private var index:Number;

    public function RenderContext(args:Array)
    {
        this.args = args;
    }

    public function getRelativeIndexArg(offset:int):*
    {
        index += offset;
        return args[index++];
    }

    public function getAbsoluteIndexArg(position:int):*
    {
        index = position;
        return args[index++];
    }
}
}
