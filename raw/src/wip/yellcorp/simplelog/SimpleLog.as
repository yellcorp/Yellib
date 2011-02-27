package wip.yellcorp.simplelog
{
import org.yellcorp.format.template.Template;

import flash.utils.getQualifiedClassName;


public class SimpleLog extends SimpleLogDisplay
{
    private var unfilteredLog:Array;
    private var _classFilter:RegExp;
    private var _displayCallers:Boolean = true;
    //private var _levelFilter:???;

    public function SimpleLog()
    {
        super();
        unfilteredLog = [ ];
    }

    public function log(caller:*, level:String, message:String, templateArg:Object = null):void
    {
        var line:LogRecord = createLogRecord(caller, level, message, templateArg);
        appendLogRecord(line);
    }

    private function appendLogRecord(line:LogRecord):void
    {
        var textLine:String;

        unfilteredLog.push(line);
        if (passesFilter(line))
        {

            textLine = _displayCallers ? (line.callerText + " " + line.message)
                                       : line.message;

            appendFormatText(textLine, line.level);
        }
    }

    private function passesFilter(line:LogRecord):Boolean
    {
        // also have a 'level' filter
        if (_classFilter)
        {
            return _classFilter.test(line.callerText);
        }
        else
        {
            return true;
        }
    }

    private function createLogRecord(caller:*, level:String, message:String, templateArg:Object):LogRecord
    {
        var callerText:String;

        callerText = caller ? getQualifiedClassName(caller) : "";

        if (templateArg)
        {
            message = Template.format(message, templateArg);
        }

        return new LogRecord(callerText, level, message);
    }
}
}

internal class LogRecord
{
    internal var callerText:String;
    internal var level:String;
    internal var message:String;

    public function LogRecord(callerText:String, level:String, message:String)
    {
        this.message = message;
        this.level = level;
        this.callerText = callerText;
    }
}
