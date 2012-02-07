package org.yellcorp.lib.net.batchloader.adapters
{
import org.yellcorp.lib.net.BitmapLoader;
import org.yellcorp.lib.net.LoaderContextFactory;
import org.yellcorp.lib.net.batchloader.adapters.base.BaseNetworkLoaderItem;

import flash.display.BitmapData;
import flash.net.URLRequest;


public class BitmapLoaderItem extends BaseNetworkLoaderItem implements BatchLoaderItem
{
    private var request:URLRequest;
    private var contextFactory:LoaderContextFactory;
    private var bitmapLoader:BitmapLoader;

    public function BitmapLoaderItem(request:URLRequest, loaderContextFactory:LoaderContextFactory = null)
    {
        this.request = request;
        this.contextFactory = loaderContextFactory;
        bitmapLoader = new BitmapLoader(null, loaderContextFactory);
        super(bitmapLoader);
    }

    public override function dispose():void
    {
        super.dispose();
        bitmapLoader.dispose();
        bitmapLoader = null;
    }

    protected override function load():void
    {
        bitmapLoader.load(request);
    }

    protected override function close():void
    {
        bitmapLoader.close();
    }

    public function copyBitmapData():BitmapData
    {
        return bitmapLoader.copyBitmapData();
    }
}
}
