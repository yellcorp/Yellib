package wip.yellcorp.display
{
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.utils.Dictionary;


// TODO: hilight when crossing line breaks
// TODO: cache rectangles until textfield resize or scroll
// TODO: work out better storage for indexLengths, perhaps a tree or binary search or somethin

public class TextFieldHighlighter
{
    private var field:TextField;
    private var canvas:Sprite;
    private var canvasRect:Rectangle;
    private var indexLengths:Dictionary;

    private var lastMeasuredScrollV:int = -1;
    private var lastScrollVPixels:int = -1;

    public function TextFieldHighlighter(textField:TextField, hilightCanvas:Sprite)
    {
        indexLengths = new Dictionary();
        canvasRect = new Rectangle();

        field = textField;
        canvas = hilightCanvas;

        field.addEventListener(Event.SCROLL, onFieldScroll, false, 0, true);
        field.addEventListener(Event.CHANGE, onFieldChange, false, 0, true);
    }

    public function clear():void
    {
        indexLengths = new Dictionary();
        canvas.graphics.clear();
    }

    public function getHilightRangeLength(startIndex:int):int
    {
        if (indexLengths.hasOwnProperty(startIndex))
        {
            return indexLengths[startIndex];
        }
        else
        {
            return 0;
        }
    }

    public function setHilightRange(startIndex:int, length:int):void
    {
        var oldVal:int = indexLengths[startIndex];

        indexLengths[startIndex] = length;

        if (!oldVal)
        {
            drawHilight(startIndex, length);
        }
        else
        {
            redraw();
        }
    }

    public function removeHilightRange(startIndex:int):void
    {
        indexLengths[startIndex] = 0;
    }

    public function redraw():void
    {
        var key:*;
        var start:int;
        var length:int;

        canvas.graphics.clear();

        canvasRect.x = field.scrollH;
        canvasRect.y = getScrollVPixels();
        canvasRect.width = field.width;
        canvasRect.height = field.height;

        canvas.scrollRect = canvasRect;

        for (key in indexLengths)
        {
            start = int(key);
            length = int(indexLengths[key]);

            drawHilight(start, length);
        }
    }

    private function drawHilight(startIndex:int, length:int):void
    {
        var firstCharRect:Rectangle;
        var lastCharRect:Rectangle;
        var lastIndex:int;

        if (length <= 0) return;

        lastIndex = startIndex + length - 1;

        // TextField.getCharBoundaries returns null for \n and
        // who knows what else - so bump it along until something
        // sticks
        while (!firstCharRect && startIndex <= lastIndex)
        {
            firstCharRect = field.getCharBoundaries(startIndex);
            startIndex++;
        }
        while (!lastCharRect && lastIndex > startIndex)
        {
            lastCharRect = field.getCharBoundaries(lastIndex);
            lastIndex--;
        }

        if (firstCharRect && lastCharRect)
        {
            drawRect(firstCharRect.union(lastCharRect));
        }
        else if (firstCharRect)
        {
            drawRect(firstCharRect);
        }
        /*
        else
        {
            trace("TextFieldHighlighter.drawHilight(): No rects returned!");
        }
         */
    }

    private function getScrollVPixels():int
    {
        if (lastScrollVPixels >= 0 && lastMeasuredScrollV >= 0 &&
            field.scrollV == lastMeasuredScrollV)
        {
            return lastScrollVPixels;
        }

        var charAtFirstLine:int;
        var firstCharBounds:Rectangle;

        if (field.text.length == 0)
        {
            return 0;
        }

        charAtFirstLine = field.getLineOffset(field.scrollV - 1);
        firstCharBounds = field.getCharBoundaries(charAtFirstLine);

        lastMeasuredScrollV = field.scrollV;

        // -2 corrects for the inbuilt 2 pixel padding that is hardcoded
        // into TextFields and is accounted for in the API when they
        // feel like it
        return lastScrollVPixels = firstCharBounds.y - 2;
    }

    private function drawRect(rect:Rectangle):void
    {
        var g:Graphics = canvas.graphics;
        var padx:Number = 0;
        var pady:Number = 1;

        g.beginFill(0xFFFFFF);
        g.drawRoundRect(rect.x - padx,
                        rect.y - pady,
                        rect.width + padx * 2,
                        rect.height + pady * 2,
                        8);
        g.endFill();
    }

    private function onFieldChange(event:Event):void
    {
        redraw();
    }

    private function onFieldScroll(event:Event):void
    {
        redraw();
    }
}
}
