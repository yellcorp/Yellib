package org.yellcorp.storage {
import flash.net.SharedObject;
import flash.utils.Proxy;
import flash.utils.flash_proxy;


/**
 * Attempts to create a shared object for persistent local data storage.
 * If this is disabled by the user, will still retain the data in memory
 * which will be lost when the SWF stops running.
 *
 * Extends proxy, so access properties on it as if it were a regular Object
 *
 */
public dynamic class LocalSharedObjectProxy extends Proxy {
    private var persist:SharedObject;
    private var runtime:Object;
    private var persistValid:Boolean = false;
    private var propertyNames:Array;

    public function LocalSharedObjectProxy(name:String, localPath:String = null, secure:Boolean = false ) {
        var copyName:String;
        runtime = new Object();

        try {
            persist = SharedObject.getLocal(name, localPath, secure);
            for (copyName in persist.data) {
                runtime[copyName] = persist.data[copyName];
            }
            persistValid = true;
        } catch (e:Error) {
            persistValid = false;
            trace("LocalSharedObjectProxy: Error instantiating SharedObject: "+e.toString());
        }
    }

    public function clear():void {
        if (persistValid) {
            persist.clear();
        }
        runtime = new Object();
    }

    public function get isPersistent():Boolean {
        return persistValid;
    }

    override flash_proxy function getProperty(name:*):* {
        return runtime[name];
    }

    override flash_proxy function setProperty(name:*, value:*):void {
        if (persistValid) persist.data[name] = value;
        runtime[name] = value;
    }

    override flash_proxy function deleteProperty(name:*):Boolean {
        if (persistValid) {
            delete runtime[name];
            return delete persist.data[name];
        } else {
            return delete runtime[name];
        }
    }

    override flash_proxy function hasProperty(name:*):Boolean {
        return runtime[name] != null;
    }

    override flash_proxy function nextNameIndex(index:int):int {
        if (index == 0) initProps();
        if (index < propertyNames.length) {
            return index + 1;
        } else {
            return 0;
        }
    }

    override flash_proxy function nextName(index:int):String {
        if (index == 0) initProps();
        return propertyNames[index-1];
    }

    override flash_proxy function nextValue(index:int):* {
        if (index == 0) initProps();
        return runtime[propertyNames[index-1]];
    }

    private function initProps():void {
        var copyName:String;
        propertyNames = new Array();
        for (copyName in runtime) {
            propertyNames.push(copyName);
        }
    }
}
}
