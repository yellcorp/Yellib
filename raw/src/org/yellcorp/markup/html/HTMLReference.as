package org.yellcorp.markup.html
{
import org.yellcorp.sequence.Set;

import flash.errors.IllegalOperationError;


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

    private var closedBy:Object;

    public function HTMLReference(key:HTMLReference_ctor)
    {
        if (!key) throw new IllegalOperationError("Public constructor call");

        buildEntities();
        buildHTMLClasses();
        buildCloseTable();
    }

    public function isHTMLTag(tagName:String):Boolean
    {
        return allTags.contains(tagName.toLowerCase());
    }

    public function isEmptyTag(tag:String):Boolean
    {
        return empty.contains(tag.toLowerCase());
    }

    public function isTagClosedBy(openTag:String, nextTag:String):Boolean
    {
        var matcher:Matcher = Matcher(closedBy[openTag.toLowerCase()]);
        if (!matcher)
        {
            return false;
        }
        return matcher.match(nextTag.toLowerCase());
    }

    public function isAttrOptionalTag(tagName:String):Boolean
    {
        return attrOptionalTags.contains(tagName.toLowerCase());
    }

    public function isTextEntity(query:String):Boolean
    {
        return textEntities.contains(query.toLowerCase());
    }

    public function isNumericEntity(query:String):Boolean
    {
        return numericEntityPattern.test(query);
    }

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
        var anyInline:Matcher = new InSet(inline);
        var anyFlow:Matcher = new InSet(flow);
        var all:Matcher = new All();
        var allButTR:Matcher = new Not(new Equals("tr"));
        var allButCol:Matcher = new Not(new Equals("col"));
        var allButTableCells:Matcher = new Not(new InSet(tableCells));

        closedBy = {
            p:  anyInline,
            dt: anyInline,
            dd: anyFlow,
            li: anyFlow,
            option: all,
            thead: allButTR,
            tfoot: allButTR,
            tbody: allButTR,
            colgroup: allButCol,
            tr: allButTableCells,
            th: anyFlow,
            tf: anyFlow
        };
    }

    private function buildHTMLClasses():void
    {
        heading = new Set(["h1", "h2", "h3", "h4", "h5", "h6"]);

        list = new Set(["ul", "ol", "dir", "menu"]);

        fontstyle = new Set(["tt", "i", "b", "u", "s", "strike", "big",
            "small"]);

        phrase = new Set(["em", "strong", "dfn", "code", "samp", "kbd",
            "var", "cite", "abbr", "acronym"]);

        special = new Set(["a", "img", "applet", "object", "font",
            "basefont", "br", "script", "map", "q", "sub", "sup", "span",
            "bdo", "iframe"]);

        formctrl = new Set(["input", "select", "textarea", "label",
            "button"]);

        block = new Set(["p", "dl", "div", "center", "noscript",
            "noframes", "blockquote", "form", "isindex", "hr", "table",
            "fieldset", "address", "pre"]);
        block.addIterable(heading);
        block.addIterable(list);

        inline = fontstyle.clone();
        inline.addIterable(phrase);
        inline.addIterable(special);
        inline.addIterable(formctrl);

        flow = Set.union(block, inline);

        tableCells = new Set(["th", "td"]);

        empty = new Set(["basefont", "br", "area", "link", "img", "param",
            "hr", "input", "col", "frame", "isindex", "base", "meta"]);

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

import org.yellcorp.sequence.Set;


internal class HTMLReference_ctor { }

internal interface Matcher
{
    function match(tag:String):Boolean
}
internal class All implements Matcher
{
    public function match(tag:String):Boolean
    {
        return true;
    }
}
internal class InSet implements Matcher
{
    private var matchSet:Set;
    public function InSet(matchSet:Set)
    {
        this.matchSet = matchSet;
    }
    public function match(tag:String):Boolean
    {
        return matchSet.contains(tag);
    }
}
internal class Equals implements Matcher
{
    private var value:String;
    public function Equals(value:String)
    {
        this.value = value;
    }
    public function match(tag:String):Boolean
    {
        return tag == value;
    }
}
internal class Not implements Matcher
{
    private var matcher:Matcher;
    public function Not(matcher:Matcher)
    {
        this.matcher = matcher;
    }

    public function match(tag:String):Boolean
    {
        return !matcher.match(tag);
    }
}
