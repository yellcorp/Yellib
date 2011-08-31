package org.yellcorp.lib.net.batchloader.adapters
{
import org.yellcorp.lib.net.URLXMLLoader;
import org.yellcorp.lib.net.URLXMLLoaderDataFormat;

import flash.net.URLLoader;
import flash.net.URLRequest;


public class XMLLoaderAdapter extends BaseURLLoaderAdapter
{
    public function XMLLoaderAdapter(request:URLRequest)
    {
        var urlLoader:URLLoader = new URLXMLLoader();
        urlLoader.dataFormat = URLXMLLoaderDataFormat.XML;
        super(urlLoader, request);
    }

    public function get xml():XML
    {
        return urlLoader.data;
    }
}
}
