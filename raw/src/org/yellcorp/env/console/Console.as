package org.yellcorp.env.console
{
import org.yellcorp.ui.BaseDisplay;
import org.yellcorp.ui.scrollbar.VerticalScrollBar;

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


public class Console extends BaseDisplay
{
    private static const NONE:int = 0;
    private static const FIELD:int = 1;
    private static const BAR:int = 2;

    private var consoleText:TextField;
    private var scrollbar:VerticalScrollBar;

    private var invalidScroll:int = NONE;

    public function Console()
    {
        super();
        initDisplay();
    }

    public function write(... args):void
    {
        var pin:Boolean = isScrollPinned();
        consoleText.appendText(args.join(""));
        if (pin) pinScroll();
    }

    private function isScrollPinned():Boolean
    {
        return consoleText.scrollV >= (consoleText.maxScrollV - 1);
    }

    private function pinScroll():void
    {
        consoleText.scrollV = consoleText.maxScrollV;
    }

    private function invalidateScroll(type:int):void
    {
        if (type > invalidScroll)
        {
            invalidScroll = type;
            invalidate();
        }
    }

    public function writeln(... args):void {
        write(args.join("")+"\n");
    }

    protected function getTextFormat():TextFormat {
        var tf:TextFormat = new TextFormat();
        tf.color = 0;
        tf.font = "Consolas";
        tf.size = 11;

        return tf;
    }

    protected override function draw():void
    {
        var pin:Boolean;
        if (invalidSize)
        {
            pin = isScrollPinned();
            setSizeOn(consoleText, width - scrollbar.width, height);
            setSizeOn(scrollbar, scrollbar.width, height);
            scrollbar.x = consoleText.width;
            if (pin) pinScroll();
            invalidateScroll(FIELD);
            invalidSize = false;
        }

        if (invalidScroll == FIELD)
        {
            scrollbar.maxScroll = consoleText.maxScrollV;
            scrollbar.currentScroll = consoleText.scrollV;
        }
        else if (invalidScroll == BAR)
        {
            scrollbar.maxScroll = consoleText.maxScrollV;
            consoleText.scrollV = Math.round(scrollbar.currentScroll);
        }
        invalidScroll = NONE;
    }

    private function getTextField():TextField {
        var tf:TextField = new TextField();
        tf.autoSize = TextFieldAutoSize.NONE;
        tf.background = false;
        tf.border = false;
        tf.defaultTextFormat = getTextFormat();
        tf.multiline = true;
        tf.selectable = true;
        tf.wordWrap = true;

        return tf;
    }

    private function initDisplay():void {
        addChild(consoleText = getTextField());
        addChild(scrollbar = new VerticalScrollBar(new SimpleScrollBarSkin()));

        consoleText.addEventListener(Event.SCROLL, onScrollFromText, false, 0, true);

        scrollbar.minScroll = 1;
        scrollbar.maxScroll = 1;
        scrollbar.currentScroll = 1;
        scrollbar.arrowStep = 1;
        scrollbar.minCursorSize = 6;
        scrollbar.addEventListener(Event.SCROLL, onScrollFromBar, false, 0, true);
    }

    private function onScrollFromText(event:Event):void
    {
        invalidateScroll(FIELD);
    }

    private function onScrollFromBar(event:Event):void
    {
        invalidateScroll(BAR);
    }
}
}
