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
        return getCurrentArg();
    }

    public function getAbsoluteIndexArg(position:int):*
    {
        index = position;
        return args[index++];
    }

    private function getCurrentArg():*
    {
        if (index < 0)
        {
            throw new RangeError("Tried to read from before start of argument list");
        }
        else if (index >= args.length)
        {
            throw new RangeError("Tried to read from beyond end of argument list");
        }
        else
        {
            return args[index++];
        }
    }
}
}
