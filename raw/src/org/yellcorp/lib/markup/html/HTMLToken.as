package org.yellcorp.lib.markup.html
{
/**
 * @private
 */
public class HTMLToken
{
    public static const TEXT:String = "TEXT";

    public static const TAG_OPEN_START:String = "TAG_OPEN_START";
    public static const TAG_ATTR:String = "TAG_ATTR";
    public static const TAG_OPEN_END:String = "TAG_OPEN_END";
    public static const TAG_OPEN_END_CLOSE:String = "TAG_OPEN_END_CLOSE";

    public static const TAG_CLOSE:String = "TAG_CLOSE";
    public static const CDATA:String = "CDATA";
    public static const COMMENT:String = "COMMENT";
    public static const DECLARATION:String = "DECLARATION";
    public static const PROC_INSTR:String = "PROC_INSTR";

    public var type:String;
    public var name:String = "";
    public var value:String = "";
    public var text:String = "";

    public function HTMLToken() { }

    public function clone():HTMLToken
    {
        var t:HTMLToken = new HTMLToken();
        t.type = type;
        t.name = name;
        t.value = value;
        t.text = text;
        return t;
    }

    public function toString():String
    {
        return "[HTMLToken" +
               " type=" + type +
               " name=" + name +
               " value=" + value +
               " text=\"" + text + "\"]";
    }
}
}
