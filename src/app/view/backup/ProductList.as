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

    dynamic public class ProductList extends MovieClip
    {
        public var a1:MovieClip;
        public var bg_mc:MovieClip;
		public var list_mc:MovieClip;
        public var open_btn:MovieClip;
		public var drag_mc:MovieClip;
		private var parentMC:MovieClip;
		public function ProductList()
        {
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			parentMC = MovieClip(this.parent);
            bg_mc.small_mc.visible = false;
            drag_mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            drag_mc.addEventListener(MouseEvent.MOUSE_UP, onUp);

			for(var i:int=0;i<=9;i++)
			{
				var target:* = list_mc.getChildByName("a" + i);
				target.visible = false;
				//target.caption_txt.text = listA[i];
				//AppUtils.makeButton(target, onMouseAction);
			}
            AppUtils.makeButton(open_btn, onMouseAction);
			getInfoList();
        }
		function getInfoList():void
		{
			try
			{
				var configInfo = Controller.getInstance().configInfo;
				
				if(configInfo.ServerURL==null)
				{
					configInfo.ServerURL = "http://192.168.1.6/72xuan/gateway.php";
				}
				var gateway:RemotingConnection = new RemotingConnection(configInfo.ServerURL);
				var sql:String = "select * from sort where level=3";
				gateway.call("gs.SQLAdmin",new Responder(onResult,onError),sql);
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
			//var basicURL:String="http://image.72xuan.com/product";
			var itemArray:Array = DataParser.resultToArray(result,false);
			for (var i:int=0; i<=9; i++)
			{
				var target:* = list_mc.getChildByName("a" + i);
				var o:Object = itemArray[i];
				target.visible = true;
				target.id = o.sort_id;
				target.caption_txt.text = o.name;
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

        public function onMouseAction(e) : void
        {
            if (e.type == MouseEvent.CLICK)
            {
                var targetName:String =e.target.name.toString();
				//mdm.Network.UDP.Socket.send("127.0.0.1", 6000, "messagein@eq@"+targetName);
				if (targetName == "open_btn")
				{
					showMe();
				}else {
					trace(e.target.id);
					Controller.getInstance().main.showProductBox(e.target.id);
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
			/*myDLL = new mdm.DLL("bridge.dll");
			myDLL.clear();
			var paraIndex:Number=0;
			paraIndex = myDLL.addParameter("string","72xuan3DEngine");
			paraIndex = myDLL.addParameter("string",msg);
			var myReturn:* = myDLL.call("integer","sendData");
			log("callDLL return:"+myReturn);*/
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
