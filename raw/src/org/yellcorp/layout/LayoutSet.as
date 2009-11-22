package org.yellcorp.layout
{

public class LayoutSet implements Layout
{
    private var links:Array;

    public function LayoutSet()
    {
        links = [];
    }

    public function addLayout(newLink:Layout):void
    {
        links.push(newLink);
    }

    public function captureLayout():void
    {
        var i:int;
        for (i = 0; i < links.length; i++)
        {
            Layout(links[i]).captureLayout();
        }
    }

    public function updateLayout():void
    {
        var i:int;
        for (i = 0; i < links.length; i++)
        {
            Layout(links[i]).updateLayout();
        }
    }
}
}
