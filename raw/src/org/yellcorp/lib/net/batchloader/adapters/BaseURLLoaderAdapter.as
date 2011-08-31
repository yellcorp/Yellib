package org.yellcorp.lib.net.batchloader.adapters
{
import flash.net.URLLoader;
import flash.net.URLRequest;


internal class BaseURLLoaderAdapter extends CommonLoaderAdapter
{
    protected var urlLoader:URLLoader;
    protected var request:URLRequest;

    public function BaseURLLoaderAdapter(urlLoader:URLLoader, request:URLRequest)
    {
        this.request = request;
        this.urlLoader = urlLoader;
        super(urlLoader);
    }

    public override function start(callback:BatchLoaderCallback):void
    {
        urlLoader.load(request);
        super.start(callback);
    }

    public function cancel():void
    {
    }

    public function dispose():void
    {
        urlLoader = null;
        request = null;
    }

    public function get uri():String
    {
        return request.url;
    }
}
}
