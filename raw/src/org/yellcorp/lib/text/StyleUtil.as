package org.yellcorp.lib.text
{
import flash.text.StyleSheet;


public class StyleUtil
{
    /**
     * Overwrites or adds style declarations in an existing StyleSheet.
     *
     * @param styleSheet   The StyleSheet object containing the style to edit.
     * @param styleName    The name of the style to edit.
     * @param styleToMerge An object containing key-value pairs that will
     *                     add to, or overwrite, the attributes in the
     *                     specified style. If the specified style does
     *                     not exist, it will be created with the contents
     *                     of this object and added to the StyleSheet.
     */
    public static function merge(styleSheet:StyleSheet, styleName:String, styleToMerge:Object):void
    {
        var k:String;
        var existingStyle:Object;

        if (!styleToMerge)
        {
            return;
        }

        existingStyle = styleSheet.getStyle(styleName);

        if (existingStyle)
        {
            for (k in styleToMerge)
            {
                existingStyle[k] = styleToMerge[k];
            }
            styleSheet.setStyle(styleName, existingStyle);
        }
        else
        {
            styleSheet.setStyle(styleName, styleToMerge);
        }
    }
}
}
