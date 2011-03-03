package org.yellcorp.net.multiloader.items
{
import org.yellcorp.events.XMLParseErrorEvent;
import org.yellcorp.net.URLXMLLoader;
import org.yellcorp.net.URLXMLLoaderDataFormat;
import org.yellcorp.net.multiloader.core.BaseURLLoaderItem;

import flash.net.URLLoader;
import flash.net.URLRequest;


public class XMLLoaderItem extends BaseURLLoaderItem
{
    public function XMLLoaderItem(request:URLRequest)
    {
        super(request, URLXMLLoaderDataFormat.XML);
    }
    public function get xmlResponse():XML
    {
        return urlLoader.data;
    }
    protected override function createLoader():URLLoader
    {
        return new URLXMLLoader();
    }
    protected override function addListeners(loader:URLLoader):void
    {
        super.addListeners(loader);
        loader.addEventListener(XMLParseErrorEvent.XML_PARSE_ERROR, onAsyncError);
    }
    protected override function removeListeners(loader:URLLoader):void
    {
        super.removeListeners(loader);
        loader.removeEventListener(XMLParseErrorEvent.XML_PARSE_ERROR, onAsyncError);
    }
}
}
