package app.view
{
    import app.utils.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
	import mdm.Network;
	import mdm.DLL;
	import mdm.Input;

    dynamic public class ComponentList extends MovieClip
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
		private var itemStr:String = "http://client.72xuan.com/pub/product/303/detail.htm?productId=60045&productIds=60278_60096_60068_60050_60049_60045_60043_57919_57892_&modelInfo={productId:60045,productPrice:0.0,modelId:16351,modelType:0,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340";
        public function ComponentList()
        {
			parentMC = MovieClip(this.parent);
            bg_mc.small_mc.visible = false;
            drag_mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            drag_mc.addEventListener(MouseEvent.MOUSE_UP, onUp);

			for(var i:int=1;i<=7;i++)
			{
				var target:MovieClip = list_mc.getChildByName("a"+i);
				target.caption_txt.text = listA[i];
				AppUtils.makeButton(target, onMouseAction);
				
				target = list_mc.getChildByName("b"+i);
				target.caption_txt.text = listB[i];
				AppUtils.makeButton(target, onMouseAction);

				target = list_mc.getChildByName("c"+i);
				target.__x = target.x;
				target.__y = target.y;
				target.caption_txt.text = listC[i];
				AppUtils.makeButton(target, onMouseActionC);
			}
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
		public function onMouseActionC(e):void
		{
			var target:* = e.target;
			if(e.type==MouseEvent.MOUSE_DOWN)
			{
				target.startDrag();
			}
			if(e.type==MouseEvent.MOUSE_UP)
			{
				target.stopDrag();
				var myMousePosition:* = mdm.Input.Mouse.getPosition();
				//var ptX = int(myMousePosition[0]);
				//var ptY = int(myMousePosition[1]);
				//UI_MSG_004#523#556#
				//var msgStr:String="UI_MSG_004#"+ptX+"#"+ptY+"#"+itemStr;
				//log(msgStr);
				//sendMsg(msgStr);
				//mdm.Input.Mouse.generateEvent("LC", ptX, ptY, true);
				TweenMax.to(target,0.3,{autoAlpha:0,onComplete:generateMouseEvent});
				TweenMax.to(target,0.3,{delay:1,autoAlpha:1,x:target.__x,y:target.__y});
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
						sendMsg("UI_MSG_006#1");
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
					case "b1":
						//导出
						sendMsg("UI_MSG_108");
						break;
					case "b2":
						//撤销
						sendMsg("UI_MSG_201");
						break;
					case "b3":
						//恢复
						sendMsg("UI_MSG_202");
						break;
					case "b4":
						//画墙
						sendMsg("UI_MSG_302");
						break;
					case "b5":
						//建房
						sendMsg("UI_MSG_303");
						break;
					case "b6":
						//分割
						sendMsg("UI_MSG_304");
						break;
					case "b7":
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

		public function sendMsg(msg:String)
		{
			myDLL = new mdm.DLL("bridge.dll");
			myDLL.clear();
			var paraIndex:Number=0;
			paraIndex = myDLL.addParameter("string","72xuan3DEngine");
			paraIndex = myDLL.addParameter("string",msg);
			var myReturn:* = myDLL.call("integer","sendData");
			log("callDLL return:"+myReturn);
		}
		
        public function showMe()
        {
			this.parent.setChildIndex(this, this.parent.numChildren - 1); 
            if (bg_mc.small_mc.visible)
            {
                bg_mc.small_mc.visible = false;
                bg_mc.big_mc.visible = true;
				list_mc.visible=true;
				drag_mc.gotoAndStop(1);
            }
            else
            {
                bg_mc.small_mc.visible = true;
                bg_mc.big_mc.visible = false;
				list_mc.visible=false;
				drag_mc.gotoAndStop(2);
            }           
        }
		
		private function log(value:String)
		{
			parentMC.log(value);
		}
    }
}
