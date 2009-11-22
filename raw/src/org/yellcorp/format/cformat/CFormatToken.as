package org.yellcorp.format.cformat
{
public class CFormatToken
{
    public static const TYPE_DECIMAL_INT:int = 1;
    public static const TYPE_OCTAL_INT:int = 2;
    public static const TYPE_UNSIGNED_INT:int = 3;
    public static const TYPE_HEX_INT:int = 4;
    public static const TYPE_FIX_FLOAT:int = 5;
    public static const TYPE_EXP_FLOAT:int = 6;
    public static const TYPE_VAR_FLOAT:int = 7;
    public static const TYPE_HEX_FLOAT:int = 8;
    public static const TYPE_CHAR:int = 9;
    public static const TYPE_STRING:int = 10;
    //static public const TYPE_POINTER:int = 11;
    //static public const TYPE_NUMCHARS:int = 12;

    public var index:int = -1;

    // '
    public var group:Boolean;

    // 0
    public var zeroPad:Boolean;

    // -
    public var alignLeft:Boolean;

    // + or space
    public var positiveSign:String = "";

    // #
    public var alternateForm:Boolean;

    public var width:int = -1;
    public var widthMeta:Boolean = false;
    public var widthMetaArg:int = -1;

    public var precision:int = -1;
    public var precisionMeta:Boolean = false;
    public var precisionMetaArg:int = -1;

    public var type:int;
    public var caps:Boolean;

    public var literalValue:String;

    public function CFormatToken()
    {
    }
}
}
