package org.yellcorp.lib.iterators.readonly
{
import org.yellcorp.lib.iterators.readonly.Iterator;


public class StringLineIterator implements Iterator
{
    private var _text:String;
    private var _lineDelimiter:String;
    private var _skipLines:uint;
    private var _index:int;

    private var lines:Array;

    public function StringLineIterator(
        text:String,
        lineDelimiter:String = null,
        skipLines:uint = 0)
    {
        _text = text;
        _lineDelimiter = lineDelimiter;
        _skipLines = skipLines;

        if (lineDelimiter === null)
        {
            lines = _text.split( /\r\n?|\n/ );
        }
        else
        {
            lines = _text.split(lineDelimiter);
        }
        reset();
    }

    public function next():void
    {
        switch (_skipLines)
        {
        case SkipLines.WHITESPACE:
            do {
                _index++;
            } while (_index < lines.length && /^\s*$/ .test(lines[_index]));
            break;

        case SkipLines.ZERO_LENGTH:
            do {
                _index++;
            } while (_index < lines.length && !lines[_index]);
            break;

        default:
            _index++;
            break;
        }
    }

    public function reset():void
    {
        _index = -1;
        next();
    }

    public function get valid():Boolean
    {
        return _index < lines.length;
    }

    public function get current():*
    {
        return lines[_index];
    }

    public function get text():String
    {
        return _text;
    }

    public function get lineDelimiter():String
    {
        return _lineDelimiter;
    }

    public function get skipLines():uint
    {
        return _skipLines;
    }

    public function get lineNumber():int
    {
        return _index;
    }
}
}
