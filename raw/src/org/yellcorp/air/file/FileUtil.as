package org.yellcorp.air.file
{
import org.yellcorp.binary.ByteUtils;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;


public class FileUtil
{
    public static function readXMLFromFile(file:File):XML
    // throws Error, SecurityError, IOError, EOFError, TypeError
    {
        var stream:FileStream;
        var xml:XML;

        stream = new FileStream();
        stream.open(file, FileMode.READ);

        try {
            xml = ByteUtils.bytesToXML(stream);
        }
        finally
        {
            stream.close();
            stream = null;
        }
        return xml;
    }
}
}
