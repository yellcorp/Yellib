package scratch
{
import fl.text.TLFTextField;

import fla.yellcorp.lib.display.inject.TestDialog;

import org.yellcorp.lib.display.inject.DisplayInjector;

import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.text.TextField;


public class TestDisplayInjector extends Sprite
{
    [Display]
    public var background:MovieClip;

    [Display]
    public var classicField:TextField;

    [Display(name="button.buttonLabel")]
    public var buttonLabel:MovieClip;

    [Display]
    public var textField:TLFTextField;

    public var someOtherThing:String;

    private var _button:MovieClip;

    [Display]
    public function get button():MovieClip
    {
        return _button;
    }

    public function set button(button:MovieClip):void
    {
        _button = button;
    }

    public function TestDisplayInjector()
    {
        addEventListener(Event.ADDED_TO_STAGE, onStage);
        var view:DisplayObjectContainer = new TestDialog();
        DisplayInjector.inject(view, this);
    }

    private function onStage(event:Event):void
    {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
    }
}
}
