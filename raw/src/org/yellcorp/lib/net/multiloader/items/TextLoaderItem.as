package org.yellcorp.lib.net.multiloader.items
{
import org.yellcorp.lib.net.multiloader.core.BaseURLLoaderItem;

import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;


public class TextLoaderItem extends BaseURLLoaderItem
{
    public function TextLoaderItem(request:URLRequest)
    {
        super(request, URLLoaderDataFormat.TEXT);
    }
    public function get textResponse():String
    {
        return urlLoader.data;
    }
}
}