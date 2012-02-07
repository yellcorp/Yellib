package org.yellcorp.lib.net.batchloader
{
import org.yellcorp.lib.net.batchloader.adapters.BatchLoaderItem;
import org.yellcorp.lib.net.batchloader.adapters.BinaryLoaderItem;
import org.yellcorp.lib.net.batchloader.adapters.BitmapLoaderItem;
import org.yellcorp.lib.net.batchloader.adapters.DisplayLoaderItem;
import org.yellcorp.lib.net.batchloader.adapters.TextLoaderItem;
import org.yellcorp.lib.net.batchloader.adapters.XMLLoaderItem;

import flash.net.URLRequest;


public class DefaultItemFactory implements BatchLoaderItemFactory
{
    public function createItem(request:URLRequest):BatchLoaderItem
    {
        var ext:String = getExtension(request.url);

        switch (ext)
        {
        case "jpg":
        case "jpeg":
        case "gif":
        case "png":
            return new BitmapLoaderItem(request);
        case "swf":
            return new DisplayLoaderItem(request);
        case "xml":
            return new XMLLoaderItem(request);
        case "pbj":
            return new BinaryLoaderItem(request);
        default:
            return new TextLoaderItem(request);
        }
    }

    protected function getExtension(url:String):String
    {
        var qmark:int = url.indexOf("?");
        if (qmark >= 0)
        {
            url = url.slice(0, qmark);
        }
        var lastDot:int = url.lastIndexOf(".");
        if (lastDot >= 0)
        {
            return url.slice(lastDot + 1).toLowerCase();
        }
        else
        {
            return "";
        }
    }
}
}
