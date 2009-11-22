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

    protected function onStageAvailable():void
    {
    }

    protected function onStageResize():void
    {
    }

    private function _onStageAvailable(event:Event):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _onStageAvailable);
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        onStageAvailable();
        onStageResize();
        stage.addEventListener(Event.RESIZE, _onStageResize);
    }

    private function _onStageResize(event:Event):void
    {
        onStageResize();
    }
}
}
