package org.yellcorp.lib.markup.html
{
import org.yellcorp.lib.core.Set;

import flash.errors.IllegalOperationError;


/**
 * A partial database of HTML tags and entities taken from the HTML DTD.
 *
 * This class is a singleton, so access methods via HTMLReference.instance
 *
 * @see #instance
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
     * Returns whether a string is the name of a standard HTML tag or
     * popular non-standard one.  The name should be the string alone - no
     * <code>&lt;</code> or <code>&gt;</code>
     */
    public function isHTMLTag(tagName:String):Boolean
    {
        return inTagSet(allTags, tagName);
    }

    /**
     * Returns whether a tag is defined as empty.  An empty tag is one that
     * allows no child tags or text.  <code>&lt;img&gt;</code> is an
     * example.
     */
    public function isEmptyTag(tagName:String):Boolean
    {
        return inTagSet(empty, tagName);
    }

    /**
     * Returns whether a tag is defined as having block layout.
     */
    public function isBlockTag(tagName:String):Boolean
    {
        return inTagSet(block, tagName);
    }

    /**
     * Returns whether a tag is defined as having inline layout.
     */
    public function isInlineTag(tagName:String):Boolean
    {
        return inTagSet(inline, tagName);
    }

    /**
     * Returns whether a tag does not require attributes.  This is an
     * heuristic based on de facto usage rather than strict definition.
     * For example, by the standard, <code>&lt;script&gt;</code> tags should
     * always have attributes, but browsers widely assume JavaScript if a
     * <code>type</code> is not defined.  Conversely,
     * <code>&lt;a&gt;</code> can be empty but is rarely useful without
     * either <code>name</code> or <code>href</code>.
     */
    public function isAttrOptionalTag(tagName:String):Boolean
    {
        return inTagSet(attrOptionalTags, tagName);
    }

    /**
     * Returns whether <code>childTag</code> is allowed as an immediate
     * child of <code>parentTag</code>.
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
     * Returns whether a string is a valid named or numeric character code
     * entity.
     */
    public function isEntity(query:String):Boolean
    {
        return isNamedEntity(query) || isNumericEntity(query);
    }

    /**
     * Returns whether a string is a valid named entity.
     */
    public function isNamedEntity(query:String):Boolean
    {
        return textEntities.contains(stripEntity(query).toLowerCase());
    }

    /**
     * Returns whether a string is a valid decimal or hexadecimal character
     * code entity.
     */
    public function isNumericEntity(query:String):Boolean
    {
        return numericEntityPattern.test(stripEntity(query));
    }

    private function stripEntity(query:String):String
    {
        var first:int = 0;
        var last:int = query.length;
        if (query.charAt(0) == "&") first++;
        if (query.charAt(query.length - 1) == ";") last--;
        return query.substring(first, last);
    }

    /**
     * Returns the HTML entity equivalent of a character, or undefined if
     * one isn't defined.  Currently only supports <code>&lt; &gt; &amp;
     * &apos;</code> and <code>&quot;</code>.
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

        numericEntityPattern = /#([0-9]+|x[0-9a-f]+)/i;

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
