package org.yellcorp.lib.text.highlighter
{
import org.yellcorp.lib.text.highlighter.shapes.MultiLineTextRun;
import org.yellcorp.lib.text.highlighter.shapes.SingleLineTextRun;
import org.yellcorp.lib.text.highlighter.utils.RangeStore;
import org.yellcorp.lib.text.highlighter.utils.TextFieldMeasurer;

import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;


public class TextFieldHighlighter
{
    public static const TEXTFIELD_GUTTER:int = 2;

    private var _field:TextField;
    private var indexLengths:RangeStore;
    private var measurer:TextFieldMeasurer;

    private var highlightDrawer:HighlightDrawer;

    public function TextFieldHighlighter(sourceField:TextField, drawer:HighlightDrawer)
    {
        indexLengths = new RangeStore();

        _field = sourceField;
        _field.addEventListener(Event.SCROLL, onFieldScroll);
        _field.addEventListener(Event.CHANGE, onFieldChange);

        highlightDrawer = drawer;

        measurer = new TextFieldMeasurer(_field);
    }

    public function clear():void
    {
        indexLengths.clear();
    }

    public function getHighlightLength(startIndex:int):int
    {
        return indexLengths.getLength(startIndex);
    }

    public function setHighlightLength(startIndex:int, length:int):void
    {
        if (length == 0)
        {
            removeHighlight(startIndex);
        }
        else
        {
            indexLengths.setLength(startIndex, length);
            // invalidate hilight change startIndex
            draw();
        }
    }

    public function removeHighlight(startIndex:int):Boolean
    {
        return indexLengths.deleteRange(startIndex);
        // invalidate hilight remove startIndex
        draw();
    }

    public function draw():void
    {
        var range:Object;
        highlightDrawer.setScrollRect(_field.scrollH, measurer.scrollVPixels, _field.width, _field.height);
        highlightDrawer.clearTextRuns();
        for each (range in getVisibleRanges())
        {
            highlightDrawer.drawTextRun(getRangeShape(range.start, range.length));
        }
    }

    private function getVisibleRanges():Array
    {
        return indexLengths.getRangesInRange(
            measurer.firstVisibleCharIndex,
            measurer.lastVisibleCharIndex);
    }

    private function getRangeShape(start:int, length:int):TextRunShape
    {
        var end:int;
        var firstCharRect:Rectangle;
        var lastCharRect:Rectangle;

        if (length <= 0) return null;

        end = start + length - 1;

        // TextField.getCharBoundaries returns null for \n and
        // who knows what else - so bump it along until something
        // sticks
        while (!firstCharRect && start <= end)
        {
            firstCharRect = _field.getCharBoundaries(start);
            start++;
        }
        while (!lastCharRect && end > start)
        {
            lastCharRect = _field.getCharBoundaries(end);
            end--;
        }

        if (firstCharRect && lastCharRect)
        {
            if (_field.getLineIndexOfChar(start) ==
                _field.getLineIndexOfChar(end))
            {
                return new SingleLineTextRun(firstCharRect, lastCharRect);
            }
            else
            {
                return new MultiLineTextRun(
                    firstCharRect,
                    lastCharRect,
                    TEXTFIELD_GUTTER,
                    _field.width - TEXTFIELD_GUTTER);
            }
        }
        else if (firstCharRect)
        {
            return new SingleLineTextRun(firstCharRect, null);
        }
        else
        {
            return null;
        }
    }

    private function onFieldScroll(event:Event):void
    {
        // invalidate scroll
        draw();
    }

    private function onFieldChange(event:Event):void
    {
        // invalidate all
        draw();
    }
}
}
