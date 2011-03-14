package wip.yellcorp.lib.profiler
{
import flash.sampler.StackFrame;


public class RootSampleTimeNode extends SampleTimeNode
{
    public function RootSampleTimeNode()
    {
        super(null);
    }

    public function addStackFrameTime(usec:Number, stackFrame:StackFrame, trueForLocal:Boolean):void
    {
        var path:Array;

        if (stackFrame.file === null)
        {
            path = [ "[none]", stackFrame.name ];
        }
        else
        {
            path = [ stackFrame.file, stackFrame.name, stackFrame.line ];
        }

        addTime(usec, path, trueForLocal);
    }
}
}
