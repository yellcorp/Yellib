package wip.yellcorp.lib.display
{
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.geom.Rectangle;


public class StageProxy implements IEventDispatcher
{
    private var onStage:Boolean;
    private var display:DisplayObject;
    private var impl:StageProxyImpl;
    
    public function StageProxy(displayObject:DisplayObject)
    {
        onStage = false;
        display = displayObject;
        impl = new InvocationQueue();
        
        display.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
        display.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
        
        if (display.stage)
        {
            onAddedToStage(null);
        }
    }
    
    public function get align():String
    {
        return impl.align;
    }
    
    public function set align(new_align:String):void
    {
        impl.align = new_align;
    }
    
    public function get allowsFullScreen():Boolean
    {
        return impl.allowsFullScreen;
    }
    
    public function get color():uint
    {
        return impl.color;
    }
    
    public function set color(new_color:uint):void
    {
        impl.color = new_color;
    }
    
    public function get displayState():String
    {
        return impl.displayState;
    }
    
    public function set displayState(new_displayState:String):void
    {
        impl.displayState = new_displayState;
    }
    
    public function get focus():InteractiveObject
    {
        return impl.focus;
    }
    
    public function set focus(new_focus:InteractiveObject):void
    {
        impl.focus = new_focus;
    }
    
    public function get frameRate():Number
    {
        return impl.frameRate;
    }
    
    public function set frameRate(new_frameRate:Number):void
    {
        impl.frameRate = new_frameRate;
    }
    
    public function get fullScreenHeight():uint
    {
        return impl.fullScreenHeight;
    }
    
    public function get fullScreenSourceRect():Rectangle
    {
        return impl.fullScreenSourceRect;
    }
    
    public function set fullScreenSourceRect(new_fullScreenSourceRect:Rectangle):void
    {
        impl.fullScreenSourceRect = new_fullScreenSourceRect;
    }
    
    public function get fullScreenWidth():uint
    {
        return impl.fullScreenWidth;
    }
    
    public function get quality():String
    {
        return impl.quality;
    }
    
    public function set quality(new_quality:String):void
    {
        impl.quality = new_quality;
    }
    
    public function get scaleMode():String
    {
        return impl.scaleMode;
    }
    
    public function set scaleMode(new_scaleMode:String):void
    {
        impl.scaleMode = new_scaleMode;
    }
    
    public function get showDefaultContextMenu():Boolean
    {
        return impl.showDefaultContextMenu;
    }
    
    public function set showDefaultContextMenu(new_showDefaultContextMenu:Boolean):void
    {
        impl.showDefaultContextMenu = new_showDefaultContextMenu;
    }
    
    public function get stageFocusRect():Boolean
    {
        return impl.stageFocusRect;
    }
    
    public function set stageFocusRect(new_stageFocusRect:Boolean):void
    {
        impl.stageFocusRect = new_stageFocusRect;
    }
    
    public function get stageHeight():int
    {
        return impl.stageHeight;
    }
    
    public function set stageHeight(new_stageHeight:int):void
    {
        impl.stageHeight = new_stageHeight;
    }
    
    public function get stageWidth():int
    {
        return impl.stageWidth;
    }
    
    public function set stageWidth(new_stageWidth:int):void
    {
        impl.stageWidth = new_stageWidth;
    }
    
    public function get wmodeGPU():Boolean
    {
        return impl.wmodeGPU;
    }
    
    public function invalidate():void
    {
        impl.invalidate();
    }
    
    public function isFocusInaccessible():Boolean
    {
        return impl.isFocusInaccessible();
    }
    
    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
        impl.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public function dispatchEvent(event:Event):Boolean
    {
        return impl.dispatchEvent(event);
    }

    public function hasEventListener(type:String):Boolean
    {
        return impl.hasEventListener(type);
    }

    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {
        impl.removeEventListener(type, listener, useCapture);
    }

    public function willTrigger(type:String):Boolean
    {
        return impl.willTrigger(type);
    }

    private function onAddedToStage(event:Event):void
    {
        if (onStage) return;
        
        onStage = true;
        var queue:InvocationQueue = InvocationQueue(impl);
        queue.executeOn(display.stage);
        queue.clear();
        impl = new Passthrough(display.stage);
    }

    private function onRemovedFromStage(event:Event):void
    {
        onStage = false;
        impl = new InvocationQueue();
    }
}
}



import flash.utils.Proxy;
import flash.utils.flash_proxy;


dynamic class StageProxyImpl extends Proxy { }


dynamic class Passthrough extends StageProxyImpl
{
    public var target:*;
    
    public function Passthrough(target:*)
    {
        this.target = target;
    }
    
    override flash_proxy function callProperty(name:*, ...args):*
    {
        return target[name].apply(target, args);
    }
    
    override flash_proxy function getProperty(name:*):*
    {
        return target[name];
    }

    override flash_proxy function setProperty(name:*, value:*):void
    {
        target[name] = value;
    }
}


dynamic class InvocationQueue extends StageProxyImpl
{
    private var invocations:Array;

    public function InvocationQueue()
    {
        clear();
    }

    public function clear():void
    {
        invocations = [ ];
    }

    public function executeOn(target:*):void
    {
        for each (var i:Invocation in invocations)
        {
            i.executeOn(target);
        }
    }
    
    override flash_proxy function callProperty(name:*, ...args):*
    {
        invocations.push(new CallProperty(name, args));
        return undefined;
    }

    override flash_proxy function getProperty(name:*):*
    {
        return undefined;
    }

    override flash_proxy function setProperty(name:*, value:*):void
    {
        invocations.push(new SetProperty(name, value));
    }
}


interface Invocation
{
    function executeOn(target:*):*;
}

class CallProperty implements Invocation
{
    public var name:*;
    public var args:Array;

    public function CallProperty(name:*, args:Array)
    {
        this.name = name;
        this.args = args;
    }

    public function executeOn(target:*):*
    {
        return target[name].apply(target, args);
    }
}

class SetProperty implements Invocation
{
    public var value:*;
    public var name:*;
    
    public function SetProperty(name:*, value:*)
    {
        this.name = name;
        this.value = value;
    }

    public function executeOn(target:*):*
    {
        target[name] = value;
    }
}