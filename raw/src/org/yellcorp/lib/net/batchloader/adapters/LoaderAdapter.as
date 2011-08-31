package org.yellcorp.lib.net.batchloader.adapters
{
import flash.display.Loader;
import flash.net.URLRequest;
import flash.system.LoaderContext;


public class LoaderAdapter extends CommonLoaderAdapter implements BatchLoaderAdapter
{
    private var _loader:Loader;

    private var request:URLRequest;
    private var context:LoaderContext;

    public function LoaderAdapter()
    {
        _loader = new Loader();
        super(_loader.contentLoaderInfo);
    }

    public override function start(callback:BatchLoaderCallback):void
    {
        _loader.load(request, context);
        super.start(callback);
    }

    public function cancel():void
    {
    }

    public function dispose():void
    {
        _loader = null;
        request = null;
        context = null;
    }

    public function get uri():String
    {
        return request.url;
    }

    public function get loader():Loader
    {
        return _loader;
    }
}
}
