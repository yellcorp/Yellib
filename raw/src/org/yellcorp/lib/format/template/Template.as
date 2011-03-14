package org.yellcorp.lib.format.template
{
import org.yellcorp.lib.core.StringBuilder;
import org.yellcorp.lib.format.template.renderer.Renderer;


/**
 * A Template encapsulates a format string, which may be a mix of literal
 * text, and specially formatted placeholders that refer to property
 * indices or names. The <code>formatValues</code> method accepts an
 * object, and uses its properties to populate the format string's
 * placeholders.
 *
 * @example
 * This demonstrates the use of strings to index into an inline Object:
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
 * Any instance that supports [] property resolution can be used as a
 * source of values. The following example shows the use of a sealed class
 * instance:
 * <listing version="3.0">
 * Template.format("The image is {width} x {height} pixels.", contentLoaderInfo);
 * </listing>
 *
 * Non-string values are converted to Strings.
 * <listing version="3.0">
 * Template.format("The time is now {0}", [ new Date() ]);
 * </listing>
 *
 * If values themselves have properties, they can also be addressed by
 * appending a dot (.) and the property name. The following example
 * resolves <code>event.target.name</code>
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
 * Template.format("{0.name} beat {1.name} with a score of {0.score}. " +
 *                 "{2.name} beat {3.name} to take out bronze.",
 *                 [ { name: "Pete", score: 23 },
 *                   { name: "Alex", score: 21 },
 *                   { name: "Mark", score: 19 } ]);
 *                   { name: "Jim",  score: 3  } ]);
 * </listing>
 *
 * Properties that can't be resolved are replaced with
 * <code>notFoundValue</code>, which defaults to an empty string.
 * <listing version="3.0">
 * Template.format("File size is {bytesTotal}", event, "unknown");
 *
 * // if the event variable lacks a bytesTotal property,
 * // the returned string will be "File size is unknown".
 * </listing>
 *
 * The character sequences used to indicate placeholders can be varied.
 * By default, placeholders are surrounded with braces, and literal braces
 * are escaped with backslashes.  In String literals, backslashes have to be
 * double-escaped.
 *
 * Template.format("The string \\{name} is replaced with {name}",
 *                 { name: "Gunnar Magnusson" });
 *
 * // returns "The string {name} is replaced with Gunnar Magnusson"
 * </listing>
 *
 * The opening, closing, and escape sequences can all be changed.  Opening
 * and closing sequences must be at least 1 character long.  The escape
 * sequence can only be 1 character long. Passing in an empty string ("")
 * for the escape string has the special meaning that opening and closing
 * sequences are escaped by doubling their first character.
 * <listing version="3.0">
 * // Same opening and closing sequences
 * Template.format("The volume is %volume%", soundTransform, null, "%", "%");
 *
 * // An opening sequence with more than one character
 * Template.format("The volume is $(volume)", soundTransform, null, "$(", ")");
 *
 * // An escape character that is the same as a single-character opening
 * // sequence.
 * Template.format("The string %%volume%% is replaced with %volume%",
 *                 soundTransform, null, "%", "%", "%");
 *
 * // returns "The string %volume% is replaced with 1"
 *
 * // Passing the empty string for escapeChar means that both opening and
 * // closing sequences are escaped by doubling their first character.
 * Template.format("The string [[volume]] is replaced with [volume]",
 *                 soundTransform, null, "[", "]", "");
 *
 * // returns "The string [volume] is replaced with 1"
 * </listing>
 */
public class Template
{
    private var _format:String;
    private var _open:String;
    private var _close:String;
    private var _escapeChar:String;

    private var _renderers:Array;

    private static var parserCache:Object = { };

    /**
     * Creates a new <code>Template</code> instance with a single format
     * String. The format string is parsed once and then used for all
     * calls to <code>formatValues</code>.
     *
     * @param format     The format string containing a mix of literal text
     *                   and property placeholders.
     *
     * @param open       The string that marks the start of a property name.
     *
     * @param close      The string that marks the end of a property name.
     *
     * @param escapeChar The escape character. When an escape character is
     *                   encountered, the character following it is treated
     *                   as a literal character, as opposed to the start
     *                   or end of a property placeholder. Cannot be longer
     *                   than 1 character. If this argument is the empty
     *                   string "", open and close sequences are escaped
     *                   by doubling their first character.
     *
     * @throws TemplateFormatStringError If the <code>format</code> argument
     *                   cannot be parsed, for example if a placeholder is
     *                   left unclosed.
     *
     * @throws ArgumentError If <code>open</code> or <code>close</code> is
     *                   null or an empty String, or if
     *                   <code>escapeChar</code> is longer than 1 character.
     */
    public function Template(format:String,
            open:String = "{", close:String = "}", escapeChar:String="\\")
    {
        _format = format;
        _open = open;
        _close = close;
        _escapeChar = escapeChar;

        parse();
    }

    /**
     * Returns this instance's format string with placeholders populated
     * with the corresponding property values in <code>values</code>. An
     * optional <code>notFoundValue</code> can be supplied as a fallback
     * if a property can't be resolved.
     *
     * @param   values         An object that supplies the values for the
     *                         placeholders in this instance's format
     *                         string. This can be any object that supports
     *                         property lookup with the [] operator.
     *
     * @param   notFoundValue  A value that will be used if a property
     *                         doesn't exist.
     *
     * @return  The populated string.
     */
    public function fill(values:*, notFoundValue:* = ""):String
    {
        var value:*;
        var buffer:StringBuilder = new StringBuilder();

        for each (var renderer:Renderer in _renderers)
        {
            value = renderer.render(values);
            if (value === null || value === undefined)
            {
                value = notFoundValue;
            }
            buffer.append(value);
        }
        return buffer.toString();
    }

    /**
     * Returns an Array of this instance's renderers. Can be useful in
     * debugging, to see how a format string has been parsed.
     *
     * @return An <code>Array</code> of objects of type
     *         <code>Renderer</code>. Each object's toString() method
     *         shows what part of the format string it represents.
     */
    public function get renderers():Array
    {
        return _renderers.splice();
    }

    /**
     * A convenience method that accepts both a format string and a value
     * object. This method parses the format string each time it is called,
     * so if one format string will be used repeatedly, performance
     * can be improved by constructing a <code>Template</code> instance once
     * and calling its <code>fill</code> method.
     *
     * @param format     The format string containing a mix of literal text
     *                   and property placeholders.
     *
     * @param   values         An object that supplies the values for the
     *                         placeholders in this instance's format
     *                         string. This can be any object that supports
     *                         property lookup with the [] operator.
     *
     * @param   notFoundValue  A value that will be used if a property
     *                         doesn't exist.
     *
     * @param open       The string that marks the start of a property name.
     *
     * @param close      The string that marks the end of a property name.
     *
     * @param escapeChar The escape character. When an escape character is
     *                   encountered, the character following it is treated
     *                   as a literal character, as opposed to the start
     *                   or end of a property placeholder. Cannot be longer
     *                   than 1 character. If this argument is the empty
     *                   string "", open and close sequences are escaped
     *                   by doubling their first character.
     *
     * @return  The populated string.
     *
     * @throws TemplateFormatStringError If the <code>format</code> argument
     *                   cannot be parsed, for example if a placeholder is
     *                   left unclosed.
     *
     * @throws ArgumentError If <code>open</code> or <code>close</code> is
     *                   null or an empty String, or if
     *                   <code>escapeChar</code> is longer than 1 character.
     *
     * @see Template
     * @see #fill
     */
    public static function format(
            format:String, values:*, notFoundValue:* = "",
            open:String = "{", close:String = "}",
            escapeChar:String = "\\"):String
    {
        return new Template(format, open, close, escapeChar).fill(values, notFoundValue);
    }

    /**
     * Clears the parser cache.
     */
    public static function clearCache():void
    {
        for each (var p:Parser in parserCache)
        {
            p.clearCache();
        }
        parserCache = { };
    }

    private function parse():void
    {
        var parser:Parser;

        parser = parserCache[Parser.getParserHash(_open, _close, _escapeChar)];

        if (!parser)
        {
            parser = new Parser(_open, _close, _escapeChar);
            parserCache[parser.hash] = parser;
        }

        _renderers = parser.parse(_format);
    }
}
}
