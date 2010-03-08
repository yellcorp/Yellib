package org.yellcorp.env
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;


public class ResizableStage extends Sprite
{
    public function ResizableStage()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, _onStageAvailable);
    }

    // Called on ADDED_TO_STAGE.  Stage is ont null and can
    // have listeners attached, but dimensions will be set to 0
    protected function onStageAvailable():void
    {
    }

    // Called on the first ENTER_FRAME
    protected function onFirstFrame():void
    {
    }

    // Called on the first RESIZE after onFirstFrame, and on all
    // subsequent resizes.  Resize handlers should override this
    protected function onStageResize():void
    {
    }

    private function _onStageAvailable(event:Event):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _onStageAvailable);
        onStageAvailable();

        stage.addEventListener(Event.ENTER_FRAME, _onFirstFrame);
        stage.addEventListener(Event.RESIZE, _onStageResize);

        stage.align = StageAlign.TOP_LEFT;

        // setting this triggers the first Event.RESIZE
        stage.scaleMode = StageScaleMode.NO_SCALE;
    }

    private function _onFirstFrame(event:Event):void
    {
        stage.removeEventListener(Event.ENTER_FRAME, _onFirstFrame);
        onFirstFrame();
    }

    private function _onStageResize(event:Event):void
    {
        onStageResize();
    }
}
}
