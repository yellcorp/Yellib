package org.yellcorp.lib.net.batchloader.adapters
{
import org.yellcorp.lib.net.batchloader.adapters.base.BaseURLLoaderItem;

import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;


public class TextLoader extends BaseURLLoaderItem
{
    public function TextLoader(request:URLRequest)
    {
        super(request);
        urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
    }
}
}
