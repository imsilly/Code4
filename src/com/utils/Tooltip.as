/** 
* @author Kinglong 
* @version 0.1 
*/  
  
package com.utils {  
      
    import flash.display.*;   
    import flash.events.*;  
    import flash.text.*;  
    import flash.utils.*;  
    import flash.filters.*;  
      
    public class ToolTip extends Sprite {  
          
        private static var _instance:ToolTip;  
          
        private var _label:TextField;         
        public function ToolTip(base:Sprite) {  
            _label = new TextField();  
            _label.autoSize = TextFieldAutoSize.LEFT;  
            _label.textColor = 0x333333;  
            _label.text = " ";  
            _label.selectable = false;  
            _label.x = 3;  
            _label.y = 2;  
            addChild(_label);             
            filters = [getBitmapFilter()];  
            base.addChild(this);              
            _instance = this;  
            _hide();  
        }  
          
        public static function show(lbl:String):void {  
            if (_instance == null) {  
                return;  
            }  
            _instance._show(lbl);  
        }  
          
        public function _show(lbl:String):void {  
            visible = true;  
            _label.text = lbl;  
            updateShape();  
        }  
          
        public static function hide():void {  
            if (_instance == null) {  
                return;  
            }  
            _instance._hide();  
        }     
          
        public function _hide():void {  
            visible = false;  
        }  
          
        public static function move(x:Number, y:Number):void {  
            if (_instance == null) {  
                return;  
            }  
            _instance._move(x, y);            
        }  
          
        public function _move(x:Number, y:Number):void {  
            this.x = (x+this.width>stage.stageWidth)?stage.stageWidth-this.width:x;  
            this.y = y - this.height;  
        }  
          
        private function changeHandler(event:Event):void {  
            updateShape();  
        }  
          
        private function updateShape():void {  
            var w:Number = _label.textWidth + 8;              
            var h:Number = 23;  
            graphics.clear();  
            graphics.beginFill(0x6F0A13);  
            graphics.drawRoundRect(0, 0, w, h, 7, 7);  
            graphics.endFill();  
            graphics.beginFill(0xFFFFE1);  
            graphics.drawRoundRect(1, 1, w-2, h-2, 7, 7);  
            graphics.endFill();           
        }  
          
        private function getBitmapFilter():BitmapFilter {  
            var color:Number = 0x000000;  
            var alpha:Number = 0.3;  
            var blurX:Number = 5;  
            var blurY:Number = 5;  
            var strength:Number = 2;  
            var inner:Boolean = false;  
            var knockout:Boolean = false;  
            var quality:Number = BitmapFilterQuality.HIGH;  
  
            return new GlowFilter(color,  
                                  alpha,  
                                  blurX,  
                                  blurY,  
                                  strength,  
                                  quality,  
                                  inner,  
                                  knockout);  
        }     
          
  
    }  
      
}  
