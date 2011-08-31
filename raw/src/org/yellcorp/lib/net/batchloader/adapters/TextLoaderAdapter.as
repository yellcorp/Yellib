package org.yellcorp.lib.net.batchloader.adapters
{
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;


public class TextLoaderAdapter extends BaseURLLoaderAdapter
{
    public function TextLoaderAdapter(request:URLRequest)
    {
        var urlLoader:URLLoader = new URLLoader();
        urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
        super(urlLoader, request);
    }

    /**
     * The loaded data as a String.
     */
    public function get text():String
    {
        return urlLoader.data;
    }
}
}
