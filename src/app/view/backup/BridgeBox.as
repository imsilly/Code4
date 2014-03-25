package app.view
{
    import app.utils.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
	import mdm.Network;
	
    dynamic public class BridgeBox extends MovieClip
    {
        public var bg_mc:MovieClip;
        public var open_btn:MovieClip;
		public var dllBox_mc:MovieClip;
		public var drag_mc:MovieClip;
		
		
        public function BridgeBox()
        {
            bg_mc.small_mc.visible = false;
            drag_mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            drag_mc.addEventListener(MouseEvent.MOUSE_UP, onUp);
			AppUtils.makeButton(open_btn, onMouseAction);
        }
        public function onDown(e)
        {
			this.parent.setChildIndex(this, this.parent.numChildren - 1); 
            startDrag();           
        }

        public function onUp(e)
        {
            stopDrag();           
        }

        public function onMouseAction(e) : void
        {
            if (e.type == MouseEvent.CLICK)
            {
                var targetName:String =e.target.name.toString();
				mdm.Network.UDP.Socket.send("127.0.0.1", 6000, "messagein@eq@"+targetName);
				
				switch(targetName)
				{
					case "open_btn":
						showMe();
						break;
					case "a1":
						break;
					case "a2":
						break;						
					default:break;
				}
            }
            if (e.type == MouseEvent.ROLL_OVER)
            {
                TweenMax.to(e.target, 0.3, {alpha:0.5});
            }
            if (e.type == MouseEvent.ROLL_OUT)
            {
                TweenMax.to(e.target, 0.3, {alpha:1});
            }           
        }
		
		private function a1_func()
		{
			
		}
		
        public function showMe()
        {
			this.parent.setChildIndex(this, this.parent.numChildren - 1); 
            if (bg_mc.small_mc.visible)
            {
                bg_mc.small_mc.visible = false;
                bg_mc.big_mc.visible = true;
				dllBox_mc.visible=true;
				drag_mc.gotoAndStop(1);
            }
            else
            {
                bg_mc.small_mc.visible = true;
                bg_mc.big_mc.visible = false;
				dllBox_mc.visible=false;
				drag_mc.gotoAndStop(2);
            }
           
        }


    }
}
