package org.yellcorp.lib.net.batchloader.adapters
{
import org.yellcorp.lib.net.batchloader.adapters.base.BaseURLLoaderItem;

import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;


public class BinaryLoader extends BaseURLLoaderItem
{
    public function BinaryLoader(request:URLRequest)
    {
        super(request);
        urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
    }
}
}
