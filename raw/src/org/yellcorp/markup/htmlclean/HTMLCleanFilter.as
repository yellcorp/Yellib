package org.yellcorp.markup.htmlclean
{
import org.yellcorp.markup.html.HTMLReference;
import org.yellcorp.sequence.Set;
import org.yellcorp.xml.XMLTraverser;


public class HTMLCleanFilter extends XMLTraverser
{
    private static var whitelist:Object =
    {
        'a': { 'target': true,
               'href': true
             },

        'b': null,

        'br': null,

        'font': { 'color': true,
                  'face': true,
                  'size': true
                },

        'img': { 'src': true,
                 'width': true,
                 'height': true,
                 'align': true,
                 'hspace': true,
                 'vspace': true,
                 'id': true,
                 'checkPolicyFile': new Set(["true", "false"])
               },

        'i': null,

        'li': null,

        'ol': null,

        'p': { 'align': new Set(["left", "right", "justify", "center"]),
               'class': true
             },

        'span': { 'class': true },

        'textformat': { 'blockindent': true,
                        'indent': true,
                        'leading': true,
                        'leftmargin': true,
                        'rightmargin': true,
                        'tabstops': true },

        'ul': null
    };

    private var filtered:XML;
    private var parent:XML;

    public function HTMLCleanFilter()
    {
        super();
    }

    public function filter(document:XML):XML
    {
        filtered = <html />;
        parent = filtered;
        traverse(document);
        return filtered;
    }

    protected override function processOpenElement(node:XML):void
    {
        if (isSupportedTag(node.localName()))
        {
            processOpenSupportedElement(node);
        }
        else
        {
            processOpenUnsupportedElement(node);
        }
    }


    protected override function processCloseElement(node:XML):void
    {
        if (isSupportedTag(node.localName()))
        {
            processCloseSupportedElement(node);
        }
        else
        {
            processCloseUnsupportedElement(node);
        }
    }

    protected override function processText(node:XML):void
    {
        appendNode(node);
    }

    protected function processOpenSupportedElement(node:XML):void
    {
        var filterCopy:XML = filterNode(node);
        openElement(filterCopy);
    }

    protected function processOpenUnsupportedElement(node:XML):void
    {
        if (HTMLReference.instance.isBlockTag(node.localName()))
        {
            openElement(<p />);
        }
    }

    protected function processCloseSupportedElement(node:XML):void
    {
        closeElement();
    }

    protected function processCloseUnsupportedElement(node:XML):void
    {
        if (HTMLReference.instance.isBlockTag(node.localName()))
        {
            closeElement();
        }
    }

    private function openElement(node:XML):void
    {
        parent.appendChild(node);
        parent = node;
    }

    private function closeElement():void
    {
        parent = parent.parent();
    }

    private function appendNode(node:XML):void
    {
        parent.appendChild(node);
    }

    private static function filterNode(node:XML):XML
    {
        var tagName:String;
        var newNode:XML;
        var attr:XML;
        var attrName:String;
        var attrValue:String;

        newNode = <n />;
        tagName = node.localName().toLowerCase();
        newNode.setLocalName(tagName);

        for each (attr in node.attributes())
        {
            attrName = attr.localName().toLowerCase();
            attrValue = coerceAttrValue(tagName, attrName, attr.toString());
            if (attrValue)
            {
                newNode.@[attrName] = attrValue;
            }
        }
        return newNode;
    }

    public static function isSupportedTag(tagName:String):Boolean
    {
        return whitelist.hasOwnProperty(tagName.toLowerCase());
    }

    public static function coerceAttrValue(tagName:String, attrName:String, attrValue:String):String
    {
        var tagAttrMap:Object;
        var attrValueSpec:*;

        tagAttrMap = whitelist[tagName.toLowerCase()];
        if (!tagAttrMap) return "";

        attrValueSpec = tagAttrMap[attrName.toLowerCase()];

        if (attrValueSpec === true)
        {
            return attrValue;
        }
        else if (attrValueSpec is Set)
        {
            attrValue = attrValue.toLowerCase();
            if (Set(attrValueSpec).contains(attrValue))
            {
                return attrValue;
            }
        }
        return "";
    }
}
}
