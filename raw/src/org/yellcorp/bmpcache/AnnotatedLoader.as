package org.yellcorp.bmpcache
{
import flash.display.Loader;


internal class AnnotatedLoader extends Loader
{
    internal var id:String;

    public function AnnotatedLoader(initId:String = null)
    {
        super();
        this.id = initId;
    }
}
}
