package test.yellcorp.string
{
import asunit.framework.TestCase;

import org.yellcorp.string.CharacterMapper;


public class CharacterMapperTest extends TestCase
{
    public function CharacterMapperTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testNull():void
    {
        var m:CharacterMapper = new CharacterMapper();

        assertEquals("Empty map, empty string",
                     "",
                     m.map(""));

        assertEquals("Empty map, unchanged string",
                     "pass",
                     m.map("pass"));

        m.setFromStrings("abc", "ABC");
        assertEquals("Non-empty map, empty string",
                     "",
                     m.map(""));

        assertEquals("Non-empty map, unchanged string",
                     "xyz",
                     m.map("xyz"));
    }

    public function testSimple():void
    {
        var m:CharacterMapper = new CharacterMapper("abc", "ABC");

        assertEquals("Single character",
                     "A",
                     m.map("a"));

        assertEquals("Multi character",
                     "CBA",
                     m.map("cba"));

        assertEquals("Multi characters, some out of range",
                     "CxByAz",
                     m.map("cxbyaz"));
    }

    public function testQuery():void
    {
        var m:CharacterMapper = new CharacterMapper("abc", "ABC");

        assertTrue("Presence",
                   m.hasMapping("a"));

        assertEquals("Value",
                     "B",
                     m.getMapping("b"));
    }

    public function testMutate():void
    {
        var m:CharacterMapper = new CharacterMapper("abc", "ABC");

        assertEquals("Sanity",
                     "BCA",
                     m.map("bca"));

        m.setMapping("d", "D");
        assertTrue("Presence",
                   m.hasMapping("d"));

        assertEquals("Value",
                     "D",
                     m.getMapping("d"));

        assertEquals("Update",
                     "BDCA",
                     m.map("bdca"));

        m.deleteMapping("d");
        assertFalse("Absence",
                   m.hasMapping("d"));

        assertEquals("Removal",
                     "BdCA",
                     m.map("bdca"));

        m.setMapping("c", "3");
        assertEquals("Change",
                     "Bd3A",
                     m.map("bdca"));
    }
}
}
