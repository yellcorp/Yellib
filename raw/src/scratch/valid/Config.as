package scratch.valid
{
import flash.display.DisplayObject;
import flash.errors.IllegalOperationError;


public class Config
{
    public var bookingService:String;
    public var epgService:String;
    public var serviceVersion:uint = 2;
    public var maxDays:Number = 14;
    public var userId:String = "";
    public var accountNumber:uint = 0;
    public var stateCode:String = "NSW";
    public var allowAdult:Boolean = false;
    public var resultsPerPage:uint = 60;
    //public var keys:Array;

    private var _helpURL:String = '';
    public var watchHelpURL:String = '';

    public var captchaHash:String = '';
    public var captchaImageURL:String = '';
    public var sendToFriendEmailURL:String = '';

    public var timeoutMaximumHeartbeat:Number;
    public var timeoutMaximumLength:Number;
    public var timeoutPingURL:String = '';

    public var mrecURL:String = "";
    public var promoSquareImage:String = "";
    public var promoSquareURL:String = "";

    public var showMedia:Boolean;

    public var epgServicePolicy:String = '';
    public var bookingServicePolicy:String = '';

    public var userEmail:String = '';
    public var userService:String = '';

    public var openWatchlist:Boolean = false;

    private static const MAX_STRING_LENGTH:uint = 512;

    public function Config(p:Config_ctor)
    {
        if (p == null)
        {
            throw new IllegalOperationError("Private constructor");
            //throw new ArgumentError("Config is a Singleton. Use Config.getInstance()");
        }
    }

    public function initValues(display:DisplayObject):void
    {
    }


    // the keys are assigned per application and NOT passed through flashvars
    // these are the keys for the old epg
    public function getKeys():Array
    {
        //return ["bae4e7", "c263a851-f", "b85b5aee-485", "3ec1fba0-24"];
        // doing it this way so they at least don't decompile into raw strings
        return stringKeys( [ [0xba, 0xe4e7],
                             [0xc263, 0xa851, 0xf],
                             [0xb85b, 0x5aee, 0x485],
                             [0x3ec1, 0xfba0, 0x24] ] );
    }

    public function get userLoggedIn():Boolean
    {
        return accountNumber > 0;
    }

    /**
     * The rule at the moment is convert all numbers to lowercase hex
     * strings with only the required digits - no leading zeros.
     *
     * Concatenate the first two together with no separator, then add
     * a hyphen, then concat the rest
     *
     * This may change as more details about these keys emerge
     */
    private function stringKeys(intArray:Array):Array
    {
        var i:int;
        var strOut:Array = [ ];
        var current:Array;

        for (i = 0;i < intArray.length; i++)
        {
            current = intArray[i].map(toHex);
            strOut[i] = current.slice(0, 2).join("");
            if (current.length > 2)
            {
                strOut[i] += "-" + current.slice(2).join("");
            }
        }

        return strOut;
    }

    private function toHex(item:*, index:int, array:Array):String
    {
        return (item as Number).toString(16).toLowerCase();
    }


    public function toString():String
    {
        var varNames:Array = ["bookingService", "epgService", "serviceVersion",
                              "maxDays", "userId", "accountNumber", "stateCode",
                              "allowAdult", "resultsPerPage"];

        return "[Config " + formatPairs(varNames) + "]";
    }

    private function formatPairs(names:Array):String
    {
        var i:int;
        var pairs:Array = [ ];

        for (i = 0;i < names.length; i++)
        {
            pairs.push(names[i] + "=" + this[names[i]]);
        }
        return pairs.join(", ");
    }


    //Singleton implementation
    private static var _instance:Config;

    public static function getInstance():Config
    {
        if (!_instance)
        {
            _instance = new Config(new Config_ctor());
        }
        return _instance;
    }

    public static function destroy():void
    {
        _instance == null;
    }

    public function get helpURL():String
    {
        return _helpURL;
    }

    public function set helpURL(helpURL:String):void
    {
        _helpURL = helpURL;
    }
}
}

class Config_ctor
{
}
