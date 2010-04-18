package org.yellcorp.debug.console
{

public class DebugConsole
{
    private var skin:DebugConsoleSkin;
    private var _view:DebugConsoleView;

    public function DebugConsole(initialWidth:Number, initialHeight:Number, skin:DebugConsoleSkin)
    {
        this.skin = skin;
        _view = new DebugConsoleView(initialWidth, initialHeight, skin);
    }

    public function get view():DebugConsoleView
    {
        return _view;
    }
}
}
