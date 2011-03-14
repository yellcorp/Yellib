package org.yellcorp.lib.text.highlighter.utils
{
import flash.events.Event;
import flash.text.TextField;
import flash.utils.Dictionary;


public class TextFieldMeasurer
{
    private var _field:TextField;

    private var lastWidth:Number;
    private var lastHeight:Number;

    private var cacheFirstVisChar:Number;
    private var cacheLastVisChar:Number;
    private var cacheScrollVPixels:Number;

    private var memoLineHeight:Dictionary;
    private var memoLineY:Dictionary;

    public function TextFieldMeasurer(newField:TextField)
    {
        field = newField;
    }

    public function get field():TextField
    {
        return _field;
    }

    public function set field(newField:TextField):void
    {
        if (_field == newField) return;

        if (_field)
        {
            _field.removeEventListener(Event.SCROLL, onFieldScroll);
            _field.removeEventListener(Event.CHANGE, onFieldChange);
        }

        _field = newField;

        if (_field)
        {
            _field.addEventListener(Event.SCROLL, onFieldScroll, false, int.MAX_VALUE);
            _field.addEventListener(Event.CHANGE, onFieldChange, false, int.MAX_VALUE);
        }
        lastWidth = Number.NaN;
        lastHeight = Number.NaN;
        clearCache();
        clearMemos();
    }

    public function get firstVisibleCharIndex():int
    {
        checkResize();
        if (!isFinite(cacheFirstVisChar))
        {
            cacheFirstVisChar = _field.getLineOffset(_field.scrollV - 1);
        }
        return cacheFirstVisChar;
    }

    public function get lastVisibleCharIndex():int
    {
        var bottomLineIndex:int;
        checkResize();
        if (!isFinite(cacheLastVisChar))
        {
            bottomLineIndex = _field.bottomScrollV - 1;
            cacheLastVisChar = field.getLineOffset(bottomLineIndex) +
                               field.getLineLength(bottomLineIndex);
        }
        return cacheLastVisChar;
    }

    public function get scrollVPixels():int
    {
        checkResize();
        if (!isFinite(cacheScrollVPixels))
        {
            cacheScrollVPixels = getLineY(_field.scrollV - 1);
        }
        return cacheScrollVPixels;
    }

    public function getLineY(lineIndex:int):Number
    {
        var y:Number = 0;
        var scan:int = lineIndex;

        while (scan > 0)
        {
            if (memoLineY && memoLineY.hasOwnProperty(scan))
            {
                y += memoLineY[scan];
                break;
            }
            else
            {
                y += getLineHeight(scan - 1);
                scan--;
            }
        }
        if (scan != lineIndex)
        {
            if (!memoLineY) memoLineY = new Dictionary();
            memoLineY[lineIndex] = y;
        }

        return y;
    }

    public function getLineHeight(lineIndex:int):Number
    {
        var height:Number = 0;
        if (memoLineHeight && memoLineHeight.hasOwnProperty(lineIndex))
        {
            height = memoLineHeight[lineIndex];
        }
        else
        {
            if (!memoLineHeight) memoLineHeight = new Dictionary();
            height = memoLineHeight[lineIndex] =
                _field.getLineMetrics(lineIndex).height;
        }
        return height;
    }

    private function checkResize():void
    {
        if (_field.width != lastWidth || _field.height != lastHeight)
        {
            lastWidth = _field.width;
            lastHeight = _field.height;
            clearCache();
        }
    }

    private function onFieldScroll(event:Event):void
    {
        clearCache();
    }

    private function onFieldChange(event:Event):void
    {
        clearCache();
        clearMemos();
    }

    private function clearCache():void
    {
        cacheScrollVPixels =
        cacheFirstVisChar =
        cacheLastVisChar = Number.NaN;
    }

    private function clearMemos():void
    {
        memoLineHeight = null;
        memoLineY = null;
    }
}
}
