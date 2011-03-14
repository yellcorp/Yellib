package org.yellcorp.lib.text.markov
{
public class TextGenerator
{
    private var _stats:TextStats;
    private var _stateSize:int;

    private var _stateChars:Array;

    public function TextGenerator(stats:TextStats)
    {
        _stats = stats;
        _stateSize = stats.windowSize - 1;
        reset();
    }

    public function reset():void
    {
        setState("");
    }

    public function generateText(charCount:int):String
    {
        var outBuffer:String = "";
        for (var i:int = 0; i < charCount; i++)
        {
            outBuffer += advance();
        }
        return outBuffer;
    }

    public function advance():String
    {
        var vector:Object = _stats.getVector(_stateChars);
        var selector:Number = Math.random();
        var nextChar:String = TextStats.choose(vector, selector);

        _stateChars.shift();
        _stateChars.push(nextChar);

        return nextChar;
    }

    public function setState(string:String):void
    {
        var i:int;
        var diff:int = string.length - _stateSize;

        _stateChars = new Array(_stateSize);
        for (i = 0; i < _stateSize; i++)
        {
            _stateChars[i] = string.charAt(i + diff);
        }
    }

    public function get stats():TextStats
    {
        return _stats;
    }
}
}
