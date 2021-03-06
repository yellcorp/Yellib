package org.yellcorp.lib.xml
{
public class XMLUtil
{
    /**
     * Converts XML to String with temporary XML formatting properties,
     * preserving the global ones
     */
    public static function xmlToString(xml:XML, prettyPrint:Boolean, indentWidth:int = -1):String
    {
        var oldIndent:int = XML.prettyIndent;
        var oldPP:Boolean = XML.prettyPrinting;
        var string:String;

        XML.prettyPrinting = prettyPrint;
        if (indentWidth < 0)
        {
            string = xml.toXMLString();
        }
        else
        {
            XML.prettyIndent = indentWidth;
            string = xml.toXMLString();
            XML.prettyIndent = oldIndent;
        }
        XML.prettyPrinting = oldPP;

        return string;
    }

    public static function getTagPath(tag:XML):String
    {
        var names:Array = [ ];
        var index:int;
        var nodeName:String;
        while (tag)
        {
            nodeName = String(tag.name());
            index = tag.childIndex();
            if (index >= 0) nodeName += "[" + index + "]";
            names.push(nodeName);
            tag = tag.parent();
        }
        return names.reverse().join("/");
    }
}
}
