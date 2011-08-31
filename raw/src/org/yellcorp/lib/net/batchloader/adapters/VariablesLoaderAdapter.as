package org.yellcorp.lib.net.batchloader.adapters
{
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLVariables;


public class VariablesLoaderAdapter extends BaseURLLoaderAdapter
{
    public function VariablesLoaderAdapter(request:URLRequest)
    {
        var urlLoader:URLLoader = new URLLoader();
        urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
        super(urlLoader, request);
    }

    public function get variables():URLVariables
    {
        return urlLoader.data;
    }
}
}
