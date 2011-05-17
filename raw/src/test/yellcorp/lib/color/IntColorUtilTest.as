package test.yellcorp.lib.color
{
import asunit.framework.TestCase;

import org.yellcorp.lib.color.IntColorUtil;


public class IntColorUtilTest extends TestCase
{
    public function IntColorUtilTest(testMethod:String = null)
    {
        super(testMethod);
    }
    public function testMake():void
    {
        assertEquals("Black", 0x0, IntColorUtil.makeRGB(0, 0, 0));
        assertEquals("White", 0xFFFFFF, IntColorUtil.makeRGB(255,255,255));
        assertEquals("Ochre or something", 0xCC9966, IntColorUtil.makeRGB(0xCC, 0x99, 0x66));
    }
    public function testAdd():void
    {
        assertEquals("Black + Black = Black", 0x000000, IntColorUtil.add(0x000000, 0x000000));
        assertEquals("Grey + Grey = White", 0xFFFFFF, IntColorUtil.add(0x808080, 0x7f7f7f));
        assertEquals("White + White = White", 0xFFFFFF, IntColorUtil.add(0xFFFFFF, 0xFFFFFF));
        assertEquals("Red + Green = Yellow", 0xFFFF00, IntColorUtil.add(0xFF0000, 0x00FF00));
        assertEquals("Cyan + Magenta = White", 0xFFFFFF, IntColorUtil.add(0x00FFFF, 0xFF00FF));
    }
    public function testMultiply():void
    {
        assertEquals("White x Black = Black", 0x000000, IntColorUtil.multiply(0xFFFFFF, 0x000000));
        assertEquals("Black x White = Black", 0x000000, IntColorUtil.multiply(0x000000, 0xFFFFFF));
        assertEquals("White x Grey = Grey", 0x999999, IntColorUtil.multiply(0xFFFFFF, 0x999999));
        assertEquals("Grey x White = Grey", 0x999999, IntColorUtil.multiply(0x999999, 0xFFFFFF));
        assertEquals("Cyan x Magenta = Blue", 0x0000FF, IntColorUtil.multiply(0x00FFFF, 0xFF00FF));
        assertEquals("Burnt orange x Swampy green = Puke Yellow", 0x515100, IntColorUtil.multiply(0xCC6600, 0x66CC00));
    }
    public function testScreen():void
    {
        assertEquals("White ~x Black = White", 0xFFFFFF, IntColorUtil.screen(0xFFFFFF, 0x000000));
        assertEquals("Black ~x White = White", 0xFFFFFF, IntColorUtil.screen(0x000000, 0xFFFFFF));
        assertEquals("Black ~x Grey = Grey", 0x999999, IntColorUtil.screen(0x000000, 0x999999));
        assertEquals("Grey ~x Black = Grey", 0x999999, IntColorUtil.screen(0x999999, 0x000000));
        assertEquals("Red ~x Green = Yellow", 0xFFFF00, IntColorUtil.screen(0xFF0000, 0x00FF00));
        assertEquals("Burnt orange ~x Swampy green = Lighter Puke Yellow", 0xe0e000, IntColorUtil.screen(0xCC6600, 0x66CC00));
    }
    public function testDifference():void
    {
        assertEquals("White ^ Black = White", 0xFFFFFF, IntColorUtil.difference(0xFFFFFF, 0x000000));
        assertEquals("Black ^ White = White", 0xFFFFFF, IntColorUtil.difference(0x000000, 0xFFFFFF));
        assertEquals("Black ^ Orange = Orange", 0xEE8811, IntColorUtil.difference(0x000000, 0xEE8811));
        assertEquals("White ^ Red = Cyan", 0x00FFFF, IntColorUtil.difference(0xFFFFFF, 0xFF0000));
        assertEquals("Yellow ^ Cyan = Magenta", 0xFF00FF, IntColorUtil.difference(0xFFFF00, 0x00FFFF));
        assertEquals("111111 ^ EEEEEE = DDDDDD", 0xDDDDDD, IntColorUtil.difference(0x111111, 0xEEEEEE));
    }
    public function testLerp():void
    {
        assertEquals("Black, White, 0.5", 0x7F7F7F, IntColorUtil.lerp(0, 0xFFFFFF, .5));
        assertEquals("White, Black, 0.5", 0x7F7F7F, IntColorUtil.lerp(0xFFFFFF, 0, .5));
        assertEquals("Red, Green, 0.5", 0x7F7F00, IntColorUtil.lerp(0xFF0000, 0x00FF00, .5));
        assertEquals("Black, White, 0.2", 0x333333, IntColorUtil.lerp(0, 0xFFFFFF, .2));
        assertEquals("White, Black, 0.2", 0xCCCCCC, IntColorUtil.lerp(0xFFFFFF, 0, .2));
    }
}
}
