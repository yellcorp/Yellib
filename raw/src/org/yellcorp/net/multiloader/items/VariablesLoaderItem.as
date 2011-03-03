package org.yellcorp.net.multiloader.items
{
import org.yellcorp.net.multiloader.core.BaseURLLoaderItem;

import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLVariables;


public class VariablesLoaderItem extends BaseURLLoaderItem
{
    public function VariablesLoaderItem(request:URLRequest)
    {
        super(request, URLLoaderDataFormat.VARIABLES);
    }
    public function get variablesResponse():URLVariables
    {
        return urlLoader.data;
    }
}
}
