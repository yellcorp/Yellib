package org.yellcorp.lib.net.batchloader.adapters
{
import org.yellcorp.lib.events.XMLParseErrorEvent;
import org.yellcorp.lib.net.URLXMLLoader;
import org.yellcorp.lib.net.URLXMLLoaderDataFormat;
import org.yellcorp.lib.net.batchloader.adapters.base.BaseURLLoaderItem;

import flash.net.URLRequest;


public class XMLLoaderItem extends BaseURLLoaderItem
{
    public function XMLLoaderItem(request:URLRequest)
    {
        super(request, new URLXMLLoader());
        urlLoader.dataFormat = URLXMLLoaderDataFormat.XML;
        urlLoader.addEventListener(XMLParseErrorEvent.XML_PARSE_ERROR, onError);
    }

    public override function dispose():void
    {
        urlLoader.removeEventListener(XMLParseErrorEvent.XML_PARSE_ERROR, onError);
        super.dispose();
    }

    public function get xml():XML
    {
        return urlLoader.data;
    }
}
}
