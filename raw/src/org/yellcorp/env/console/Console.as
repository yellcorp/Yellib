package org.yellcorp.env.console
{
import org.yellcorp.display.Resizer;

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


public class Console extends Resizer
{
    private var consoleText:TextField;
    private var scrollbar:Scrollbar;
    private var scrollPin:Boolean = true;

    public function Console()
    {
        super();
        initDisplay();
    }

    public function write(... args):void {
        consoleText.appendText(args.join(""));

        if (scrollPin)
            consoleText.scrollV = consoleText.maxScrollV;

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

    protected override function onResize():void
    {
        //trace(scrollPin);

        consoleText.width = scrollbar.x = nominalWidth - scrollbar.width;
        consoleText.height = scrollbar.height = nominalHeight;

        if (scrollPin)
            consoleText.scrollV = consoleText.maxScrollV;

        updateScrollbar();
    }

    private function updateScrollbar():void
    {
        scrollbar.maxValue = consoleText.maxScrollV;
        scrollbar.value = consoleText.scrollV;
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
        addChild(scrollbar = new Scrollbar(new GraphicsScrollParts()));

        consoleText.addEventListener(Event.SCROLL, onScrollFromText, false, 0, true);

        scrollbar.minValue = 1;
        scrollbar.maxValue = consoleText.maxScrollV;
        scrollbar.value = consoleText.scrollV;
        scrollbar.arrowStep = 1;
        scrollbar.minCursorSize = 6;
        scrollbar.addEventListener(Event.SCROLL, onScrollFromBar, false, 0, true);
    }

    private function onScrollFromText(event:Event):void
    {
        scrollbar.value = consoleText.scrollV;
        scrollPin = consoleText.scrollV == consoleText.maxScrollV;
    }

    private function onScrollFromBar(event:Event):void
    {
        consoleText.scrollV = Math.round(scrollbar.value);
        scrollPin = consoleText.scrollV == consoleText.maxScrollV;
    }
}
}
