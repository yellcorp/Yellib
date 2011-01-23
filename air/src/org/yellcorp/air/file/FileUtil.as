package org.yellcorp.air.file
{
import org.yellcorp.binary.ByteUtils;
import org.yellcorp.regexp.RegExpUtil;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;


public class FileUtil
{
    private static var _globMatch:RegExp;
    private static const globCharToRegExp:Object = {
        "**" : ".*",
        "*"  : "[^\\/\\\\]*",
        "?"  : "[^\\/\\\\]",
        "."  : "\\.",
        "/"  : "[\\/\\\\]",
        "\\" : "[\\/\\\\]"
    };

    public static function readXMLFromFile(file:File):XML
    // throws Error, SecurityError, IOError, EOFError, TypeError
    {
        var stream:FileStream;
        var document:XML;

        stream = new FileStream();
        stream.open(file, FileMode.READ);

        try {
            document = ByteUtils.bytesToXML(stream);
        }
        finally
        {
            stream.close();
            stream = null;
        }
        return document;
    }

    public static function writeXMLToFile(file:File, document:XML):void
    // throws SecurityError, IOError
    {
        var stream:FileStream = new FileStream();
        stream.open(file, FileMode.WRITE);

        try {
            stream.writeUTFBytes(document.toXMLString());
        }
        finally
        {
            stream.close();
            stream = null;
        }
    }

    public static function transplant(sourceFile:File, sourceRoot:File, targetRoot:File):File
    {
        var relPath:String;

        relPath = sourceRoot.getRelativePath(sourceFile, false);

        return relPath ? targetRoot.resolvePath(relPath) : null;
    }

    /**
     * Convert DOS/Unix-style glob to RegExp.  Supported metacharacters:
     * *  Match 0 or more non-delimiter characters
     * ?  Match 1 non-delimiter character
     * ** Match 0 or more characters, including delimiters
     *
     * . (full-stop / period) is treated as a literal.
     * / and \ match either path delimiter.
     *
     * All other characters are passed through unchanged and unescaped.
     */
    public static function globToRegExp(glob:String, caseSensitive:Boolean = false):RegExp
    {
        var regExpString:String = glob.replace(getGlobMatch(), subGlobChar);

        return new RegExp(regExpString, caseSensitive ? "" : "i");
    }

    private static function getGlobMatch():RegExp
    {
        if (!_globMatch)
        {
            _globMatch = RegExpUtil.createAlternates(
            [ "**", "*", "?", ".", "/", "\\" ], false, "g");
        }
        return _globMatch;
    }

    private static function subGlobChar(globChar:String, ...rest):String
    {
        return globCharToRegExp[globChar] || globChar;
    }
}
}
