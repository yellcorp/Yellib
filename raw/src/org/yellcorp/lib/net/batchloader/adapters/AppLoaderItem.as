package org.yellcorp.lib.net.batchloader.adapters
{
import org.yellcorp.lib.net.batchloader.adapters.base.BaseNetworkLoaderItem;

import flash.display.LoaderInfo;


public class AppLoaderItem extends BaseNetworkLoaderItem implements BatchLoaderItem
{
    public function AppLoaderItem(rootLoaderInfo:LoaderInfo)
    {
        super(rootLoaderInfo);
    }

    protected override function isFullyLoaded():Boolean
    {
        var loaderInfo:LoaderInfo = LoaderInfo(netLoader);
        return loaderInfo.bytesTotal > 0 &&
               loaderInfo.bytesLoaded == loaderInfo.bytesTotal;
    }

    protected override function load():void
    {
        // no-op: assuming item is already loading
    }

    protected override function close():void
    {
        // no-op
    }
}
}
