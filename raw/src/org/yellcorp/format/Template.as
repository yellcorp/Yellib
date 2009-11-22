package org.yellcorp.format
{
public class Template
{
    public static function format(template:String, values:Object = null,
                                  notFoundValue:String = "",
                                  open:String = "{", close:String = "}"):String
    {
        var result:String = "";
        var pointer:int = 0;
        var openPos:int;
        var closePos:int;
        var templateExpr:String;
        var len:int;
        var error:String;

        // close delims don't need to be escaped but
        // it's intuitive so allow it
        template = template.replace(close + close, close);
        len = template.length;

        while (pointer < len)
        {
            openPos = template.indexOf(open, pointer);

            if (openPos < 0)
            {
                result += template.substr(pointer);
                pointer = len;
                continue;
            }
            else if (openPos > pointer)
            {
                result += template.substring(pointer, openPos);
            }

            if (template.charAt(openPos + 1) == open)
            {
                result += open;
                pointer = openPos + 2;
                continue;
            }

            closePos = template.indexOf(close, openPos + 1);
            if (closePos < 0)
            {
                error = formatError("format", "Unmatched " + open, openPos);
                pointer = openPos + 1;
                result += open;
                trace(error);
                continue;
                //throw new ArgumentError(error);
            }

            templateExpr = template.substring(openPos + 1, closePos);

            result += evaluate(templateExpr, values, notFoundValue);

            pointer = closePos + 1;
        }

        return result;
    }

    private static function evaluate(expr:String, values:Object, notFoundValue:String):String
    {
        var i:int;
        var acc:Object = values;
        var path:Array = expr.split(".");
        var name:String;

        for (i = 0; i < path.length; i++)
        {
            if (acc == null) break;

            name = path[i];
            if (isPositiveInt(name))
            {
                acc = acc[parseInt(name)];
            }
            else
            {
                acc = acc[name];
            }
        }

        if (acc == null)
        {
            return notFoundValue;
        }
        else if (acc is String)
        {
            return acc as String;
        }
        else if (acc.toString)
        {
            return acc.toString();
        }
        else
        {
            return String(acc);
        }
    }

    private static function isPositiveInt(test:String):Boolean
    {
        var code:Number;
        var i:int;

        for (i = 0; i < test.length; i++)
        {
            code = test.charCodeAt(i);
            if (code < 0x30 || code > 0x39) return false;
        }
        return true;
    }

    private static function formatError(funcName:String, userMessage:String,
                                        fromChar:int = -1, toChar:int = -1,
                                        source:String = null):String
    {
        var str:String = "Template." + funcName + ": " + userMessage;

        if (fromChar >= 0)
        {
            if (toChar >= 0)
            {
                str += " from " + fromChar +
                       " to " + toChar;
                if (source)
                {
                    str += ' "' + source.substring(fromChar, toChar) + '"';
                }
            }
            else
            {
                str += " at " + fromChar;
            }
        }

        return str;
    }
}
}
