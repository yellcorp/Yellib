package org.yellcorp.lib.net.multiloader
{
public class MultiLoaderErrorPolicy
{
    /**
     * Setting MultiLoader.errorPolicy to ABORT will cause the MultiLoader
     * to stop loading any remaining queued items after the first error.
     */
    public static const ABORT:String = "abort";

    /**
     * Setting MultiLoader.errorPolicy to COMPLETE_ALWAYS will cause the
     * MultiLoader to load all items, even if one or some result in errors.
     * When all items have been accounted for, regardless of success or not,
     * the MultiLoader dispatches a COMPLETE event.
     */
    public static const COMPLETE_ALWAYS:String = "completeAlways";

    /**
     * Setting MultiLoader.errorPolicy to COMPLETE_IF_NO_ERRORS will cause
     * the MultiLoader to load all items, even if one or some result in
     * errors. Only when all items have been successfully loaded, the
     * MultiLoader dispatches a COMPLETE event. If some items resulted in
     * errors, no COMPLETE event is dispatched.
     */
    public static const COMPLETE_IF_NO_ERRORS:String = "completeIfNoErrors";
}
}
