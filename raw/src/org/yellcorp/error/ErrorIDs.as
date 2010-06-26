package org.yellcorp.error
{
public class ErrorIDs
{
    public static const MEMBER_OF_NULL:uint = 1009;
    public static const MEMBER_OF_UNDEFINED:uint = 1010;

    public static const XML_ERROR_MIN:uint = 1090;
    public static const XML_MALFORMED_ELEMENT:uint = 1090;
    public static const XML_UNTERMINATED_CDATA:uint = 1091;
    public static const XML_UNTERMINATED_XML_DECL:uint = 1092;
    public static const XML_UNTERMINATED_DOCTYPE:uint = 1093;
    public static const XML_UNTERMINATED_COMMENT:uint = 1094;
    public static const XML_UNTERMINATED_ATTRIBUTE:uint = 1095;
    public static const XML_UNTERMINATED_ELEMENT:uint = 1096;
    public static const XML_UNTERMINATED_PI:uint = 1097;
    public static const XML_ERROR_MAX:uint = 1097;

    public static const SANDBOX_LOCAL_SPECIFIED_SECURITY_DOMAIN:uint = 2142;

    public static function isXMLError(e:Error):Boolean
    {
        return e is TypeError &&
               isXMLErrorID(e.errorID);
    }

    public static function isXMLErrorID(id:int):Boolean
    {
        return id >= XML_ERROR_MIN &&
               id <= XML_ERROR_MAX;
    }
}
}
