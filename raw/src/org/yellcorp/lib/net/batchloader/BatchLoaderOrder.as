package org.yellcorp.lib.net.batchloader
{
public class BatchLoaderOrder
{
    /**
     * Setting BatchLoader.order to FIFO will load items in the order they
     * were added.
     */
    public static const FIFO:String = "fifo";

    /**
     * Setting BatchLoader.order to LIFO will load items in reverse to the
     * order they were added.
     */
    public static const LIFO:String = "lifo";
}
}
