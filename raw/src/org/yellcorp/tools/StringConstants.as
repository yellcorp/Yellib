package org.yellcorp.tools
{
import org.yellcorp.lib.format.template.Template;
import org.yellcorp.lib.string.StringLiteral;


public class StringConstants
{
    private static const constForm:RegExp = /^[A-Z0-9_]+$/;

    private static const tokenizer:RegExp =
        /([A-Z]+)|([a-z]+)|([0-9]+)/g;

    private static const declaration:Template =
        new Template("public static const {0}:String = {1};");

    public static function valuesToCode(values:Array):Array
    {
        return nameTableToCode(generateNames(values));
    }

    public static function nameTableToCode(namesToValues:Object):Array
    {
        var lines:Array = [ ];
        var keys:Array = [ ];
        var k:String;

        for (k in namesToValues)
        {
            keys.push(k);
        }
        keys.sort();

        for each (k in keys)
        {
            lines.push(formatDeclaration(k, namesToValues[k]));
        }
        return lines;
    }

    public static function formatDeclaration(name:String, value:String):String
    {
        return declaration.fill([ name, StringLiteral.quote(value) ]);
    }

    public static function generateNames(values:Array):Object
    {
        var counters:Object = { };
        var names:Object = { };

        var name:String;
        var count:int;

        for each (var v:String in values)
        {
            name = generateName(v);
            count = counters[name] = 1 + counters[name];
            if (count > 1)
            {
                name += count;
            }
            names[name] = v;
        }
        return names;
    }

    public static function generateName(value:String):String
    {
        var match:Object;
        var words:Array;

        var capWord:String;

        if (!value)
        {
            return "";
        }
        else if (constForm.test(value))
        {
            return value;
        }
        else
        {
            words = [ ];

            tokenizer.lastIndex = 0;

            while ((match = tokenizer.exec(value)))
            {
                if (match[1])
                {
                    if (capWord)
                    {
                        words.push(capWord);
                    }
                    capWord = match[1];
                }
                else if (match[2])
                {
                    if (capWord)
                    {
                        if (capWord.length > 1)
                        {
                            words.push(capWord.slice(0, -1));
                            words.push(capWord.slice(-1) + match[2]);
                        }
                        else
                        {
                            words.push(capWord + match[2]);
                        }
                        capWord = "";
                    }
                    else
                    {
                        words.push(match[2]);
                    }
                }
                else if (match[3])
                {
                    if (capWord)
                    {
                        words.push(capWord);
                        capWord = "";
                    }

                    if (words.length == 0)
                    {
                        // AS identifiers can't begin with digits, so
                        // if this number would appear at the beginning,
                        // push a null string, which would place a _
                        // at the beginning when finally joined
                        words.push("");
                    }

                    words.push(match[3]);
                }
            }

            if (capWord) words.push(capWord);

            return words.join("_").toUpperCase();
        }
    }
}
}
