package org.yellcorp.lib.env
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;


public class ResizableStage extends Sprite
{
    private var stageAlign:String;
    private var stageVerified:Boolean;

    public function ResizableStage(stageAlign:String = "TL")
    {
        super();
        this.stageAlign = stageAlign;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    // Called on ADDED_TO_STAGE.  Stage is not null and can
    // be manipulated, but dimensions may be set to 0
    protected function onStageAvailable():void
    {
    }

    protected function onStageResize():void
    {
    }

    private function onAddedToStage(event:Event):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        stage.addEventListener(Event.RESIZE, suppressStageResize, false, int.MAX_VALUE);

        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        onStageAvailable();

        checkStage();
        if (!stageVerified)
        {
            // This means the stage is reporting its dimensions as 0x0.
            // Set up a listener on ENTER_FRAME to poll for valid
            // dimensions.
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
    }

    private function onEnterFrame(event:Event):void
    {
        checkStage();
        if (stageVerified)
        {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
    }

    private function checkStage():void
    {
        if (!stageVerified && stage &&
                stage.stageWidth > 0 && stage.stageHeight > 0)
        {
            stageVerified = true;
            stage.removeEventListener(Event.RESIZE, suppressStageResize);
            stage.addEventListener(Event.RESIZE, callStageResize);
            stage.dispatchEvent(new Event(Event.RESIZE));
        }
    }

    private function suppressStageResize(event:Event):void
    {
        if (!stageVerified)
        {
            event.stopImmediatePropagation();
        }
    }

    private function callStageResize(event:Event):void
    {
        onStageResize();
    }
}
}
