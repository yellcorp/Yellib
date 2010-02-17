package org.yellcorp.format
{
import org.yellcorp.map.TreeMapUtil;


/**
 * Replaces templated variables in a string with their values.
 *
 * @example
 * This demonstrates the use of named expressions to index into an
 * inline Object:
 * <listing version="3.0">
 * Template.format("Error #{id}: {message}",
 *                 { id: 2012, message: "Connection timeout" });
 *
 * // returns "Error #2012: Connection timeout"
 * </listing>
 *
 * Expressions can also be numeric to index into Arrays:
 * <listing version="3.0">
 * Template.format("You reached level {0} with a score of {1}", [ level, score ]);
 * </listing>
 *
 * Instances of a sealed class can also act as a source of values.
 * <listing version="3.0">
 * Template.format("The image is {width} x {height} pixels.", contentLoaderInfo);
 * </listing>
 *
 * Non-string values are converted to Strings.
 * <listing version="3.0">
 * Template.format("The time is now {0}", [ new Date() ]);
 * </listing>
 *
 * Properties can be recursively evaluated.
 * <listing version="3.0">
 * Template.format("Received event from {target.name}", event);
 * </listing>
 *
 * This works with arrays as well.
 * <listing version="3.0">
 * Template.format("{name}'s third-favourite band is {faves.2}",
 *                 { name:  "Martin",
 *                   faves: [ "The Leon Kings",
 *                            "The John Butler Threesome",
 *                            "The Presets" ] });
 *
 * Template.format("{0.name} beat {1.name} with a score of {0.score}." +
 *                 " {2.name} beat {3.name} to take out bronze.",
 *                 [ { name: "Pete", score: 23 },
 *                   { name: "Alex", score: 21 },
 *                   { name: "Mark", score: 19 } ]);
 *                   { name: "Jim",  score: 3  } ]);
 * </listing>
 *
 * Expressions that can't be resolved are replaced with
 * <code>notFoundValue</code>, which defaults to an empty string.
 * <listing version="3.0">
 * Template.format("File size is {bytesTotal}", event, "unknown");
 *
 * // if the event variable lacks a bytesTotal property,
 * // the returned string will be "File size is unknown".
 * </listing>
 *
 * To use the opening sequence literally in a string, escape it with
 * the character passed into <code>escapeChar</code>.  The default
 * escapeChar is backslash.  Backslashes have to be double-escaped as
 * they also escape special characters in ActionScript String literals.
 * <listing version="3.0">
 * Template.format("The string \\{name} is replaced with {name}",
 *                 { name: "Hyperion Mindzone" });
 *
 * // returns "The string {name} is replaced with Hyperion Mindzone"
 * </listing>
 *
 * The opening, closing, and escape sequences can all be changed, with
 * some restrictions.
 * <listing version="3.0">
 * // Opening and closing can be the same
 * Template.format("The volume is %volume%", soundTransform, null, "%", "%");
 *
 * // Demonstrates a multi-character opening string
 * Template.format("The volume is $(volume)", soundTransform, null, "$(", ")");
 *
 * // Multi-character opening and closing
 * Template.format("The volume is [[volume]]", soundTransform, null, "[[", "]]");
 *
 * // The escape char can be the same as the opening string if it is a
 * // single character. In this case, double the opening char to use it
 * // literally.
 * Template.format("When I type {{volume} it is replaced with {volume}", soundTransform, null, "{", "}", "{");
 *
 * // returns "When I type {volume} it is replaced with 1"
 *
 * // ERROR: If the opening sequence is more than one character long,
 * // the escape character cannot be the same as the first opening
 * // character, otherwise it would always escape the rest of the
 * // opening sequence
 * Template.format("Not allowed: $(volume)", soundTransform, null, "$(", ")", "$");
 * </listing>
 */
public class Template
{
    private static var cache:Object = { };
    /**
     * Replaces templated variables in a string with their values.
     *
     * <p>Templated variables are simple expressions delimited by special
     * characters or character sequences.  The expression is evaluated as
     * a property of the object passed in the <code>values</code>
     * parameter.  Expressions containing dots (.) are recursively
     * evaluated, much like an expression in Actionscript.</p>
     *
     * @param template The templated string in which to replace template
     *                 variable expressions.
     * @param values   An object with properties that correspond to
     *                 expressions in <code>template</code>.
     * @param notFoundValue A string to substitute if a value cannot be
     *                 resolved.
     * @param open     Template opening character sequence.
     * @param close    Template closing character sequence.
     * @param escapeChar Escape character.  If this precedes the opening
     *                 sequence, the opening will be interpreted as a
     *                 regular string.  This value must be one character
     *                 long, and cannot be the same as the first character
     *                 in <code>open</code> if <code>open</code> is more
     *                 than one character.
     * @return         The string with variables replaced by their values.
     * @throws         ArgumentError If any of the above restrictions
     *                 on <code>escapeChar</code> are violated.
     */
    public static function format(template:String,
                                  values:Object = null,
                                  notFoundValue:String = null,
                                  open:String = "{",
                                  close:String = "}",
                                  escapeChar:String = "\\"):String
    {
        var sequence:Array;

        // use template as the last node in the tree as it is the most
        // likely to change
        sequence = TreeMapUtil.evaluate(cache, open, close, escapeChar, template);
        if (!sequence)
        {
            sequence = parseSequence(template, open, close, escapeChar);
            TreeMapUtil.store(cache, sequence, open, close, escapeChar, template);
        }
        return formatSequence(sequence, values, notFoundValue);
    }

    /**
     * Clears the template parser cache.
     *
     * <p>The <code>Template</code> class maintains a cache to quickly
     * process repeated, identical calls to <code>format</code>. Calling
     * this function empties it.</p>
     */
    public static function clearCache():void
    {
        cache = { };
    }

    private static function formatSequence(sequence:Array,
                                           values:Object,
                                           notFoundValue:String):String
    {
        function format1(token:*, i:int, a:Array):String
        {
            var result:String;
            if (token is Substitution)
            {
                result = Substitution(token).format(values);
                return result === null ? notFoundValue : result;
            }
            else
            {
                return token;
            }
        }
        return sequence.map(format1).join("");
    }

    private static function parseSequence(template:String,
                                          open:String, close:String,
                                          escapeChar:String):Array
    {
        var index:int = 0;
        var len:int = template.length;
        var openPos:int;
        var openLen:int = open.length;
        var closePos:int;
        var closeLen:int = close.length;
        var sequence:Array = [ ];
        var uniqueEscape:Boolean = open != escapeChar;
        var escapePos:int = uniqueEscape ? template.indexOf(escapeChar) : 0;

        if (escapeChar.length > 1)
        {
            throw new ArgumentError("escapeChar must be a String of " +
                                    "length 1 (length=" +
                                    escapeChar.length + ")");
        }
        else if (openLen > 1 && escapeChar == open.charAt(0))
        {
            // lame copout, but i don't think it's going to come up much
            throw new ArgumentError("escapeChar cannot be the same as " +
                                    "the first character in open when " +
                                    "open is longer than 1 character");
        }

        while (index < len)
        {
            openPos = template.indexOf(open, index);
            if (openPos < 0)
                openPos = len;

            if (uniqueEscape && escapePos >= 0 && escapePos < openPos)
            {
                if (index < escapePos)
                {
                    sequence.push(template.substring(index, escapePos));
                }
                sequence.push(template.charAt(escapePos + 1));
                index = escapePos + 2;
                escapePos = template.indexOf(escapeChar, index);
                continue;
            }

            if (openPos < len)
            {
                if (!uniqueEscape && template.charAt(openPos + openLen) == escapeChar)
                {
                    if (openPos > index)
                    {
                        sequence.push(template.substring(index, openPos));
                    }
                    sequence.push(escapeChar);
                    index = openPos + openLen + 1;
                    continue;
                }
                closePos = template.indexOf(close, openPos + openLen);
                if (closePos >= 0)
                {
                    if (openPos > index)
                    {
                        sequence.push(template.substring(index, openPos));
                    }
                    sequence.push(makeSub(template.substring(openPos + openLen, closePos)));
                    index = closePos + closeLen;
                    continue;
                }
            }
            sequence.push(template.substr(index));
            break;
        }
        return sequence;
    }

    private static function makeSub(substring:String):Substitution
    {
        if (substring.indexOf(".") < 0)
        {
            return new SingleSub(substring);
        }
        else
        {
            return new FullSub(substring.split("."));
        }
    }
}
}
import org.yellcorp.map.TreeMapUtil;


internal interface Substitution
{
    function format(values:Object):String;
}

internal class SingleSub implements Substitution
{
    private var key:String;
    public function SingleSub(newKey:String)
    {
        this.key = newKey;
    }
    public function format(values:Object):String
    {
        return values[key];
    }
}

internal class FullSub implements Substitution
{
    private var propList:Array;

    public function FullSub(newPropList:Array)
    {
        propList = newPropList;
    }

    public function format(values:Object):String
    {
        return TreeMapUtil.evaluateA(values, propList);
    }
}
