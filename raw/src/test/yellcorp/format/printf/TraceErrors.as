package test.yellcorp.format.printf
{
import org.yellcorp.format.printf.FormatError;
import org.yellcorp.format.printf.Printf;
import org.yellcorp.string.StringUtil;

import flash.display.Sprite;


public class TraceErrors extends Sprite
{
    public function TraceErrors()
    {
        try { Printf.sprintf("%", "0"); } catch (fe:FormatError) { traceError(fe); }
        try { Printf.sprintf("%z", "0"); } catch (fe:FormatError) { traceError(fe); }
        try { Printf.sprintf("hi %$1d hi", "0"); } catch (fe:FormatError) { traceError(fe); }
        try { Printf.sprintf("%s_%s", "00"); } catch (fe:FormatError) { traceError(fe); }
        try { Printf.sprintf("%<s", "00"); } catch (fe:FormatError) { traceError(fe); }
        try { Printf.sprintf("%0$s %1$s", "00"); } catch (fe:FormatError) { traceError(fe); }
        try { Printf.sprintf("%++d" , 5); } catch (fe:FormatError) { traceError(fe); }
        try { Printf.sprintf("%.21e", 0); } catch (fe:FormatError) { traceError(fe); }
        try { Printf.sprintf("%.21f", 0); } catch (fe:FormatError) { traceError(fe); }
        try { Printf.sprintf("%.22g", 0); } catch (fe:FormatError) { traceError(fe); }
        try { Printf.sprintf("%0$%", "Not used"); } catch (fe:FormatError) { traceError(fe); }
        try { Printf.sprintf("%s %<%", "Used"); } catch (fe:FormatError) { traceError(fe); }
    }

    private function traceError(fe:FormatError):void
    {
        trace("--------------");
        trace(fe.message);
        trace(fe.formatString);
        trace(StringUtil.repeat(" ", fe.charIndex) + "^");
    }
}
}
