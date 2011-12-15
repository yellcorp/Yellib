package scratch
{
import org.yellcorp.lib.text.TextFieldBuilder;
import org.yellcorp.lib.text.MobilePasswordField;

import flash.display.Sprite;
import flash.text.TextField;


public class TestMobilePassword extends Sprite
{
    private var textField:TextField;
    private var mobilePass:MobilePasswordField;
    
    public function TestMobilePassword()
    {
        super();
        addChild(textField = new TextFieldBuilder().
                acceptsInput(true).
                border(0).
                create());
        mobilePass = new MobilePasswordField(textField);
    }
}
}
