package org.yellcorp.lib.net
{
import flash.net.URLRequest;
import flash.system.LoaderContext;


public interface LoaderContextFactory
{
    function createContext(forRequest:URLRequest):LoaderContext;
}
}
