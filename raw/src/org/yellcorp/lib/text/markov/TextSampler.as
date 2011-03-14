package org.yellcorp.lib.text.markov
{
public class TextSampler
{
    private var _windowSize:int;
    private var buffer:String;
    private var bufptr:int;

    private var root:Object;
    private var chars:Object;

    public function TextSampler(windowSize:int)
    {
        root = { };
        chars = { };
        _windowSize = windowSize;
        restart();
    }

    public function get windowSize():int
    {
        return _windowSize;
    }

    public function restart():void
    {
        buffer = "";
        bufptr = -_windowSize + 1;
    }

    public function sampleText(text:String):void
    {
        buffer += text;
        processBuffer();
    }

    public function getTextStats():TextStats
    {
        return new TextStats(root, _windowSize);
    }

    private function processBuffer():void
    {
        var i:int;
        var max:int;

        if (buffer.length < _windowSize) return;

        max = buffer.length - _windowSize;
        for (i = bufptr; i < max; i++)
        {
            sampleBuffer(i);
        }
        buffer = buffer.substr(i);
        bufptr = 0;
    }

    private function sampleBuffer(i:int):void
    {
        var max:int = i + _windowSize - 1;
        var node:Object = root;
        var char:String;

        while (i <= max)
        {
            char = i >= 0 ? buffer.charAt(i)
                          : "NUL";

            chars[char] = true;

            if (i == max)
            {
                if (node.hasOwnProperty(char))
                {
                    node[char] += 1;
                }
                else
                {
                    node[char] = 1;
                }
            }
            else
            {
                if (node.hasOwnProperty(char))
                {
                    node = node[char];
                }
                else
                {
                    node = (node[char] = { });
                }
            }
            i++;
        }
    }
}
}
