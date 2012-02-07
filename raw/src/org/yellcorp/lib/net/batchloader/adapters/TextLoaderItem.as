package org.yellcorp.lib.net.batchloader.adapters
{
import org.yellcorp.lib.net.batchloader.adapters.base.BaseURLLoaderItem;

import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;


public class TextLoaderItem extends BaseURLLoaderItem
{
    public function TextLoaderItem(request:URLRequest)
    {
        super(request);
        urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
    }

    public function get text():String
    {
        return urlLoader.data;
    }
}
}
