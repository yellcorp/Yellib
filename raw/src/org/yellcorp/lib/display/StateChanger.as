package org.yellcorp.lib.display
{
import flash.display.FrameLabel;
import flash.display.MovieClip;
import flash.events.Event;
import flash.utils.Dictionary;


public class StateChanger extends MovieClip
{
    /*
     * Use names without underscores to indicate
     * states to stop on
     *
     * Create state transitions by naming the first frame
     * start_FROMSTATE_TOSTATE
     *
     * and the last
     * end_FROMSTATE_TOSTATE
     *
     * if transitions are available, will play them.
     * if reverse transition is availale, will play backwards
     * otherwise will just jump straight to label
     *
     * The end_ labels are optional, playback will stop at the
     * first label it encounters (or the end of the timeline)
     * but if they are omitted then it won't be able to find
     * reverse transitions
     */

    private var labelToFrame:Dictionary;
    private var _state:String;
    private var targetState:String = _state;

    private var stopFrameNumber:int;
    private var playing:Boolean = false;

    private var frameStep:int = 1;

    public function StateChanger()
    {
        super();
        labelToFrame = new Dictionary();
        collectLabels();
        goToState('default', true);
    }

    public function get state():String
    {
        return _state;
    }

    public function set state(v:String):void
    {
        transitionToState(v);
    }

    private function transitionToState(whichState:String):void
    {
        if (!transitionForward(_state, whichState))
        {
            if (!transitionBackward(_state, whichState))
            {
                goToState(whichState, true);
            }
        }
    }

    private function goToState(whichState:String, dispatchEvents:Boolean):void
    {
        var queryLabel:String;
        queryLabel = getStateName(whichState);
        if (labelExists(queryLabel))
        {
            if (playing)
            {
                stopFrameListener(true);
            }
            if (dispatchEvents) dispatchStart(whichState);
            gotoAndStop(labelToFrame[queryLabel]);
            if (dispatchEvents) dispatchEnd(whichState);
            _state = whichState;
        }
        else
        {
            trace(this.name + ":StateChanger WARNING: No label for state " + whichState);
            dispatchEvent(new StateChangeEvent(StateChangeEvent.STATE_NOT_FOUND, whichState, true, false));
        }
    }

    private function transitionForward(fromState:String, toState:String):Boolean
    {
        var queryLabel:String = getTransitionStartName(fromState, toState);
        if (!labelExists(queryLabel))
        {
            return false;
        }
        targetState = toState;
        playTransition(labelToFrame[queryLabel], 1);
        return true;
    }

    private function transitionBackward(fromState:String, toState:String):Boolean
    {
        var queryLabel:String = getTransitionEndName(toState, fromState);
        if (!labelExists(queryLabel))
        {
            return false;
        }
        targetState = toState;
        playTransition(labelToFrame[queryLabel], -1);
        return true;
    }

    private function playTransition(startFrameNum:int, direction:int):void
    {
        frameStep = direction;
        stopFrameNumber = direction > 0 ? getLabelAfter(startFrameNum) : getLabelBefore(startFrameNum);
        if (playing)
        {
            stopFrameListener(true);
        }
        gotoAndStop(startFrameNum);
        startFrameListener();
        dispatchStart(targetState);
    }

    private function startFrameListener():void
    {
        playing = true;
        addEventListener(Event.ENTER_FRAME, onFrame);
    }

    private function stopFrameListener(cancelled:Boolean):void
    {
        playing = false;
        removeEventListener(Event.ENTER_FRAME, onFrame);
        goToState(targetState, false);
        if (cancelled)
        {
            dispatchEvent(new StateChangeEvent(StateChangeEvent.STATE_CHANGE_CANCEL, targetState, true, false));
        }
        else
        {
            dispatchEnd(targetState);
        }
    }

    private function onFrame(event:Event):void
    {
        if (frameStep > 0 && (currentFrame >= stopFrameNumber || currentFrame >= totalFrames))
        {
            stopFrameListener(false);
        }
        else if (frameStep < 0 && (currentFrame <= stopFrameNumber || currentFrame <= 1))
        {
            stopFrameListener(false);
        }
        else if (frameStep == 0)
        {
            stopFrameListener(false);
            trace("WARNING: stopFrameNumber was 0");
        }
        else
        {
            gotoAndStop(currentFrame + frameStep);
        }
    }

    private function getLabelAfter(whichFrame:int):int
    {
        var label:FrameLabel;
        var frameAfter:int = int.MAX_VALUE;

        for each (label in currentLabels)
        {
            if (label.frame > whichFrame)
            {
                frameAfter = Math.min(frameAfter, label.frame);
            }
        }

        if (frameAfter > totalFrames)
        {
            frameAfter = totalFrames;
        }
        return frameAfter;
    }

    private function getLabelBefore(whichFrame:int):int
    {
        var label:FrameLabel;
        var frameBefore:int = int.MIN_VALUE;

        for each (label in currentLabels)
        {
            if (label.frame < whichFrame)
            {
                frameBefore = Math.max(frameBefore, label.frame);
            }
        }

        if (frameBefore < 1)
        {
            frameBefore = 1;
        }
        return frameBefore;
    }

    private function getStateName(state:String):String
    {
        //return "state_"+state;

        // why not simplify
        return state;
    }

    private function getTransitionStartName(fromState:String, toState:String):String
    {
        return "start_" + fromState + "_" + toState;
    }

    private function getTransitionEndName(fromState:String, toState:String):String
    {
        return "end_" + fromState + "_" + toState;
    }

    private function labelExists(name:String):Boolean
    {
        return labelToFrame[name] != null;
    }

    private function collectLabels():void
    {
        var label:FrameLabel;

        for each (label in currentLabels)
        {
            if (labelToFrame[label.name] == null)
            {
                labelToFrame[label.name] = label.frame;
            } else {
                //trace(this.name + ":StateChanger WARNING: Ignoring duplicate " + labelToString(label));
            }
        }
    }

    private function labelToString(label:FrameLabel):String
    {
        return "Label '" + label.name + "' at frame " + label.frame;
    }

    private function dispatchStart(stateName:String):void
    {
        dispatchEvent(new StateChangeEvent(StateChangeEvent.STATE_CHANGE_START, stateName, true, false));
    }

    private function dispatchEnd(stateName:String):void
    {
        dispatchEvent(new StateChangeEvent(StateChangeEvent.STATE_CHANGE_END, stateName, true, false));
    }
}
}
