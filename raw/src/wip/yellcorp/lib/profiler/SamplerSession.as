package wip.yellcorp.lib.profiler
{
import org.yellcorp.lib.core.StringUtil;

import flash.sampler.DeleteObjectSample;
import flash.sampler.NewObjectSample;
import flash.sampler.Sample;
import flash.sampler.StackFrame;
import flash.sampler.getSampleCount;
import flash.sampler.getSamples;
import flash.sampler.startSampling;
import flash.sampler.stopSampling;


public class SamplerSession
{
    private var rootTimeNode:RootSampleTimeNode;

    public function start():void
    {
        trace("SamplerSession.start()");
        startSampling();
    }

    public function stop():void
    {
        trace("SamplerSession.stop()");

        var sampleCount:Number = getSampleCount();
        var sampleSet:Object = getSamples();
        var sample:Sample;
        var ns:NewObjectSample;
        var ds:DeleteObjectSample;
        var lastTime:Number;

//            var maxCount:int = 20;

            rootTimeNode = new RootSampleTimeNode();

            trace('sampleCount: ' + (sampleCount));

            for each (sample in sampleSet)
            {
//                if (i++ > maxCount) break;

                if (isFinite(lastTime))
                {
                    countTime(sample.time - lastTime, sample);

//                    trace('sample.time: ' + (sample.time));

                    if (sample is NewObjectSample)
                    {
                        ns = NewObjectSample(sample);
//                        trace('ns.id: ' + (ns.id));
//                        trace('ns.class: ' + getQualifiedClassName(ns.type));
                    }
                    else if (sample is DeleteObjectSample)
                    {
                        ds = DeleteObjectSample(sample);
//                        trace('ds.id: ' + (ds.id));
//                        trace('ds.size: ' + (ds.size));
                    }

//                    trace('');
                }

                lastTime = sample.time;
            }

            stopSampling();

            traceTime(rootTimeNode);
        }

        private function traceTime(node:SampleTimeNode, recurseDepth:int = 0):void
        {
            var ids:Array = node.childIDs;
            var currentID:*;
            var indent:String = StringUtil.repeat(" ", recurseDepth);
            var i:int;

            trace(indent + "LTime: " + node.totalLocalTime);
            trace(indent + "CTime: " + node.totalCumulativeTime);

            for (i = 0; i < ids.length; i++)
            {
                currentID = ids[i];
                trace(indent + currentID);
                traceTime(node.getChildTime(currentID), recurseDepth + 1);
            }
        }

        private function countTime(timeDiff:Number, sample:Sample):void
        {
            var i:int;
            var stackFrame:StackFrame;

            if (!isFinite(timeDiff))
            {
                throw new ArgumentError("Invalid value for timeDiff: " + timeDiff);
            }
            else if (timeDiff < 0)
            {
                throw new ArgumentError("timeDiff can't be negative");
            }

            if (!sample.stack || sample.stack.length == 0)
            {
                return;
            }

            stackFrame = sample.stack[0];
            rootTimeNode.addStackFrameTime(timeDiff, stackFrame, true);

            for (i = 0; i < sample.stack.length; i++)
            {
                stackFrame = sample.stack[i];
                rootTimeNode.addStackFrameTime(timeDiff, stackFrame, false);
            }
        }
    }
}
