package org.yellcorp.net.multiloader
{
public class MultiLoaderOrder
{
    /**
     * Setting MultiLoader.order to FIFO will load items in the order they
     * were added.
     */
    public static const FIFO:String = "fifo";

    /**
     * Setting MultiLoader.order to LIFO will load items in reverse to the
     * order they were added.
     */
    public static const LIFO:String = "lifo";
}
}
