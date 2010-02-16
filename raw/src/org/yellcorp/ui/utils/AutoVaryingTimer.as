package org.yellcorp.ui.utils
{
import flash.events.TimerEvent;
import flash.utils.Timer;


public class AutoVaryingTimer extends Timer
{
    private var delay1:Number;
    private var delay2:Number;
    private var changeRepeat:int;
    private var changesLeft:int;

    public function AutoVaryingTimer(initialDelay:Number, delayAfterChange:Number, repeatCountBeforeChanging:int, totalRepeatCount:int = 0)
    {
        super(initialDelay, totalRepeatCount);

        delay1 = initialDelay;
        delay2 = delayAfterChange;
        changesLeft = changeRepeat = repeatCountBeforeChanging;

        addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
    }

    public override function reset():void
    {
        super.reset();
        delay = delay1;
        changesLeft = changeRepeat;
    }

    private function onTimer(event:TimerEvent):void
    {
        if (changesLeft > 0)
        {
            changesLeft--;
            if (changesLeft == 0)
            {
                delay = delay2;
            }
        }
    }
}
}
