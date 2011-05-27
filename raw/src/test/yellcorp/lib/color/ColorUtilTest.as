package test.yellcorp.lib.color
{
import asunit.framework.TestCase;

import org.yellcorp.lib.color.ColorUtil;


public class ColorUtilTest extends TestCase
{
    public function ColorUtilTest(testMethod:String = null)
    {
        super(testMethod);
    }
    public function testMake():void
    {
        assertEquals("Black", 0x0, ColorUtil.makeRGB(0, 0, 0));
        assertEquals("White", 0xFFFFFF, ColorUtil.makeRGB(255,255,255));
        assertEquals("Ochre or something", 0xCC9966, ColorUtil.makeRGB(0xCC, 0x99, 0x66));
    }
    public function testAdd():void
    {
        assertEquals("Black + Black = Black", 0x000000, ColorUtil.add(0x000000, 0x000000));
        assertEquals("Grey + Grey = White", 0xFFFFFF, ColorUtil.add(0x808080, 0x7f7f7f));
        assertEquals("White + White = White", 0xFFFFFF, ColorUtil.add(0xFFFFFF, 0xFFFFFF));
        assertEquals("Red + Green = Yellow", 0xFFFF00, ColorUtil.add(0xFF0000, 0x00FF00));
        assertEquals("Cyan + Magenta = White", 0xFFFFFF, ColorUtil.add(0x00FFFF, 0xFF00FF));
    }
    public function testMultiply():void
    {
        assertEquals("White x Black = Black", 0x000000, ColorUtil.multiply(0xFFFFFF, 0x000000));
        assertEquals("Black x White = Black", 0x000000, ColorUtil.multiply(0x000000, 0xFFFFFF));
        assertEquals("White x Grey = Grey", 0x999999, ColorUtil.multiply(0xFFFFFF, 0x999999));
        assertEquals("Grey x White = Grey", 0x999999, ColorUtil.multiply(0x999999, 0xFFFFFF));
        assertEquals("Cyan x Magenta = Blue", 0x0000FF, ColorUtil.multiply(0x00FFFF, 0xFF00FF));
        assertEquals("Burnt orange x Swampy green = Puke Yellow", 0x515100, ColorUtil.multiply(0xCC6600, 0x66CC00));
    }
    public function testScreen():void
    {
        assertEquals("White ~x Black = White", 0xFFFFFF, ColorUtil.screen(0xFFFFFF, 0x000000));
        assertEquals("Black ~x White = White", 0xFFFFFF, ColorUtil.screen(0x000000, 0xFFFFFF));
        assertEquals("Black ~x Grey = Grey", 0x999999, ColorUtil.screen(0x000000, 0x999999));
        assertEquals("Grey ~x Black = Grey", 0x999999, ColorUtil.screen(0x999999, 0x000000));
        assertEquals("Red ~x Green = Yellow", 0xFFFF00, ColorUtil.screen(0xFF0000, 0x00FF00));
        assertEquals("Burnt orange ~x Swampy green = Lighter Puke Yellow", 0xe0e000, ColorUtil.screen(0xCC6600, 0x66CC00));
    }
    public function testDifference():void
    {
        assertEquals("White ^ Black = White", 0xFFFFFF, ColorUtil.difference(0xFFFFFF, 0x000000));
        assertEquals("Black ^ White = White", 0xFFFFFF, ColorUtil.difference(0x000000, 0xFFFFFF));
        assertEquals("Black ^ Orange = Orange", 0xEE8811, ColorUtil.difference(0x000000, 0xEE8811));
        assertEquals("White ^ Red = Cyan", 0x00FFFF, ColorUtil.difference(0xFFFFFF, 0xFF0000));
        assertEquals("Yellow ^ Cyan = Magenta", 0xFF00FF, ColorUtil.difference(0xFFFF00, 0x00FFFF));
        assertEquals("111111 ^ EEEEEE = DDDDDD", 0xDDDDDD, ColorUtil.difference(0x111111, 0xEEEEEE));
    }
    public function testLerp():void
    {
        assertEquals("Black, White, 0.5", 0x7F7F7F, ColorUtil.lerp(0, 0xFFFFFF, .5));
        assertEquals("White, Black, 0.5", 0x7F7F7F, ColorUtil.lerp(0xFFFFFF, 0, .5));
        assertEquals("Red, Green, 0.5", 0x7F7F00, ColorUtil.lerp(0xFF0000, 0x00FF00, .5));
        assertEquals("Black, White, 0.2", 0x333333, ColorUtil.lerp(0, 0xFFFFFF, .2));
        assertEquals("White, Black, 0.2", 0xCCCCCC, ColorUtil.lerp(0xFFFFFF, 0, .2));
    }
}
}
