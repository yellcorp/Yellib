package org.yellcorp.lib.markup.html
{
import org.yellcorp.lib.core.Set;

import flash.errors.IllegalOperationError;


/**
 * A partial database of HTML tags and entities taken from the HTML DTD.
 *
 * This class is a singleton, so access methods via HTMLReference.instance
 */
public class HTMLReference
{
    private var textEntities:Set;
    private var numericEntityPattern:RegExp;
    private var charEntities:Array;

    private var allTags:Set;
    private var attrOptionalTags:Set;
    private var tableCells:Set;
    private var empty:Set;

    private var flow:Set;
    private var  block:Set;
    private var   heading:Set;
    private var   list:Set;
    private var  inline:Set;
    private var   fontstyle:Set;
    private var   phrase:Set;
    private var   special:Set;
    private var   formctrl:Set;

    private var allow:Object;

    public function HTMLReference(key:HTMLReference_ctor)
    {
        if (!key) throw new IllegalOperationError("Public constructor call");

        buildEntities();
        buildHTMLClasses();
        buildCloseTable();
    }

    /**
     * True if passed the name of a standard HTML tag or popular
     * non-standard one.  The name should be the string alone - no &lt; or &gt;
     */
    public function isHTMLTag(tagName:String):Boolean
    {
        return inTagSet(allTags, tagName);
    }

    /**
     * True if passed the name of a tag defined as empty.  An empty tag
     * is one that allows no child tags or text.  &lt;img&gt; is an example.
     */
    public function isEmptyTag(tagName:String):Boolean
    {
        return inTagSet(empty, tagName);
    }

    /**
     * True if the tag is defined as having block layout.
     */
    public function isBlockTag(tagName:String):Boolean
    {
        return inTagSet(block, tagName);
    }

    /**
     * True if the tag is defined as having inline layout.
     */
    public function isInlineTag(tagName:String):Boolean
    {
        return inTagSet(inline, tagName);
    }

    /**
     * True if the tag does not require attributes.  This is more
     * heuristic than strict.  For example, by the standard, &lt;script&gt; tags
     * should always have attributes, but browsers widely assume JavaScript
     * if a type is not defined.  Conversely, &lt;a&gt; can be empty but is
     * rarely useful without either name or href.
     */
    public function isAttrOptionalTag(tagName:String):Boolean
    {
        return inTagSet(attrOptionalTags, tagName);
    }

    /**
     * True if childTag is allowed as a child of parentTag
     */
    public function isTagAllowedInTag(parentTag:String, childTag:String):Boolean
    {
        var allowedTags:Set = allow[parentTag];

        if (allowedTags)
        {
            return allowedTags.contains(childTag);
        }
        else
        {
            // no record of it, assume it's allowed
            return true;
        }
    }

    /**
     * True if query is a valid entity. Note that this function
     * expects just the name part of the entity - i.e. between, but not
     * including, the & and ;
     */
    public function isTextEntity(query:String):Boolean
    {
        return textEntities.contains(query.toLowerCase());
    }

    /**
     * True if query is a valid character code entity. This is different
     * to isTextEntity in that it expects the leading &
     */
    public function isNumericEntity(query:String):Boolean
    {
        return numericEntityPattern.test(query);
    }

    /**
     * Returns the entity for the character passed into literalChar, if
     * it exists in the database
     */
    public function getEntityRepr(literalChar:String):String
    {
        return charEntities[literalChar.charCodeAt(0)];
    }

    private function buildEntities():void
    {
        textEntities = new Set(["aacute", "acirc", "acute", "aelig",
        "agrave", "amp", "apos", "aring", "atilde", "auml", "brvbar",
        "ccedil", "cedil", "cent", "copy", "curren", "deg", "divide",
        "eacute", "ecirc", "egrave", "eth", "euml", "frac12", "frac14",
        "frac34", "gt", "iacute", "icirc", "iexcl", "igrave", "iquest",
        "iuml", "laquo", "lt", "macr", "micro", "middot", "nbsp", "not",
        "ntilde", "oacute", "ocirc", "ograve", "ordf", "ordm", "oslash",
        "otilde", "ouml", "para", "plusmn", "pound", "quot", "raquo",
        "reg", "sect", "shy", "sup1", "sup2", "sup3", "szlig", "thorn",
        "times", "uacute", "ucirc", "ugrave", "uml", "uuml", "yacute",
        "yen", "yuml"]);

        numericEntityPattern = /\&#([0-9]+|x[0-9a-f]+)/i;

        charEntities = [ ];
        charEntities["<".charCodeAt(0)] = "&lt;";
        charEntities[">".charCodeAt(0)] = "&gt;";
        charEntities["&".charCodeAt(0)] = "&amp;";
        charEntities["'".charCodeAt(0)] = "&apos;";
        charEntities['"'.charCodeAt(0)] = "&quot;";
    }

    // the data for the following functions are
    // sourced from the HTML4 transitional DTD
    // http://www.w3.org/TR/REC-html40/sgml/loosedtd.html
    private function buildCloseTable():void
    {
        var onlyTR:Set = new Set(["tr"]);
        var onlyCol:Set = new Set(["col"]);
        var none:Set = new Set();

        allow = {
            p: inline,
            dt: inline,
            dd: flow,
            li: flow,
            option: none,
            thead: onlyTR,
            tfoot: onlyTR,
            tbody: onlyTR,
            colgroup: onlyCol,
            tr: tableCells,
            th: flow,
            td: flow
        };
    }

    private function buildHTMLClasses():void
    {
        heading = new Set(["h1", "h2", "h3", "h4", "h5", "h6"]);

        list = new Set(["ul", "ol", "dir", "menu"]);

        fontstyle = new Set(["tt", "i", "b", "u", "s", "strike", "big",
            "small" /*nonstandard*/, "blink"]);

        phrase = new Set(["em", "strong", "dfn", "code", "samp", "kbd",
            "var", "cite", "abbr", "acronym"
            /*nonstandard*/, "rt", "ruby"]);

        special = new Set(["a", "img", "applet", "object", "font",
            "basefont", "br", "script", "map", "q", "sub", "sup", "span",
            "bdo", "iframe"]);

        formctrl = new Set(["input", "select", "textarea", "label",
            "button"]);

        block = new Set(["p", "dl", "div", "center", "noscript",
            "noframes", "blockquote", "form", "isindex", "hr", "table",
            "fieldset", "address", "pre" /*nonstandard*/, "ilayer",
            "layer", "marquee", "noembed"]);
        block.addIterable(heading);
        block.addIterable(list);

        inline = Set.union(fontstyle, phrase);
        inline.addIterable(special);
        inline.addIterable(formctrl);

        flow = Set.union(block, inline);

        tableCells = new Set(["th", "td"]);

        empty = new Set(["basefont", "br", "area", "link", "img", "param",
            "hr", "input", "col", "frame", "isindex", "base", "meta"
            /*nonstandard*/, "bgsound", "embed", "spacer", "wbr"]);

        allTags = new Set(['sub', 'sup', 'span', 'bdo', 'basefont', 'font',
        'br', 'body', 'address', 'div', 'center', 'a', 'map', 'area',
        'link', 'img', 'object', 'param', 'applet', 'hr', 'p', 'pre', 'q',
        'blockquote', 'ins', 'del', 'dl', 'dt', 'li', 'form', 'label',
        'input', 'select', 'optgroup', 'option', 'textarea', 'fieldset',
        'legend', 'button', 'table', 'caption', 'thead', 'tfoot', 'tbody',
        'colgroup', 'col', 'tr', 'th', 'td', 'frameset', 'frame', 'iframe',
        'noframes', 'head', 'title', 'isindex', 'base', 'meta', 'style',
        'script', 'noscript', 'html']);
        allTags.addIterable(heading);
        allTags.addIterable(list);
        allTags.addIterable(fontstyle);
        allTags.addIterable(phrase);

        // the following tags can technically have attrs omitted but are
        // not included in this set as it is unlikely that they would be
        // omitted:
        // 'span', 'font', 'div', 'a', 'link', 'object', 'label',
        // 'frame', 'base'
        //
        // also apparently the type attr on STYLE and SCRIPT is required
        // but browsers will assume CSS and JS if omitted
        //
        attrOptionalTags = new Set(['sup', 'sub', 'br', 'body', 'address',
        'center', 'hr', 'p', 'pre', 'q', 'blockquote', 'ins', 'del', 'dl',
        'dt', 'dd', 'li', 'input', 'select', 'option', 'fieldset',
        'legend', 'button', 'table', 'caption', 'colgroup', 'col', 'thead',
        'tbody', 'tfoot', 'tr', 'th', 'td', 'frameset', 'iframe',
        'noframes', 'head', 'title', 'isindex', 'style', 'script',
        'noscript', 'html']);
        attrOptionalTags.addIterable(heading);
        attrOptionalTags.addIterable(list);
        attrOptionalTags.addIterable(fontstyle);
        attrOptionalTags.addIterable(phrase);
    }

    private static function inTagSet(tagSet:Set, tagName:String):Boolean
    {
        return tagSet.contains(tagName.toLowerCase());
    }


    private static var _instance:HTMLReference;
    public static function get instance():HTMLReference
    {
        if (!_instance)
        {
            _instance = new HTMLReference(new HTMLReference_ctor());
        }
        return _instance;
    }
}
}

internal class HTMLReference_ctor { }