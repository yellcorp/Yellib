package org.yellcorp.net.multiloader.items
{
import org.yellcorp.net.multiloader.core.BaseURLLoaderItem;

import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;


public class BinaryLoaderItem extends BaseURLLoaderItem
{
    public function BinaryLoaderItem(request:URLRequest)
    {
        super(request, URLLoaderDataFormat.BINARY);
    }
    public function binaryResponse():ByteArray
    {
        return urlLoader.data;
    }
}
}
