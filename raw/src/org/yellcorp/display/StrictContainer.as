package org.yellcorp.display
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;


public class StrictContainer
{
    private var rootNode:DisplayObjectContainer;

    public function StrictContainer(rootNode:DisplayObjectContainer)
    {
        this.rootNode = rootNode;
    }

    public function getChild(name:String):DisplayObject
    {
        return evalPath(name);
    }

    public function getTextField(name:String):TextField
    {
        return TextField(evalPath(name));
    }

    public function getSimpleButton(name:String):SimpleButton
    {
        return SimpleButton(evalPath(name));
    }

    public function getContainer(name:String):DisplayObjectContainer
    {
        return DisplayObjectContainer(evalPath(name));
    }

    public function getSprite(name:String):Sprite
    {
        return Sprite(evalPath(name));
    }

    public function getMovieClip(name:String):MovieClip
    {
        return MovieClip(evalPath(name));
    }

    public static function from(container:DisplayObjectContainer):StrictContainer
    {
        return new StrictContainer(container);
    }

    private function evalPath(path:String):DisplayObject
    {
        var nodeNames:Array;
        var leafIndex:int;
        var i:int;

        var containerNode:DisplayObjectContainer;
        var displayNode:DisplayObject;

        nodeNames = path.split('.');
        leafIndex = nodeNames.length - 1;

        containerNode = rootNode;

        for (i = 0; i < leafIndex; i++)
        {
            displayNode = containerNode.getChildByName(nodeNames[i]);
            containerNode = displayNode as DisplayObjectContainer;
            if (!containerNode)
            {
                if (!displayNode)
                {
                    throw new ArgumentError( nodeNames.slice(0, i+1).join(".") +
                                             " is not a DisplayObjectContainer" );
                }
                else
                {
                    throw new ArgumentError( nodeNames.slice(0, i).join(".") +
                                             " has no child with name " +
                                             nodeNames[i] );
                }
            }
        }

        displayNode = containerNode.getChildByName(nodeNames[leafIndex]);
        if (!displayNode)
        {
            throw new ArgumentError( nodeNames.slice(0, leafIndex).join(".") +
                                     " has no child with name " +
                                     nodeNames[leafIndex] );
        }

        return displayNode;
    }
}
}
