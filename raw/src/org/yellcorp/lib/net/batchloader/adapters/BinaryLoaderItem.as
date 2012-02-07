package org.yellcorp.lib.net.batchloader.adapters
{
import org.yellcorp.lib.net.batchloader.adapters.base.BaseURLLoaderItem;

import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;


public class BinaryLoaderItem extends BaseURLLoaderItem
{
    public function BinaryLoaderItem(request:URLRequest)
    {
        super(request);
        urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
    }

    public function get bytes():ByteArray
    {
        return urlLoader.data;
    }
}
}
