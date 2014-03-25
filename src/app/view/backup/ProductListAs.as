package app.view
{
    import app.utils.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
	import mdm.Network;
	import mdm.DLL;
	import mdm.Input;

    dynamic public class ProductListA extends MovieClip
    {
        public var a1:MovieClip;
        public var bg_mc:MovieClip;
		public var list_mc:MovieClip;
		public var listB_mc:MovieClip;
        public var open_btn:MovieClip;
		public var drag_mc:MovieClip;
		private var parentMC:MovieClip;
		private var selectItemURL:String = "";
		private var itemName:Array = new Array("平板套装门", "艾仕壁纸", "双人床", "电脑桌", "多功能沙发床", "柞木地板");
		//http://client.72xuan.com/pub/product/303/detail.htm?productId=65181&productIds=65183_65182_65181_65180_65179_65177_65176_65172_65171_&modelInfo={productId:65181,productPrice:1153.0,modelId:20197,modelType:7,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340
		private var itemURL:Array = new Array("modelInfo={productId:65181,productPrice:1153.0,modelId:20197,modelType:7,modelGlisten:1,profile:}",
												"http://client.72xuan.com/pub/product/303/detail.htm?productId=59864&productIds=59872_59871_59870_59869_59868_59867_59866_59865_59864_&modelInfo={productId:59864,productPrice:0.0,modelId:16204,modelType:15,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340",
												"http://client.72xuan.com/pub/product/303/detail.htm?productId=61217&productIds=61217_60732_60731_60643_60642_60462_60461_60457_60456_&modelInfo={productId:61217,productPrice:1200.0,modelId:17017,modelType:0,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340",
												"http://client.72xuan.com/pub/product/303/detail.htm?productId=60559&productIds=60812_60695_60560_60559_60488_60206_60205_60204_60148_&modelInfo={productId:60559,productPrice:224.0,modelId:17329,modelType:0,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340",
												"http://client.72xuan.com/pub/product/303/detail.htm?productId=60802&productIds=61016_61015_60802_60797_60754_60768_60767_60766_60765_&modelInfo={productId:60802,productPrice:599.0,modelId:17008,modelType:0,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340",
												"http://client.72xuan.com/pub/product/303/detail.htm?productId=65131&productIds=65131_65124_65123_65122_65121_65119_65118_65111_65103_&modelInfo={productId:65131,productPrice:214.0,modelId:20080,modelType:15,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340");
	    public function ProductListA()
        {
			parentMC = MovieClip(this.parent);
            bg_mc.small_mc.visible = false;
            drag_mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            drag_mc.addEventListener(MouseEvent.MOUSE_UP, onUp);

			for(var i:int=1;i<7;i++)
			{
				var target:MovieClip = list_mc.getChildByName("c" + i);
				var targetB:MovieClip = listB_mc.getChildByName("c" + i);
				target.__x = target.x;
				target.__y = target.y;
				target.caption_txt.text = itemName[i-1];
				targetB.caption_txt.text = itemName[i-1];
				target.link = itemURL[i-1];
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
				selectItemURL = target.link;
				target.parent.setChildIndex(target, target.parent.numChildren - 1); 
				this.parent.setChildIndex(this, this.parent.numChildren - 1); 
				target.startDrag();
			}
			if(e.type==MouseEvent.MOUSE_UP)
			{
				target.stopDrag();
				selectItemURL = target.link;
				TweenMax.to(target,0.3,{autoAlpha:0,onComplete:generateMouseEvent});
				TweenMax.to(target, 0, { delay:1, autoAlpha:1, x:target.__x, y:target.__y } );
			}
		}
		private function generateMouseEvent():void
		{
				/*var myMousePosition:* = mdm.Input.Mouse.getPosition();
				var ptX = int(myMousePosition[0]);
				var ptY = int(myMousePosition[1]);
				var msgStr:String="UI_MSG_004#"+ptX+"#"+ptY+"#"+selectItemURL;
				log("generateMouseEvent:"+msgStr);
				sendMsg(msgStr);
				mdm.Input.Mouse.generateEvent("LC", ptX, ptY, true);
				log("LC");*/
				
			try{
				var myMousePosition:* = mdm.Input.Mouse.getPosition();
				var ptX = int(myMousePosition[0]);
				var ptY = int(myMousePosition[1]);
				var msgStr:String="UI_MSG_004#"+ptX+"#"+ptY+"#"+selectItemURL;
				log("generateMouseEvent:"+msgStr);
				sendMsg(msgStr);
				mdm.Input.Mouse.generateEvent("LC", ptX, ptY, true);
				log("LC");
			}catch (e:Error)
			{
				log("generate event error!");
			}
			
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
				listB_mc.visible=true;
				drag_mc.gotoAndStop(1);
            }
            else
            {
                bg_mc.small_mc.visible = true;
                bg_mc.big_mc.visible = false;
				list_mc.visible=false;
				listB_mc.visible=false;
				drag_mc.gotoAndStop(2);
            }           
        }
		
		private function log(value:String)
		{
			parentMC.log(value);
		}
    }
}
