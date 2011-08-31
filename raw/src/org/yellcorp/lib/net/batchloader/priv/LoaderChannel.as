package org.yellcorp.lib.net.batchloader.priv
{
import org.yellcorp.lib.net.batchloader.BatchLoader;
import org.yellcorp.lib.net.batchloader.adapters.BatchLoaderAdapter;
import org.yellcorp.lib.net.batchloader.adapters.BatchLoaderCallback;


/**
 * @private
 */
public class LoaderChannel implements BatchLoaderCallback
{
    private var owner:BatchLoader;
    private var loader:BatchLoaderAdapter;

    public function LoaderChannel(owner:BatchLoader, loader:BatchLoaderAdapter)
    {
        this.owner = owner;
        this.loader = loader;
    }

    public function complete():void
    {
        owner.bl_internal::loaderComplete(loader);
    }

    public function httpStatus(statusCode:int):void
    {
        owner.bl_internal::loaderStatus(loader, statusCode);
    }

    public function progress(bytesLoaded:uint, bytesTotal:uint):void
    {
        owner.bl_internal::loaderProgress(loader, bytesLoaded, bytesTotal);
    }

    public function error(error:*):void
    {
        owner.bl_internal::loaderError(loader, error);
    }
}
}
