package org.yellcorp.string
{
import org.yellcorp.format.template.Template;


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
