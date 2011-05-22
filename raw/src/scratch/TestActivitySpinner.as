package scratch
{
import org.yellcorp.lib.display.ActivitySpinner;

import flash.display.Sprite;


public class TestActivitySpinner extends Sprite
{
    public function TestActivitySpinner()
    {
        var act:ActivitySpinner = new ActivitySpinner();

        act.petalCount = 12;
        act.idleParams.color = 0xFF0000;
        act.idleParams.width = 2;
        act.idleParams.innerRadius = 8;
        act.idleParams.outerRadius = 16;
//            act.pulseParams = new ActivitySpinnerParams(0xFFFFFF, 1, 2, 8, 48);

            act.pulseParams.color = 0x00FF00;
            act.pulseParams.innerRadius = 10;
            act.pulseParams.outerRadius = 24;
            act.pulseParams.width = 6;

            addChild(act);

            act.x = 100;
            act.y = 100;
        }
    }
}
