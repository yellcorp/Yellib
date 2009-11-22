package org.yellcorp.url
{
import org.yellcorp.url.URLNetLoc;


public class URLBuilder
{
    public static var HTTP:String = "http:";
    public static var HTTPS:String = "https:";
    public static var FTP:String = "ftp:";

    private static var defaultPorts:Object = {
        "http:"  : 80,
        "https:" : 443,
        "ftp:"   : 21
    };

    private static var schemeExp:RegExp = /^[a-z0-9+.-]+:/i ;

    private var _scheme:String = "";
    private var _fragment:String = "";
    private var _query:String = "";
    private var _params:String = "";

    private var _netLoc:URLNetLoc;

    private var pathParts:Array;

    public function URLBuilder(url:String = "")
    {
        if (url.length > 0)
        {
            parse(url);
        }
        else
        {
            _netLoc = new URLNetLoc();
            pathParts = [];
        }
    }

    public function clear():void
    {
        _scheme = "";
        _fragment = "";
        _query = "";
        _params = "";
        _netLoc = new URLNetLoc();
        pathParts = [];
    }

    public function clone():URLBuilder
    {
        var copy:URLBuilder = new URLBuilder();

        copy._scheme = _scheme;
        copy._netLoc = _netLoc.clone();
        copy._fragment = _fragment;
        copy._query = _query;
        copy._params = _params;
        copy.pathParts = pathParts.slice();

        return copy;
    }

    public function equals(other:URLBuilder):Boolean
    {
        return _netLoc.equals(other._netLoc) &&
               arraysMatch(pathParts, other.pathParts) &&
               _scheme == other._scheme &&
               _fragment == other._fragment &&
               _query == other._query &&
               _params == other._params;
    }

    public function isEmpty():Boolean
    {
        return pathParts.length == 0 &&
               _netLoc.isEmpty() &&
               _scheme == "" &&
               _fragment == "" &&
               _query == "" &&
               _params == "";
    }

    public function parse(url:String):void
    {
        url = takeFragment(url);
        url = takeScheme(url);
        url = takeNetloc(url);
        url = takeQuery(url);
        url = takeParameters(url);

        setDefaultPort();

        path = url;
    }

    public function toString():String
    {
        var output:String;

        output = scheme;

        if (!_netLoc.isEmpty())
        {
            output += "//" + _netLoc.toString();
        }

        output += path;

        if (_params != "") output += ";" + _params;
        if (_query != "") output += "?" + _query;
        if (_fragment != "") output += "#" + _fragment;

        return output;
    }

    public function normalizePath():void
    {
        var i:int;
        var part:String;

        var minUpDir:int = hasAbsolutePath() ? 1 : 0;
        var pushedDir:Boolean;

        for (i = 0;i < pathParts.length; i++)
        {
            part = pathParts[i];
            if (part == "." || (part == "" && i > 0 && i < pathParts.length - 1))
            {
                pathParts.splice(i, 1);
                i--;
                pushedDir = true;
            }
            else if (part == "..")
            {
                if (i > minUpDir && pathParts[i - 1] != "..")
                {
                    pathParts.splice(i - 1, 2);
                    i -= 2;
                }
                pushedDir = true;
            }
            else
            {
                pushedDir = false;
            }
        }

        if (pushedDir) pathParts.push("");

        if (pathParts.length == 1 && pathParts[0] == "")
        {
            pathParts.unshift(".");
        }
    }

    public function hasAbsolutePath():Boolean
    {
        return (pathParts.length > 0) && (pathParts[0] == "");
    }


    // simple gettersetters

    public function get fragment():String
    {
        return _fragment;
    }

    public function set fragment(v:String):void
    {
        _fragment = v;
    }

    public function get query():String
    {
        return _query;
    }

    public function set query(v:String):void
    {
        _query = v;
    }

    public function get params():String
    {
        return _params;
    }

    public function set params(v:String):void
    {
        this._params = v;
    }

    public function get netLoc():URLNetLoc
    {
        return _netLoc;
    }

    public function get scheme():String
    {
        return _scheme;
    }

    public function set scheme(v:String):void
    {
        this._scheme = v;
        setDefaultPort();
    }

    public function get path():String
    {
        if (pathParts.length == 0)
        {
            return "";
        }
        else
        {
            return pathParts.join("/");
        }
    }

    public function set path(v:String):void
    {
        if (v == null || v.length == 0)
        {
            if (_netLoc.isEmpty())
            {
                pathParts = [];
            }
            else
            {
                pathParts = ["", ""];
            }
        }
        else
        {
            pathParts = v.split("/");
        }
    }


    public function toAbsolute(base:URLBuilder):URLBuilder
    {
        var result:URLBuilder;
        var pathCopy:Array;

        var i:int;
        var offset:int;

        // http://www.freesoft.org/CIE/RFC/1808/18.htm

        // 1
        if (base.isEmpty()) return clone();

        // 2.1
        if (isEmpty()) return base.clone();

        // 2.2
        if (_scheme != "") return clone();

        // 2.3
        result = clone();
        result._scheme = base._scheme;

        // 3
        if (result._netLoc.isEmpty())
        {
            result._netLoc = base._netLoc.clone();

            // 4
            if (!result.hasAbsolutePath())
            {
                // 5
                if (result.pathParts.length == 0)
                {
                    result.pathParts = base.pathParts.slice();
                    // 5.1
                    if (result._params == "")
                    {
                        result._params = base._params;
                        // 5.2
                        if (result._query == "")
                        {
                            result._query = base._query;
                        }
                    }
                }
                // 6
                else
                {
                    pathCopy = base.pathParts.slice();
                    pathCopy.pop();

                    offset = pathCopy.length;

                    for (i = 0;i < result.pathParts.length; i++)
                    {
                        pathCopy[i + offset] = result.pathParts[i];
                    }

                    result.pathParts = pathCopy;
                    result.normalizePath();
                }
            }
        }

        // 7
        return result;
    }


    public function toRelative(base:URLBuilder):URLBuilder
    {
        var baseNorm:URLBuilder = base.clone();
        var result:URLBuilder = clone();

        baseNorm.normalizePath();
        result.normalizePath();

        if (baseNorm._scheme == result._scheme)
        {
            result._scheme = "";
            if (baseNorm._netLoc.equals(result._netLoc))
            {
                result._netLoc.clear();

                if (baseNorm.hasAbsolutePath() && result.hasAbsolutePath())
                {
                    if (arraysMatch(baseNorm.pathParts, result.pathParts))
                    {
                        // look ahead first - if any of param/query/fragment
                        // differs by being unset, we have to retain the leaf
                        // to force them clear

                        if ( (baseNorm._params != result._params && result._params == "") ||
                             (baseNorm._query != result._query && result._query == "") ||
                             (baseNorm._fragment != result._fragment && result._fragment == "") )
                        {
                            result.pathParts = [result.pathParts.pop()];
                        }
                        else
                        {
                            result.pathParts = [];
                            if (baseNorm._params == result._params)
                            {
                                result._params = "";
                                if (baseNorm._query == result._query)
                                {
                                    result._query = "";
                                    if (baseNorm._fragment == result._fragment)
                                    {
                                        result._fragment = "";
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        result.pathParts = pathDiff(baseNorm.pathParts, result.pathParts);
                    }
                }
            }
        }

        // path-diff or leaf preserve (that big chunky if block up the top)
        // may want the default document in the current directory
        // (i.e. it wants "" relative to current dir)
        // unshift "." so it doesn't get confused for "/" or empty

        if (result.pathParts.length == 1 && result.pathParts[0] == "")
        {
            result.pathParts.unshift(".");
        }

        return result;
    }

    private static function pathDiff(base:Array, rel:Array):Array
    {
        // rel paths
        //  0 | 1 | 2 | 3 | 4
        // "" | a | b | c | ""
        // "" | a | b | c | d   -->  d

        // "" | a | b | c | ""
        // "" | a | b | e | ""  -->  .. | e | ""

        // "" | a | b | c | ""
        // "" | a | b | e | f   -->  .. | e | f

        // CAREFUL
        // "" | a | b | c | d
        // "" | a | b | c | d | ""  -->  d | ""

        // "" | a | b | c | d | ""
        // "" | a | b | c | d       -->  .. | d

        // "" | a | b | c | d | default.html
        // "" | a | b | c | d | ""  -->       "./"

        var leaf:String;
        var pathMatch:int;
        var result:Array;
        var i:int;

        base.pop();
        leaf = rel.pop();

        result = [];

        pathMatch = 0;

        while ( pathMatch < base.length &&
                pathMatch < rel.length &&
                base[pathMatch] == rel[pathMatch] )
        {
            pathMatch++;
        }

        for (i = pathMatch; i < base.length; i++)
        {
            result.push("..");
        }

        for (i = pathMatch; i < rel.length; i++)
        {
            result.push(rel[i]);
        }

        result.push(leaf);

        return result;
    }


    private function takeNetloc(input:String):String
    {
        var nextSlash:int;
        var netlocString:String = "";

        if (input.substr(0, 2) != "//")
        {
            _netLoc = new URLNetLoc();
            return input;
        }

        nextSlash = input.indexOf("/", 2);

        if (nextSlash < 0)
        {
            netlocString = input.substr(2);
            input = "";
        }
        else
        {
            netlocString = input.substring(2, nextSlash);
            input = input.substr(nextSlash);
        }

        _netLoc = new URLNetLoc(netlocString);

        return input;
    }

    private function takeScheme(input:String):String
    {
        var match:Object;

        match = schemeExp.exec(input);
        if (match)
        {
            _scheme = match[0].toLowerCase();
            input = input.substr(_scheme.length);
        }

        return input;
    }

    private function takeParameters(input:String):String
    {
        var split:Array = split2(input, ";");
        _params = split[1];
        return split[0];
    }

    private function takeQuery(input:String):String
    {
        var split:Array = split2(input, "?");
        _query = split[1];
        return split[0];
    }

    private function takeFragment(input:String):String
    {
        var split:Array = split2(input, "#");
        _fragment = split[1];
        return split[0];
    }

    private function setDefaultPort():void
    {
        if (defaultPorts[_scheme])
        {
            _netLoc.defaultPort = defaultPorts[_scheme];
        }
        else
        {
            _netLoc.defaultPort = -1;
        }
    }

    internal static function split2(input:String, delim:String,
                                    unshift:Boolean = false,
                                    defaultValue:String = ""):Array
    {
        var split:Array = input.split(delim, 2);

        if (split.length < 2)
        {
            if (unshift)
            {
                split.unshift(defaultValue);
            }
            else
            {
                split.push(defaultValue);
            }
        }

        return split;
    }

    internal static function arraysMatch(a:Array, b:Array):Boolean
    {
        var i:int;

        if (a.length != b.length) return false;
        if (a.length == 0) return true;

        for (i = 0; i < a.length; i++)
        {
            if (a[i] !== b[i]) return false;
        }
        return true;
    }
}
}
