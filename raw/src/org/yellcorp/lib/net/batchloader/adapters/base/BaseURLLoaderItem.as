package org.yellcorp.lib.net.batchloader.adapters.base
{
import org.yellcorp.lib.net.batchloader.adapters.BatchLoaderItem;

import flash.net.URLLoader;
import flash.net.URLRequest;


public class BaseURLLoaderItem extends BaseNetworkLoaderItem implements BatchLoaderItem
{
    protected var request:URLRequest;
    protected var urlLoader:URLLoader;

    public function BaseURLLoaderItem(request:URLRequest, urlLoader:URLLoader = null)
    {
        this.urlLoader = urlLoader || new URLLoader();
        this.request = request;
        super(this.urlLoader);
    }

    public override function dispose():void
    {
        super.dispose();
        this.urlLoader = null;
        this.request = null;
    }

    protected override function load():void
    {
        urlLoader.load(request);
    }

    protected override function close():void
    {
        urlLoader.close();
    }
}
}
