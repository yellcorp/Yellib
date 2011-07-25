package wip.yellcorp.lib.simplelog
{
import flash.system.System;


public class DefaultInputParser implements LogInputParser
{
    public function parse(inputText:String, logger:SimpleLogDisplay):Boolean
    {
        var tokens:Array;
        var head:String;

        tokens = inputText.split(" ");

        head = tokens[0];

        switch (head)
        {
        case "mem" :
            logger.appendFormatText("Memory: " + System.totalMemory + "\n");
            return true;
            break;

        case "gc" :
            System.gc();
            logger.appendFormatText("System.gc() called\n");
            return true;
            break;

        default :
            return false;
            break;
        }
    }
}
}
