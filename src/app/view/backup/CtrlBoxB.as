package app.view
{
    import app.utils.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
	import mdm.Network;
	import mdm.DLL;
	import mdm.Input;
	import com.hurlant.eval.ast.StrictEqual;

    dynamic public class CtrlBoxB extends MovieClip
    {
        public var a1:MovieClip;
        public var bg_mc:MovieClip;
		public var list_mc:MovieClip;
        public var open_btn:MovieClip;
		public var drag_mc:MovieClip;
		private var parentMC:MovieClip;
		private var listA:Array = new Array("","场景的显示与隐藏","界面上各种按钮的显示与隐藏","下载户型(毛坯房)","下载样板间","更换视角-正交俯视","更换视角-普通漫游","更换视角-第一视角");
		private var listB:Array = new Array("","导出","撤销","恢复","画墙","建房","分割","挖空");
		private var listC:Array = new Array("","","","","","","","");
		public function CtrlBoxB()
        {
			parentMC = MovieClip(this.parent);
            bg_mc.small_mc.visible = false;
            drag_mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            drag_mc.addEventListener(MouseEvent.MOUSE_UP, onUp);

			for(var i:int=1;i<=7;i++)
			{				
				target = list_mc.getChildByName("c"+i);
				AppUtils.makeButton(target, onMouseAction);
			}
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
		public function onMouseActionC(e):void
		{
			var target:* = e.target;
			if(e.type==MouseEvent.MOUSE_DOWN)
			{
				target.startDrag();
			}
			if(e.type==MouseEvent.MOUSE_UP)
			{
			}
		}
		private function generateMouseEvent():void
		{
			log("generateMouseEvent.");
			var myMousePosition:* = mdm.Input.Mouse.getPosition();
			var ptX = int(myMousePosition[0]);
			var ptY = int(myMousePosition[1]);
			//UI_MSG_004#523#556#
			var msgStr:String="UI_MSG_004#"+ptX+"#"+ptY+"#"+itemStr;
			log(msgStr);
			sendMsg(msgStr);
			mdm.Input.Mouse.generateEvent("LC", ptX, ptY, true);
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
						//场景的显示与隐藏
						sendMsg("UI_MSG_001");
						break;
					case "a2":
						//界面上各种按钮的显示与隐藏
						sendMsg("UI_MSG_006");
						break;
					case "a3":
						//下载户型
						sendMsg("UI_MSG_007#14870");
						break;
					case "a4":
						//下载样板间
						sendMsg("UI_MSG_008#111091");
						break;
					case "a5":
						//更换视角
						sendMsg("UI_MSG_401#1");
						break;
					case "a6":
						//更换视角
						sendMsg("UI_MSG_401#2");
						break;
					case "a7":						
						//更换视角
						sendMsg("UI_MSG_401#3");
						break;
					case "c1":
						
						break;
					case "c2":
						//导出
						sendMsg("UI_MSG_108");
						break;
					case "c3":
						//撤销
						sendMsg("UI_MSG_201");
						break;
					case "c4":
						//恢复
						sendMsg("UI_MSG_202");
						break;
					case "c5":
						//画墙
						sendMsg("UI_MSG_302");
						break;
					case "c6":
						//建房
						sendMsg("UI_MSG_303");
						break;
					case "c7":
						//分割
						sendMsg("UI_MSG_304");
						break;
					case "c8":
						//挖空
						sendMsg("UI_MSG_305");
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

		function sendMsg(msg:String)
		{
			myDLL = new mdm.DLL("bridge.dll");
			myDLL.clear();
			var paraIndex:Number=0;
			paraIndex = myDLL.addParameter("string","72xuan3DEngine");
			paraIndex = myDLL.addParameter("string",msg);
			var myReturn:* = myDLL.call("integer","sendData");
			log("callDLL return:"+myReturn);
		}
		
        private function showMe()
        {
            if (bg_mc.small_mc.visible)
            {
                bg_mc.small_mc.visible = false;
                bg_mc.big_mc.visible = true;
            }
            else
            {
                bg_mc.small_mc.visible = true;
                bg_mc.big_mc.visible = false;
            }           
        }
		
		private function log(value:String)
		{
			parentMC.log(value);
		}
    }
}
