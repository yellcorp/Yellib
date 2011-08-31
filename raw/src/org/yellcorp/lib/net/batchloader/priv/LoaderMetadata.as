package org.yellcorp.lib.net.batchloader.priv
{
/**
 * @private
 */
public class LoaderMetadata
{
    public var state:String = LoaderState.WAITING;
    public var estimatedBytesTotal:uint;
    public var httpStatusHistory:Array;
    public var bytesLoaded:uint;
    public var bytesTotal:uint;

    public function get weightedBytesLoaded():Number
    {
        switch (state)
        {
        case LoaderState.WAITING:
        case LoaderState.ERROR:
            return 0;

        case LoaderState.COMPLETE:
            return weightedBytesTotal;

        default:
            if (bytesLoaded == 0)
            {
                return 0;
            }
            else
            {
                return (bytesLoaded * weightedBytesTotal) / bytesTotal;
            }
        }
    }

    public function get weightedBytesTotal():Number
    {
        if (estimatedBytesTotal > 0)
        {
            return estimatedBytesTotal;
        }
        else if (bytesTotal > 0)
        {
            return bytesTotal;
        }
        else
        {
            return Number.NaN;
        }
    }
}
}
