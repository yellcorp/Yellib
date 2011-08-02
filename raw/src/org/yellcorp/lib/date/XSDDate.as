package org.yellcorp.lib.date
{
import org.yellcorp.lib.core.StringUtil;


public class XSDDate
{
    // http://www.w3.org/TR/xmlschema-2/#dateTime says:
    // '-'? yyyy '-' mm '-' dd 'T' hh ':' mm ':' ss ('.' s+)? (zzzzzz)?

    /**
     * RegExp for matching XSD:DateTimes
     */
    private static var dateTimeRE:RegExp =
    /(-?\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(\.\d+)?([0-9:Z+-]*)/i ;
    // Year      Month   Day     Hour    Minute  Second ms      timezone

    /**
     * RegExp for matching XSD:Times
     */
    private static var timeRE:RegExp =
    /(\d{2}):(\d{2}):(\d{2})(\.\d+)?([0-9:Z+-]*)/i ;
    // Hour    Minute  Second ms      timezone

    /**
     * RegExp for matching XSD:Dates
     */
    private static var dateRE:RegExp =
    /(-?\d{4})-(\d{2})-(\d{2})/i ;
    // Year      Month   Day

    /**
     * Helper function. Returns true if any of its arguments are NaN
     */
    private static function anyIsNaN(... args):Boolean
    {
        var i:uint;
        for (i = 0; i < args.length; i++)
        {
            if (isNaN(args[i] as Number))
            {
                return true;
            }
        }
        return false;
    }

    /**
     * Parses a timezone specification as used in XSD dates and times and
     * returns the result in negative minutes, which matches the units
     * used by Date.timezoneOffset
     */
    private static function parseXSDOffset(xsOffset:String):Number
    {
        var sign:String;
        var hours:Number;
        var minutes:Number;

        if (xsOffset.toLowerCase().charAt(0) == 'z')
        {
            return 0;
        }
        else
        {
            sign = xsOffset.charAt(0);
            if ('+-'.indexOf(sign) == -1)
            {
                return Number.NaN;
            }
            hours = parseInt(xsOffset.substr(1, 2));
            minutes = parseInt(xsOffset.substr(4, 2));

            minutes += hours * 60;
            if (sign == '-') minutes = -minutes;

            // flip the sign because ECMA Date object logic is reversed
            // relative to the more standard way of noting timezone offsets
            // like in XML Schema
            return -minutes;
        }
    }

    /**
     * Parses an XSD:DateTime.  Timezones are supported.  If the DateTime
     * string lacks a timezone specification, the default local timezone is
     * used.
     */
    public static function parseXSDDateTime(xsDateTime:String):Date
    {
        var matchResult:Object = dateTimeRE.exec(xsDateTime);

        var year:Number;
        var month:Number;
        var day:Number;
        var hour:Number;
        var minute:Number;
        var second:Number;
        var ms:Number = 0;
        var offset:Number;

        var epoch:Number;

        if (matchResult)
        {
            year = parseInt(matchResult[1], 10);
            month = parseInt(matchResult[2], 10) - 1;
            day = parseInt(matchResult[3], 10);
            hour = parseInt(matchResult[4], 10);
            minute = parseInt(matchResult[5], 10);
            second = parseInt(matchResult[6], 10);

            // the decimal point is included in the match so
            // it will parse as a float < 1
            if (matchResult[7])
            {
                ms = parseFloat(matchResult[7]) * 1000;
            }
            if (matchResult[8])
            {
                offset = parseXSDOffset(matchResult[8]);
            }
            else
            {
                // XML schema says if there is no timezone supplied, use the timezone
                // of the locale.
                offset = (new Date(year, month, day, hour, minute, second)).timezoneOffset;
                trace("DateParse.parseXSDateTime: Warning: Timezone not " +
                    "specified. Timezone set to " + (offset / -60) +
                    ". String was: '" + xsDateTime + "'");
            }

            if (anyIsNaN(year, month, day, hour, minute, second))
            {
                throw new ArgumentError("Not a valid xsd:datetime string");
            }
            else
            {
                epoch = Date.UTC(year, month, day, hour, minute, second, ms)
                    + offset * TimeUnits.MINUTE;
            }
        }
        else
        {
            throw new ArgumentError("Not a valid xsd:datetime string");
        }

        return new Date(epoch);
    }

    /**
     * Parses an XSD:Time.  Timezone specifiers are NOT supported - the
     * assumption is that there exists some reference Time or Date.
     */
    public static function parseXSDTime(xsTime:String):Number
    {
        // this implementation is incomplete - not parsing zone info.
        // for tz parsing to be useful i'd need to make a whole bunch of
        // extra util functions to add times-of-day to dates, incorporating
        // timezone differences, which isn't needed for this app (yet)

        var matchResult:Object = timeRE.exec(xsTime);

        var hour:Number;
        var minute:Number;
        var second:Number;
        var ms:Number = 0;

        if (matchResult)
        {
            hour = parseInt(matchResult[1], 10);
            minute = parseInt(matchResult[2], 10);
            second = parseInt(matchResult[3], 10);

            // again, leading decimal point is part of the matched group
            ms = matchResult[4] ? 1000 * (parseFloat(matchResult[4])) : 0;

            return hour * TimeUnits.HOUR +
                minute * TimeUnits.MINUTE +
                second * TimeUnits.SECOND +
                ms * TimeUnits.MILLISECOND;
        }
        else
        {
            trace("DateParse.parseXSTime: " +
                "RegExp failed. String was: '" + xsTime + "'");
            return Number.NaN;
        }
    }

    /**
     * Parses an XSD:Date.  Timezones are NOT supported.  The returned
     * time of day is set to midnight UTC.
     */
    public static function parseXSDDate(xsDate:String):Date
    {
        // also no timezone support
        var matchResult:Object = dateRE.exec(xsDate);

        var year:Number;
        var month:Number;
        var day:Number;

        var epoch:Number;

        if (matchResult)
        {
            year = parseInt(matchResult[1], 10);
            month = parseInt(matchResult[2], 10) - 1;
            day = parseInt(matchResult[3], 10);

            epoch = Date.UTC(year, month, day);
        }
        else
        {
            throw new ArgumentError("Not a valid xsd:date string");
        }

        return new Date(epoch);
    }

    public static function formatXSDDateTimeUTC(date:Date):String
    {
        var str:String;

        str = StringUtil.padLeft(date.fullYearUTC, 4, "0") + "-" +
            StringUtil.padLeft(date.monthUTC + 1, 2, "0") + "-" +
            StringUtil.padLeft(date.dateUTC, 2, "0") + "T" +
            StringUtil.padLeft(date.hoursUTC, 2, "0") + ":" +
            StringUtil.padLeft(date.minutesUTC, 2, "0") + ":" +
            StringUtil.padLeft(date.secondsUTC, 2, "0") + "Z";

        return str;
    }
}
}
