package org.yellcorp.lib.net.batchloader.adapters
{
import org.yellcorp.lib.net.batchloader.adapters.base.BaseURLLoaderItem;

import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLVariables;


public class VariablesLoaderItem extends BaseURLLoaderItem
{
    public function VariablesLoaderItem(request:URLRequest)
    {
        super(request);
        urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
    }

    public function get variables():URLVariables
    {
        return urlLoader.data;
    }
}
}
