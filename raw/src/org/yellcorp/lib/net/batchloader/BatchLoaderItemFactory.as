package org.yellcorp.lib.net.batchloader
{
import org.yellcorp.lib.net.batchloader.adapters.BatchLoaderItem;

import flash.net.URLRequest;


public interface BatchLoaderItemFactory
{
    function createItem(request:URLRequest):BatchLoaderItem;
}
}
