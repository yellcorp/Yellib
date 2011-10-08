package org.yellcorp.lib.core
{
public class RegExpUtil
{
    public static const REGEX_METACHARS:RegExp = /([\^$.*+?|\\()[\]{}])/g;

    public static function createLiteralRegExp(literalString:String, flags:String = ""):RegExp
    {
        return new RegExp(escapeRegExp(literalString), flags);
    }

    public static function createAlternates(literalAlternates:Array, capturing:Boolean, flags:String = ""):RegExp
    {
        var escapedAlternates:Array;
        var expression:String;

        escapedAlternates = literalAlternates.map(escapeRegExp);
        expression = (capturing ? "(" : "(?:") + escapedAlternates.join("|") + ")";

        return new RegExp(expression, flags);
    }

    // the extra unused args here are to allow this
    // function to be passed to Array.map
    public static function escapeRegExp(literalString:String, index:* = null, array:* = null):String
    {
        return literalString.replace(REGEX_METACHARS, "\\$1");
    }
    
    private static const RE_PROP_TO_FLAG:Object = {
        global:     'g',  g: 'g',
        ignorecase: 'i',  i: 'i',
        multiline:  'm',  m: 'm',
        dotall:     's',  s: 's',
        extended:   'x',  x: 'x'
    };
    
    /**
     * Returns a copy of a RegExp with its flags modified.
     * 
     * @param source         The RegExp from which to create a modified copy.
     * @param newFlagValues  A dynamic object mapping RegExp flags to their
     *                       new value of <code>true</code> or 
     *                       <code>false</code>.  Flags can be expressed as 
     *                       letters (g, i, s, m or x) or their respective
     *                       RegExp property name (global, ignoreCase, 
     *                       multiline, dotall, or extended).  Flag names are
     *                       case-insensitive.  Flags that are not specified 
     *                       will take their value from the 
     *                       <code>source</source> RegExp.  If a flag is 
     *                       specified more than once (for example, specifying 
     *                       both i and ignoreCase), the value for that flag is 
     *                       not defined.
     * @return A copy of the original RegExp with the new flag values.
     */
    public static function changeFlags(source:RegExp, newFlagValues:Object):RegExp
    {
        var property:String;
        var flag:String;
        
        var newFlags:Object = {
            g: source.global,
            i: source.ignoreCase,
            m: source.multiline,
            s: source.dotall,
            x: source.extended
        };
        
        if (newFlagValues)
        {
	        for (property in newFlagValues)
	        {
                flag = RE_PROP_TO_FLAG[property.toLowerCase()];
                if (flag)
                {
	            	newFlags[flag] = newFlagValues[property];
                }
	        }
        }
        
        var newFlagString:String = "";
        for (flag in newFlags)
        {
            if (newFlags[flag]) newFlagString += flag;
        }
        
        return new RegExp(source.source, newFlagString);
    }
}
}
