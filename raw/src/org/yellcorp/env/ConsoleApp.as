package org.yellcorp.env
{
import org.yellcorp.env.console.Console;


public class ConsoleApp extends ResizableStage
{
    private var console:Console;
    private var _consoleFraction:Number = 1;
    private var relativeSize:Boolean = true;

    public function ConsoleApp()
    {
        addChild(console = new Console());
        super();
    }

    protected function write(... args):void {
        console.write(args.join(""));
    }

    protected function writeln(... args):void {
        console.writeln(args.join(""));
    }

    public function get consoleHeight():Number
    {
        return console.height;
    }

    public function set consoleHeight(v:Number):void
    {
        relativeSize = false;
        console.height = v;
        onStageResize();
    }

    public function get consoleFraction():Number
    {
        if (relativeSize) {
            return _consoleFraction;
        } else if (stage) {
            return console.height / stage.stageHeight;
        } else {
            return Number.NaN;
        }
    }

    public function set consoleFraction(v:Number):void
    {
        relativeSize = true;
        _consoleFraction = v;
        onStageResize();
    }

    protected override function onStageResize():void
    {
        if (relativeSize)
        {
            console.height = _consoleFraction * stage.stageHeight;
        }
        console.y = stage.stageHeight - console.height;
        console.width = stage.stageWidth;
    }
}
}
