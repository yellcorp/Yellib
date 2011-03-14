package org.yellcorp.lib.net.multiloader.items
{
import org.yellcorp.lib.net.multiloader.core.BaseURLLoaderItem;

import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;


/**
 * Used with MultiLoader to download a binary file from a URL. This is
 * implemented as a URLLoader with its dataFormat property set to
 * URLLoaderDataFormat.BINARY.
 */
public class BinaryLoaderItem extends BaseURLLoaderItem
{
    /**
     * Creates a BinaryLoaderItem which will make the specified request
     * when it starts loading.
     *
     * @param request The request to issue and download from.
     */
    public function BinaryLoaderItem(request:URLRequest)
    {
        super(request, URLLoaderDataFormat.BINARY);
    }

    /**
     * The loaded data as a ByteArray.
     */
    public function get binaryResponse():ByteArray
    {
        return urlLoader.data;
    }
}
}
