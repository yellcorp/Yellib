package org.yellcorp.markup.html
{

public class HTMLToken
{
    public static const TEXT:String = "TEXT";
    public static const TAG_OPEN:String = "TAG_OPEN";
    public static const TAG_CLOSE:String = "TAG_CLOSE";
    public static const TAG_EMPTY:String = "TAG_EMPTY";
    public static const CDATA:String = "CDATA";
    public static const COMMENT:String = "COMMENT";
    public static const DECLARATION:String = "DECLARATION";
    public static const PROC_INSTR:String = "PROC_INSTR";

    public var type:String;
    public var name:String;
    public var value:String = "";

    public function HTMLToken() { }

    public function clone():HTMLToken
    {
        var t:HTMLToken = new HTMLToken();
        t.type = type;
        t.name = name;
        t.value = value;
        return t;
    }

    public function toString():String
    {
        return "[HTMLToken type=" + type + " name=" + name +
               " value=\"" + value + "\"]";
    }
}
}
