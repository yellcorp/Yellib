package org.yellcorp.format
{
import org.yellcorp.locale.DefaultLocale;
import org.yellcorp.locale.Locale;
import org.yellcorp.string.StringUtil;


public class DateFormatFlex
{
    private static const FIELD_TOKENS:RegExp = /([YMDAEHJKLNSTU])\1*/g;

    public static function format(template:String, date:Date, locale:Locale = null):String
    {
        var index:int = 0;
        var match:Object;
        var result:String = "";

        if (!locale)
        {
            locale = DefaultLocale.getLocale();
        }

        FIELD_TOKENS.lastIndex = 0;
        while (index < template.length)
        {
            match = FIELD_TOKENS.exec(template);
            if (match)
            {
                if (index < match.index)
                {
                    result += template.substring(index, match.index);
                }
                index = match.index + match[0].length;
                result += substitute(date, match[1], match[0].length, locale);
            }
            else
            {
                result += template.substr(index);
                break;
            }
        }
        return result;
    }

    private static function substitute(date:Date, field:String, len:int, locale:Locale):String
    {
        switch (field)
        {
            case 'Y' :
            {
                // year
                if (len <= 2)
                    return date.fullYear.toString().substr(2);
                else if (len <= 4)
                    return date.fullYear.toString();
                else
                    return padNumber(date.fullYear, len);
            }
            case 'M' :
            {
                // month
                if (len <= 2)
                    return padNumber(date.month + 1, len);
                else if (len == 3)
                    return locale.getMonthNameShort(date.month);
                else
                    return locale.getMonthName(date.month);
            }
            case 'D' :
            {
                // day in month
                return padNumber(date.date, len);
            }
            case 'E' :
            {
                // day in week
                if (len <= 2)
                    return padNumber(date.day, len);
                else if (len == 3)
                    return locale.getDayNameShort(date.day);
                else
                    return locale.getDayName(date.day);
            }
            case 'A' :
            {
                // am/pm
                return locale.getDayHalf(date.hours < 12 ? 0 : 1);
            }
            case 'J' :
            {
                // hour: 0-23
                return padNumber(date.hours, len);
            }
            case 'H' :
            {
                // hour: 1-24
                return padNumber(DateFormatUtil.getHours1to24(date.hours), len);
            }
            case 'K' :
            {
                // hour: 0-11
                return padNumber(DateFormatUtil.getHours0to11(date.hours), len);
            }
            case 'L' :
            {
                // hour: 1-12
                return padNumber(DateFormatUtil.getHours1to12(date.hours), len);
            }
            case 'N' :
            {
                // minute
                return padNumber(date.minutes, len);
            }
            case 'S' :
            {
                // seconds
                return padNumber(date.seconds, len);
            }
            case 'T' :
            {
                // extension: ordinal suffix for day in month
                return locale.getOrdinalSuffix(date.date);
            }
            case 'U' :
            {
                // extension: milliseconds
                return padNumber(
                    Math.round(date.milliseconds * Math.pow(10, len - 3)), len);
            }
            default :
                throw new Error("Internal error - unhandled token '" + field + "'");
        }
    }

    private static function padNumber(number:Number, len:int):String
    {
        return StringUtil.padLeft(number.toString(), len, "0", false);
    }
}
}
