package org.yellcorp.format.c4.parser
{
import org.yellcorp.format.c4.context.ContextArg;
import org.yellcorp.format.c4.context.NullArg;
import org.yellcorp.format.c4.context.RenderContext;


public class FieldProperties
{
    public var arg:ContextArg;
    public var leftJustify:Property = new Property(false);
    public var alternateForm:Property = new Property(false);
    public var positivePrefix:Property = new Property("");
    public var paddingChar:Property = new Property(" ");
    public var grouping:Property = new Property(false);
    public var negativePrefix:Property = new Property("-");
    public var negativeSuffix:Property = new Property("");
    public var width:ContextArg;
    public var precision:ContextArg;
    public var uppercase:Property = new Property(false);

    public function FieldProperties()
    {
        clear();
    }

    public function clear():void
    {
        arg = new NullArg();
        leftJustify.clear();
        alternateForm.clear();
        positivePrefix.clear();
        paddingChar.clear();
        grouping.clear();
        negativePrefix.clear();
        negativeSuffix.clear();
        width = new NullArg();
        precision = new NullArg();
        uppercase.clear();
    }

    public function resolve(context:RenderContext):void
    {
        width.resolve(context);
        precision.resolve(context);
        arg.resolve(context);
    }
}
}
