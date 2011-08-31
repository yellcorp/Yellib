package org.yellcorp.lib.net.batchloader.adapters
{
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;


public class BinaryLoaderAdapter extends BaseURLLoaderAdapter
{
    public function BinaryLoaderAdapter(request:URLRequest)
    {
        var urlLoader:URLLoader = new URLLoader();
        urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
        super(urlLoader, request);
    }

    /**
     * The loaded data as a ByteArray.
     */
    public function get data():ByteArray
    {
        return urlLoader.data;
    }
}
}
