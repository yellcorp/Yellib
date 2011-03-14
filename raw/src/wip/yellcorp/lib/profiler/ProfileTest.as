package wip.yellcorp.lib.profiler
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;


public class ProfileTest extends Sprite
{
    private var startButton:UglyButton;
    private var stopButton:UglyButton;
    private var canvas:Sprite;
    private var ssession:SamplerSession;

    public function ProfileTest()
    {
        ssession = new SamplerSession();

        addChild(canvas = new Sprite());
        addChild(startButton = new UglyButton("Start", 0x44ff44, 0));
        addChild(stopButton = new UglyButton("Stop", 0xCC0000, 0xffffff));

        stopButton.x = startButton.x + startButton.width;

        startButton.addEventListener(MouseEvent.CLICK, onStartClick);
        stopButton.addEventListener(MouseEvent.CLICK, onStopClick);

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void
    {
        addEventListener(Event.ENTER_FRAME, onFrame);
    }

    private function onFrame(event:Event):void
    {
        var iShape:int;
        var jPoint:int;
        var x:int;
        var y:int;

        canvas.graphics.clear();

        for (iShape = 0; iShape < 20; iShape++)
        {
            canvas.graphics.beginFill(uint(Math.random() * 0x1000000));

            x = Math.random() * 550;
            y = Math.random() * 400;
            canvas.graphics.moveTo(x, y);

            for (jPoint = 0; jPoint < 20; jPoint++)
            {
                x = Math.random() * 550;
                y = Math.random() * 400;
                canvas.graphics.lineTo(x, y);
            }
            canvas.graphics.endFill();
        }
    }

    private function onStartClick(event:MouseEvent):void
    {
        ssession.start();
    }

    private function onStopClick(event:MouseEvent):void
    {
        ssession.stop();
        removeEventListener(Event.ENTER_FRAME, onFrame);
    }
}
}
