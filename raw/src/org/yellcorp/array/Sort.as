package org.yellcorp.array {

public class Sort {
    private static const STOP_WORDS:String = "a an the";
    private static var stopWordsRegex:RegExp;

    public static function cmpString(a:String, b:String):int {
        return a.localeCompare(b);
    }

    public static function cmpStringNoCase(a:String, b:String):int {
        return a.toLocaleLowerCase().localeCompare(b.toLocaleLowerCase());
    }

    public static function cmpStringNatural(a:String, b:String):int {
        if (!stopWordsRegex) {
            stopWordsRegex = makeStopWordRegex(STOP_WORDS.split(" "));
        }
        return cmpStringNoCase(a.replace(stopWordsRegex, ""), b.replace(stopWordsRegex, ""));
    }

    public static function cmpInt(a:int, b:int):int {
        if (a < b) {
            return -1;
        } else if (a > b) {
            return 1;
        } else {
            return 0;
        }
    }

    public static function cmpUint(a:uint, b:uint):int {
        if (a < b) {
            return -1;
        } else if (a > b) {
            return 1;
        } else {
            return 0;
        }
    }

    public static function cmpNumber(a:Number, b:Number):int {
        if (a < b) {
            return -1;
        } else if (a > b) {
            return 1;
        } else {
            return 0;
        }
    }

    public static function cmpDate(a:Date, b:Date):int {
        if (a.time < b.time) {
            return -1;
        } else if (a.time > b.time) {
            return 1;
        } else {
            return 0;
        }
    }

    private static function makeStopWordRegex(stopWordArray:Array):RegExp {
        var word:String;
        var buildRegex:String = "";

        for each (word in stopWordArray) {
            if (buildRegex.length > 0) buildRegex += "|";
            buildRegex += "^" + word + "\\s";
        }

        return new RegExp(buildRegex, "i");
    }
}
}
