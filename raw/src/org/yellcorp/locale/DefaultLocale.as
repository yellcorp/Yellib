package org.yellcorp.locale
{
public class DefaultLocale
{
    private static var defaultLocale:Locale;

    public static function getLocale():Locale
    {
        if (!defaultLocale)
        {
            defaultLocale = new Locale_en();
        }
        return defaultLocale;
    }
}
}
