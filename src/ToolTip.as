package
{
    import caurina.transitions.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class ToolTip extends MovieClip
    {
		//12,"宋体",
        private var BG_COLOR:uint = 3355443;
		private var TEXT_COLOR:uint=16777215;
		private var TEXT_SIZE:int=12;
		private var FONT:String = "宋体";	
		private var TOOL_TEXT:String;	
		    
        private var holder_mc:MovieClip;       
        private var bg_mc:MovieClip;
        private var father:MovieClip;
		
        private var field_txt:TextField;
        private var right_point:Number;
        private var left_point:Number;
        private var ratio:int = 10;    
        private var top_point:Number;
        private var bottom_point:Number;

        public function ToolTip(content:String)
        {
            TOOL_TEXT = content;
            addEventListener(Event.ADDED_TO_STAGE, init);
            mouseEnabled = false;
            alpha = 0;
        }

        private function createTextField() : void
        {
            field_txt = new TextField();
            field_txt.multiline = true;
            field_txt.selectable = false;
            /*field_txt.embedFonts = false;
            field_txt.antiAliasType = AntiAliasType.ADVANCED;*/
            field_txt.autoSize = TextFieldAutoSize.LEFT;
            field_txt.defaultTextFormat = getFormat();
            field_txt.htmlText = TOOL_TEXT + "  ";
            field_txt.width = field_txt.textWidth + 10;
            field_txt.height = field_txt.textHeight + 20;
            holder_mc.addChild(field_txt);
        }

        private function fadeIn() : void
        {
            Tweener.addTween(this, { alpha:1, time:1, transition:"regular" } );
        }

        private function getFormat() : TextFormat
        {
            var tf:* = new TextFormat();
            tf.font = FONT;
            tf.size = TEXT_SIZE;
            tf.color = TEXT_COLOR;
			return tf;
        }

        private function createHolder() : void
        {
            holder_mc = new MovieClip();
            addChild(holder_mc);
        }

        private function createBackground() : void
        {
            bg_mc = new MovieClip();
            bg_mc.graphics.beginFill(BG_COLOR, 1);
            bg_mc.graphics.drawRoundRect(-ratio, -ratio, field_txt.width + ratio * 2, field_txt.height + ratio * 2, ratio, ratio);
            holder_mc.addChild(bg_mc);
            holder_mc.swapChildren(field_txt, bg_mc);
        }

        private function init(param1:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            father = parent as MovieClip;
            left_point = 0;
            top_point = 0;
            right_point = stage.stageWidth;
            bottom_point = stage.stageHeight;
            createHolder();
            createTextField();
            createBackground();
            fixPosition();
            fadeIn();
            addEventListener(Event.ENTER_FRAME, addMovement);
        }

        private function fixPosition() : void
        {
            if (stage.mouseX < stage.stageWidth / 2)
            {
                x = father.mouseX;
            }
            else
            {
                x = father.mouseX - width;
            }
            if (stage.mouseY < stage.stageHeight / 2)
            {
                y = father.mouseY + this.height - ratio * 20;
            }
            else
            {
                y = father.mouseY - this.height;
            }
        }

        private function addMovement(param1:Event) : void
        {
            if (stage.mouseX < stage.stageWidth / 2)
            {
                x = father.mouseX-30;
            }
            else
            {
                x = father.mouseX - this.width + ratio * 2+20;
            }
            if (stage.mouseY < stage.stageHeight / 2)
            {
                y = father.mouseY + this.height - ratio * 2 + 20;
            }
            else
            {
                y = father.mouseY - this.height;
            }
            if (x > stage.stageWidth - this.width)
            {
                x = stage.stageWidth - this.width-20;
            }
            if (x < ratio * 2)
            {
                x = ratio * 2;
            }
        }
        public function destroy() : void
        {
            removeEventListener(Event.ENTER_FRAME, addMovement);
            father.removeChild(this);
        }
    }
}
