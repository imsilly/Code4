package app.view
{
    import app.utils.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
	import mdm.Network;
	import mdm.DLL;
	import mdm.Input;
	import app.RemotingConnection;
	import app.vo.ConfigInfo;
	import app.Controller;
	import flash.net.Responder;

    dynamic public class ProductBox extends MovieClip
    {
        public var a1:MovieClip;
        public var bg_mc:MovieClip;
		public var list_mc:MovieClip;
        public var open_btn:MovieClip;
		public var drag_mc:MovieClip;
		private var parentMC:MovieClip;
		public function ProductBox()
        {
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e):void
		{
			Controller.getInstance().productBox = this;
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
            drag_mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            drag_mc.addEventListener(MouseEvent.MOUSE_UP, onUp);

			for(var i:int=0;i<=5;i++)
			{
				var target:* = list_mc.getChildByName("a" + i);
				target.visible = false;
				target.__x = target.x;
				target.__y = target.y;
			}
			//changeInfoList();
        }
		public function changeInfoList(typeID:String="77"):void
		{
			for (var i:int = 0; i <=5; i++)
			{
				var target:* = list_mc.getChildByName("a" + i);
				AppUtils.gcButton(target, onMouseAction);
				TweenMax.to(target, 0.3, { delay:i * 0.1, autoAlpha:0 } );

			}
			try
			{
				var configInfo = Controller.getInstance().configInfo;
				
				if(configInfo.ServerURL==null)
				{
					configInfo.ServerURL = "http://192.168.1.6/72xuan/gateway.php";
				}
				var gateway:RemotingConnection = new RemotingConnection(configInfo.ServerURL);
				var pageID:String="1";
				var pageSize:String="6";
				gateway.call("gs.GetProductListByTypeID",new Responder(onResult,onError),typeID,pageID,pageSize);
			}
			catch (e:Error)
			{
				trace("Try Error:",e.message);
			}
		}
		function onError(result:Object):void
		{
			
		}
		function onResult(result:Object):void
		{
			var basicURL:String="http://image.72xuan.com/product";
			var itemArray:Array = DataParser.resultToArray(result, false);
			if (itemArray.length == 0)
			{
				return;
			}
			for (var i:int=0; i<=5; i++)
			{
				if (i <= itemArray.length)
				{
					var target:* = list_mc.getChildByName("a" + i);
					var o:Object = itemArray[i];
					var newURL:String = basicURL+o.url+"100_100/"+o.pic_name;
					TweenMax.to(MovieClip(target),0.3,{delay:(i+1)*0.2,autoAlpha:1});
					target.id = o.product_id;
					target.url = newURL;
					target.o = o;
					target.caption_txt.text = o.product_name;
					AppUtils.makeButton(target, onMouseAction);
				}
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

        public function onMouseAction(e) : void
        {
			var target:* = e.target;
            if (e.type == MouseEvent.CLICK)
            {
                var targetName:String =e.target.name.toString();
				//mdm.Network.UDP.Socket.send("127.0.0.1", 6000, "messagein@eq@"+targetName);
				if (targetName == "open_btn")
				{
					showMe();
				}else{
					trace(e.target.id);
				}
            }
            if (e.type == MouseEvent.MOUSE_DOWN)
            {
				if (targetName != "open_btn")
				{
					this.parent.setChildIndex(this, this.parent.numChildren - 1); 
					target.parent.setChildIndex(target, target.parent.numChildren - 1); 
					target.startDrag(); 
				}
            }
            if (e.type == MouseEvent.MOUSE_UP)
            {
				if (targetName != "open_btn")
				{
					target.stopDrag();
					//var myMousePosition:* = mdm.Input.Mouse.getPosition();
					//TweenMax.to(target, 0.3, { autoAlpha:0, onComplete:generateMouseEvent } );
					//TweenMax.to(target, 0, { delay:0.4,  x:target.__x, y:target.__y } );
					//TweenMax.to(target, 0.3, { delay:1, autoAlpha:1 } );
					TweenMax.to(target,0.3,{autoAlpha:0,onComplete:generateMouseEvent});
					TweenMax.to(target,0.3,{delay:1,autoAlpha:1,x:target.__x,y:target.__y});					
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
		private function generateMouseEvent():void
		{
			
			var myMousePosition:* = mdm.Input.Mouse.getPosition();
			log("generateMouseEvent."+myMousePosition);
			var ptX = int(myMousePosition[0]);
			var ptY = int(myMousePosition[1]);
			//UI_MSG_004#523#556#
			var msgStr:String="UI_MSG_004#"+ptX+"#"+ptY+"#"+itemStr;
			log(msgStr);
			sendMsg(msgStr);
			mdm.Input.Mouse.generateEvent("LC", ptX, ptY, true);
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
			Controller.getInstance().main.log(value);
		}
    }
}
