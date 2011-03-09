package org.yellcorp.format.printf.context
{
public class RenderContext
{
    private var args:Array;
    private var implicitCounter:int = 0;
    private var lastIndex:int = -1;

    public function RenderContext(args:Array)
    {
        this.args = args || [ ];
    }

    public function getArgAtIndex(index:int):*
    {
        return getArg(index);
    }

    public function getImplicitArg():*
    {
        return getArg(implicitCounter++);
    }

    public function getLastArg():*
    {
        return getArg(lastIndex);
    }

    private function getArg(index:int):*
    {
        lastIndex = index;
        if (index < 0)
        {
            throw new ContextError("Tried to read from before start of argument list");
        }
        else if (index >= args.length)
        {
            throw new ContextError("Tried to read from beyond end of argument list");
        }
        else
        {
            return args[index];
        }
    }
}
}
