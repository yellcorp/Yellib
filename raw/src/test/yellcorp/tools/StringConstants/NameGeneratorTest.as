package test.yellcorp.tools.StringConstants
{
import asunit.framework.TestCase;

import org.yellcorp.tools.StringConstants;


public class NameGeneratorTest extends TestCase
{
    public function NameGeneratorTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testEmpty():void
    {
        assertEquals("", StringConstants.generateName(null));
        assertEquals("", StringConstants.generateName(""));
    }

    public function testIdempotent():void
    {
        assertEquals("A", StringConstants.generateName("A"));
        assertEquals("CONST_NAME", StringConstants.generateName("CONST_NAME"));
    }

    public function testTrivial():void
    {
        assertEquals("A", StringConstants.generateName("a"));
        assertEquals("WORD", StringConstants.generateName("word"));
    }

    public function testSimple():void
    {
        assertEquals("CAPITALIZED", StringConstants.generateName("Capitalized"));
        assertEquals("CAMEL_CAPS", StringConstants.generateName("camelCaps"));
        assertEquals("BACTRIAN_CAMEL_CAPS", StringConstants.generateName("bactrianCamelCaps"));
        assertEquals("DIGITS_1", StringConstants.generateName("digits1"));
    }

    public function testComplex():void
    {
        assertEquals("HTML_PARSER", StringConstants.generateName("htmlParser"));
        assertEquals("HTML_PARSER", StringConstants.generateName("HTMLParser"));
        assertEquals("HTML_PARSER_HTML_PARSER", StringConstants.generateName("HTMLParserHTMLParser"));
        assertEquals("HTML_5_PARSER", StringConstants.generateName("HTML5Parser"));
        assertEquals("VECTOR_RGB", StringConstants.generateName("VectorRGB"));
        assertEquals("VECTOR_RGB", StringConstants.generateName("VectorRGB!"));
        assertEquals("VECTOR_RGB", StringConstants.generateName("Vector!RGB"));
        assertEquals("VECTOR_RGB_RENDERER", StringConstants.generateName("VectorRGBRenderer"));
        assertEquals("SPACE_SEPARATED", StringConstants.generateName("Space separated"));
        assertEquals("FACEBOOK_COM", StringConstants.generateName("facebook.com"));
        assertEquals("O_AUTH_INIT", StringConstants.generateName("OAuth.init"));
        assertEquals("_1_NUMBER_AT_START", StringConstants.generateName("1numberAtStart"));
    }
}
}
