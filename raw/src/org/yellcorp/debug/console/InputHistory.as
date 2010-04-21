package org.yellcorp.debug.console
{
import org.yellcorp.math.MathUtil;


public class InputHistory
{
    private var input:InputEditor;
    private var history:Array;
    private var historyIndex:int;
    private var buffer:String;

    public function InputHistory(initInput:InputEditor)
    {
        input = initInput;
        buffer = "";
        clear();
    }

    public function edited():void
    {
        historyIndex = history.length;
    }

    public function clear():void
    {
        history = [ ];
        historyIndex = 0;
    }

    public function step(direction:int):void
    {
        if (historyIndex == history.length)
        {
            buffer = input.getInput();
        }
        historyIndex = MathUtil.clamp(historyIndex + direction, 0, history.length);
        if (historyIndex == history.length)
        {
            input.setInput(buffer);
        }
        else
        {
            input.setInput(history[historyIndex]);
        }
    }

    public function commit():void
    {
        if (historyIndex == history.length)
        {
            history.push(input.getInput());
            historyIndex++;
        }
    }
}
}
