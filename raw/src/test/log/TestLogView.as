package test.log
{
import org.yellcorp.env.ResizableStage;

import wip.yellcorp.log.LogView;


public class TestLogView extends ResizableStage
{
    private var logView:LogView;

    public function TestLogView()
    {
        super();
        addChild(logView = new LogView());

        logView.print("Hello\n");
        logView.printStyle("Oh shit nigs\n", "error");
        logView.print("It's me again\n");
        logView.printStyle("How about I get Korean on your arse: 대한민국 도메인 등록 1위, 도메인 분야 점유율 1위, 도메인 등록, 도메인 연장, 도메인 이전.\n", "warning");
        logView.print("That was just the first Google result for site:.kr, I think it's something about registering domain names.\n");
        logView.print("Here's the word Korean again, gonna use it to try hilighting. This is going to be great. I'm tingling.");

        logView.hilightString("hello", false);
    }

    protected override function onStageResize():void
    {
        logView.width = stage.stageWidth;
        logView.height = stage.stageHeight;
    }
}
}
