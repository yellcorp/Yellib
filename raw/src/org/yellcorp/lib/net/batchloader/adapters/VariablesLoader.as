package org.yellcorp.lib.net.batchloader.adapters
{
import org.yellcorp.lib.net.batchloader.adapters.base.BaseURLLoaderItem;

import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;


public class VariablesLoader extends BaseURLLoaderItem
{
    public function VariablesLoader(request:URLRequest)
    {
        super(request);
        urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
    }
}
}
