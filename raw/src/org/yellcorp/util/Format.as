package org.yellcorp.util {
public class Format {
    public static function formatThousands(value:Number, separator:String = ",", separateWidth:uint = 3):String {
        var inStr:String;
        var char:int;
        var result:String = "";

        inStr = Math.floor(value < 0 ? -value : value).toString();

        char = inStr.length % separateWidth;

        if (char > 0) {
            result = inStr.substr(0, char);
        }

        while (char < inStr.length) {
            if (result.length > 0) {
                result += ",";
            }
            result += inStr.substr(char, separateWidth);
            char += separateWidth;
        }

        return (value < 0) ? ("-" + result) : result;
    }
}
}
