package org.yellcorp.lib.net.batchloader.adapters
{
import org.yellcorp.lib.net.DisplayLoader;
import org.yellcorp.lib.net.LoaderContextFactory;
import org.yellcorp.lib.net.batchloader.adapters.base.BaseNetworkLoaderItem;

import flash.display.Loader;
import flash.net.URLRequest;


public class DisplayLoaderItem extends BaseNetworkLoaderItem implements BatchLoaderItem
{
    private var request:URLRequest;
    private var contextFactory:LoaderContextFactory;
    private var displayLoader:DisplayLoader;

    public function DisplayLoaderItem(request:URLRequest, loaderContextFactory:LoaderContextFactory = null)
    {
        this.request = request;
        this.contextFactory = loaderContextFactory;
        displayLoader = new DisplayLoader(null, loaderContextFactory);
        super(displayLoader);
    }

    public override function dispose():void
    {
        super.dispose();
        displayLoader.dispose();
        displayLoader = null;
    }

    protected override function load():void
    {
        displayLoader.load(request);
    }

    protected override function close():void
    {
        displayLoader.close();
    }

    public function removeDisplayObject():Loader
    {
        return displayLoader.removeDisplayObject();
    }
}
}
