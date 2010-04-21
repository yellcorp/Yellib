package org.yellcorp.debug.console.richtext
{
import org.yellcorp.text.TextEventUtil;
import org.yellcorp.text.TextUtil;

import flash.events.Event;
import flash.events.TextEvent;
import flash.text.TextField;
import flash.text.TextFormat;


public class RichTextComposer
{
    private var _targetField:TextField;
    private var fieldFormat:TextFormat;

    private var lowestInvalidBlock:TextBlockState;

    private var list:BlockStateList;
    private var store:BlockStateIndex;

    public function RichTextComposer(targetField:TextField)
    {
        _targetField = targetField;
        _targetField.addEventListener(TextEvent.LINK, onTextLink);
        fieldFormat = _targetField.defaultTextFormat;

        list = new BlockStateList();
        store = new BlockStateIndex();
    }

    public function appendBlock(block:TextBlock):void
    {
        var state:TextBlockState = createState(block);
        if (list.tail)
        {
            state.start = list.tail.start + list.tail.length;
        }
        block.addEventListener(Event.CHANGE, onBlockChange);
        list.append(state);
        store.add(state);
        invalidateBlock(state);
    }

    private function invalidateBlock(block:TextBlockState):void
    {
        block.dirty = true;
        if (!lowestInvalidBlock || block.start < lowestInvalidBlock.start)
        {
            lowestInvalidBlock = block;
        }
    }

    public function composeAll():void
    {
        var state:TextBlockState;
        _targetField.text = "";

        for (state = list.head; state; state = state.next)
        {
            render(state);
        }
        lowestInvalidBlock = null;
    }

    public function compose():void
    {
        var state:TextBlockState = lowestInvalidBlock;

        if (!state) return;

        var start:int = state.start;

        for ( ; state; state = state.next)
        {
            state.start = start;
            if (state.dirty)
            {
                renderIncremental(state);
            }
            start += state.length;
        }
        lowestInvalidBlock = null;
    }

    private function renderIncremental(state:TextBlockState):void
    {
        trace("RichTextComposer.renderIncremental(state.id="+state.id+")");

        var linkData:Object = {id: state.id};
        var linkFormat:TextFormat = TextEventUtil.setLinkFormat(linkData);
        var oldLength:int = state.length;

        var text:String = state.textBlock.getText();

        _targetField.replaceText(state.start, state.start + oldLength, text);

        state.length = text.length;

        _targetField.setTextFormat(linkFormat, state.start, state.start + 1);
        _targetField.setTextFormat(fieldFormat, state.start + 1, state.start + state.length);

        state.dirty = false;
    }

    private function render(state:TextBlockState):void
    {
        trace("RichTextComposer.render(state.id="+state.id+")");

        var linkData:Object = {id: state.id};
        var linkFormat:TextFormat = TextEventUtil.setLinkFormat(linkData);

        var text:String = state.textBlock.getText();

        state.start = _targetField.length;

        _targetField.appendText(text);

        state.length = text.length;

        _targetField.setTextFormat(linkFormat, state.start, state.start + 1);
        _targetField.setTextFormat(fieldFormat, state.start + 1, state.start + state.length);

        state.dirty = false;
    }

    private function onTextLink(event:TextEvent):void
    {
        var linkData:Object = TextEventUtil.decodeEventString(event.text);
        var state:TextBlockState = store.getByID(linkData.id);
        if (state)
        {
            state.textBlock.interact(linkData);
        }
        else
        {
            trace("Block id not found: id=" + linkData.id + " event.text=" + event.text);
        }
    }

    private function onBlockChange(event:Event):void
    {
        invalidateBlock(store.getByBlock(TextBlock(event.target)));
        compose();
    }

    private function createState(block:TextBlock):TextBlockState
    {
        var newState:TextBlockState;
        if (store.getByBlock(block))
        {
            throw new ArgumentError("block already exists");
        }
        newState = new TextBlockState(block, store.getNewID());
        return newState;
    }
}
}

import org.yellcorp.debug.console.richtext.TextBlock;
import org.yellcorp.debug.console.richtext.TextBlockState;

import flash.utils.Dictionary;


internal class BlockStateList
{
    public var head:TextBlockState;
    public var tail:TextBlockState;

    public function append(state:TextBlockState):void
    {
        if (tail)
        {
            TextBlockState.link(tail, state);
            tail = state;
        }
        else
        {
            head = tail = state;
        }
    }
}

internal class BlockStateIndex
{
    private var byBlock:Dictionary;
    private var byID:Object;
    private var nextid:uint = 0;

    public function BlockStateIndex()
    {
        byBlock = new Dictionary();
        byID = { };
    }

    public function add(newState:TextBlockState):void
    {
        byBlock[newState.textBlock] = newState;
        byID[newState.id] = newState;
    }
    public function remove(oldState:TextBlockState):void
    {
        delete byBlock[oldState.textBlock];
        delete byID[oldState.id];
    }
    public function getByBlock(block:TextBlock):TextBlockState
    {
        return byBlock[block];
    }
    public function getByID(id:String):TextBlockState
    {
        return byID[id];
    }
    public function getNewID():String
    {
        var id:String = nextid.toString(36);
        ++nextid;
        return id;
    }
}
