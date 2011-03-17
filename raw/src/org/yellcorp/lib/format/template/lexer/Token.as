package org.yellcorp.lib.format.template.lexer
{
/**
 * @private
 */
public class Token
{
    public static const TEXT:String = "text";
    public static const OPEN:String = "open";
    public static const CLOSE:String = "close";
    public static const TOGGLE:String = "toggle";
    public static const END:String = "end";

    public var type:String;
    public var text:String;

    public function Token(type:String, text:String = "")
    {
        this.type = type;
        this.text = text;
    }
}
}
