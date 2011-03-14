package org.yellcorp.lib.format.template
{
import org.yellcorp.lib.core.StringBuilder;


public class FormattingStringBuilder extends StringBuilder
{
    public function FormattingStringBuilder()
    {
        super();
    }

    public function appendFill(template:Template, values:*):void
    {
        append(template.fill(values));
    }
}
}
