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
    private var consoleText:TextField;
    private var scrollbar:VerticalScrollBar;

    public function Console()
    {
        super();
        initDisplay();
    }

    public function write(... args):void {
        consoleText.appendText(args.join(""));

        /*
        if (scrollPin)
            consoleText.scrollV = consoleText.maxScrollV;
        */

        updateScrollbar();
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

    protected override function onRender(event:Event):void
    {
        consoleText.width = scrollbar.x = width - scrollbar.width;
        consoleText.height = scrollbar.height = height;

        updateScrollbar();

        /*
        if (scrollPin)
            consoleText.scrollV = consoleText.maxScrollV;
             */
    }

    private function updateScrollbar():void
    {
        scrollbar.maxScroll = consoleText.maxScrollV;
        scrollbar.currentScroll = consoleText.scrollV;
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
        scrollbar.currentScroll = consoleText.scrollV;
//            scrollPin = consoleText.scrollV == consoleText.maxScrollV;
        }

        private function onScrollFromBar(event:Event):void
        {
            consoleText.scrollV = Math.round(scrollbar.currentScroll);
//            scrollPin = consoleText.scrollV == consoleText.maxScrollV;
        }
    }
}
