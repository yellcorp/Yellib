package org.yellcorp.lib.markup.htmlclean
{
import org.yellcorp.lib.core.Set;
import org.yellcorp.lib.markup.html.HTMLReference;
import org.yellcorp.lib.xml.XMLOptionState;
import org.yellcorp.lib.xml.XMLTraverser;


/**
 * HTMLCleanFilter accepts XML objects representing XHTML documents and
 * transforms them according to the subset of HTML supported by Flash's
 * native TextField.  This is an optional 3rd step in cleaning HTML
 * documents for display in Flash.
 *
 * Unsupported attributes and and unsupported tags with inline
 * layout are stripped, unsupported block layout tags are converted to <p>
 *
 */
public class HTMLCleanFilter
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
                        'tabstops': true
                      },

        'ul': null
    };

    private var earlyClosed:int;
    private var tagStack:Array;

    private var traverser:XMLTraverser;

    public function HTMLCleanFilter()
    {
        super();
        traverser = new XMLTraverser();
        traverser.openElementHandler = processOpenElement;
        traverser.closeElementHandler = processCloseElement;
        traverser.textHandler = processText;
    }

    public function filter(document:XML):XML
    {
        var oldOptions:XMLOptionState = new XMLOptionState();
        XML.ignoreWhitespace = false;

        earlyClosed = 0;
        tagStack = [ ];
        openElement(<span />);

        traverser.traverse(document);

        oldOptions.restore();
        return tagStack[0];
    }

    private function processOpenElement(node:XML):void
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

    private function processCloseElement(node:XML):void
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

    private function processText(node:XML):void
    {
        appendNode(node);
    }

    private function processOpenSupportedElement(node:XML):void
    {
        var filterCopy:XML = filterNode(node);
        openElement(filterCopy);
    }

    private function processOpenUnsupportedElement(node:XML):void
    {
        // change unsupported tags with block layout to <p>
        if (HTMLReference.instance.isBlockTag(node.localName()))
        {
            // don't allow a <p> inside another <p>. if one is currently
            // open, close it first before appending a new one
            while (parent.localName() == "p")
            {
                closeElement();

                // as this tag has been closed early, make a note of it
                // so when the real close tag shows up in the input, we
                // don't try to double-close it in the output
                earlyClosed++;
            }
            openElement(<p />);
        }
    }

    private function processCloseSupportedElement(node:XML):void
    {
        closeElement();
    }

    private function processCloseUnsupportedElement(node:XML):void
    {
        if (HTMLReference.instance.isBlockTag(node.localName()))
        {
            if (earlyClosed == 0)
            {
                closeElement();
            }
            else
            {
                earlyClosed--;
            }
        }
    }

    private function openElement(node:XML):void
    {
        tagStack.push(node);
    }

    private function closeElement():void
    {
        var closingTag:XML = tagStack.pop();

        if (closingTag.localName() == "p" && closingTag.children().length() == 0)
        {
            // don't emit empty <p />
            return;
        }

        parent.appendChild(closingTag);
    }

    private function appendNode(node:XML):void
    {
        parent.appendChild(node);
    }

    private function get parent():XML
    {
        return tagStack[tagStack.length - 1];
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
