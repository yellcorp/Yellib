package org.yellcorp.lib.url
{
internal class URLNetLoc
{
    private static var allDigits:RegExp = /^\d+$/ ;

    public var username:String = "";
    public var password:String = "";
    public var host:String = "";
    public var defaultPort:int = -1;

    private var _port:int = -1;

    public function URLNetLoc(input:String = "")
    {
        if (input.length > 0)
        {
            parse(input);
        }
    }

    public function clear():void
    {
        username = "";
        password = "";
        host = "";
        _port = -1;
    }

    public function isEmpty():Boolean
    {
        return username == "" && password == "" && host == "" && _port == -1;
    }

    public function clone():URLNetLoc
    {
        var copy:URLNetLoc = new URLNetLoc();

        copy.username = username;
        copy.password = password;
        copy.host = host;
        copy.defaultPort = defaultPort;
        copy._port = _port;

        return copy;
    }

    public function parse(input:String):void
    {
        var userHost:Array;
        var userCreds:Array;
        var hostPort:Array;

        userHost = URLBuilder.split2(input, "@", true);
        userCreds = URLBuilder.split2(userHost[0], ":");
        hostPort = URLBuilder.split2(userHost[1], ":");

        username = userCreds[0];
        password = userCreds[1];
        host = hostPort[0];
        _port = parsePort(hostPort[1]);
    }

    public function get port():int
    {
        return _port == -1 ? defaultPort : _port;
    }

    public function set port(v:int):void
    {
        _port = v;
    }

    public function toString():String
    {
        var userCreds:String;
        var buildNetLoc:String;

        userCreds = username;
        buildNetLoc = host;

        if (defaultPort != -1 && _port != -1)
        {
            buildNetLoc += ":" + port.toString();
        }

        if (userCreds.length > 0)
        {
            if (password.length > 0)
            {
                userCreds += ":" + password;
            }
            buildNetLoc = userCreds + "@" + buildNetLoc;
        }

        return buildNetLoc;
    }

    public function equals(other:URLNetLoc):Boolean
    {
        return username == other.username &&
               password == other.password &&
               host == other.host &&
               port == other.port;
    }

    private static function parsePort(strPort:String):int
    {
        if (strPort.length == 0)
        {
            return -1;
        }

        if (allDigits.test(strPort))
        {
            return parseInt(strPort);
        }
        else
        {
            throw(new Error("Port is non-numeric"));
        }
    }
}
}
