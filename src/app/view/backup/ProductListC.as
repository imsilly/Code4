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
	import flash.net.Responder;

	dynamic public class ProductListC extends MovieClip
	{
		public var a1:MovieClip;
		public var bg_mc:MovieClip;
		public var list_mc:MovieClip;
		public var listB_mc:MovieClip;
		public var open_btn:MovieClip;
		public var drag_mc:MovieClip;
		//private var parentMC:MovieClip;
		private var selectItemURL:String = "";
		private var itemName:Array = new Array("平板套装门","艾仕壁纸","双人床","电脑桌","多功能沙发床","柞木地板");
		//http://client.72xuan.com/pub/product/303/detail.htm?productId=65181&productIds=65183_65182_65181_65180_65179_65177_65176_65172_65171_&modelInfo={productId:65181,productPrice:1153.0,modelId:20197,modelType:7,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340
		private var itemURL:Array = new Array("modelInfo={productId:65181,productPrice:1153.0,modelId:20197,modelType:7,modelGlisten:1,profile:}",
		"http://client.72xuan.com/pub/product/303/detail.htm?productId=59864&productIds=59872_59871_59870_59869_59868_59867_59866_59865_59864_&modelInfo={productId:59864,productPrice:0.0,modelId:16204,modelType:15,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340",
		"http://client.72xuan.com/pub/product/303/detail.htm?productId=61217&productIds=61217_60732_60731_60643_60642_60462_60461_60457_60456_&modelInfo={productId:61217,productPrice:1200.0,modelId:17017,modelType:0,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340",
		"http://client.72xuan.com/pub/product/303/detail.htm?productId=60559&productIds=60812_60695_60560_60559_60488_60206_60205_60204_60148_&modelInfo={productId:60559,productPrice:224.0,modelId:17329,modelType:0,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340",
		"http://client.72xuan.com/pub/product/303/detail.htm?productId=60802&productIds=61016_61015_60802_60797_60754_60768_60767_60766_60765_&modelInfo={productId:60802,productPrice:599.0,modelId:17008,modelType:0,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340",
		"http://client.72xuan.com/pub/product/303/detail.htm?productId=65131&productIds=65131_65124_65123_65122_65121_65119_65118_65111_65103_&modelInfo={productId:65131,productPrice:214.0,modelId:20080,modelType:15,modelGlisten:1,profile:}&KeepThis=true&TB_iframe=true&modal=true&height=615&width=340");

		private var gateway:RemotingConnection = new RemotingConnection("http://192.168.1.6/72xuan/gateway.php");		
		//设置搜索动作，模糊搜索：blearSearch，分类搜索：typeSearch
		private var searchAction:String = "blearSearch";
		private var typeID:String;		
		private var searchStr:String = "";		
		private var isPageButton:Boolean = false;
		private var responder:Responder;

		public function ProductListC()
		{
			//parentMC = MovieClip(this.parent);
			bg_mc.small_mc.visible = false;
			drag_mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			drag_mc.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			responder = new Responder(onResult,onError);
			blearSearchProduct("", "1");

			for (var i:int=1; i<7; i++)
			{
				var target:MovieClip = MovieClip(list_mc.getChildByName("c" + i));
				AppUtils.makeButton(target, onMouseActionC);
			}
			//setProductList(itemName,itemURL);
			setProductList(itemName);
			AppUtils.makeButton(open_btn, onMouseAction);

			search_mc.search_btn.addEventListener(MouseEvent.CLICK, onBlearSearchClick);
			search_mc.search_btn.caption_txt.text = "搜索";
			
			initTypeSearchButton();
			initPageShowButton();
		}
		
		private function initTypeSearchButton():void
		{
			var btn:MovieClip = MovieClip(type_btns.type_btn_0);
			btn.caption_txt.text = "家具";
			btn.typeID = "77";
			btn.addEventListener(MouseEvent.CLICK, onTypeSearchClick);
			
			btn = MovieClip(type_btns.type_btn_1);
			btn.caption_txt.text = "电器";
			btn.typeID = "77";
			btn.addEventListener(MouseEvent.CLICK, onTypeSearchClick);
			
			btn = MovieClip(type_btns.type_btn_2);
			btn.caption_txt.text = "地板";
			btn.typeID = "77";
			btn.addEventListener(MouseEvent.CLICK, onTypeSearchClick);
			
			btn = MovieClip(type_btns.type_btn_3);
			btn.caption_txt.text = "门窗";
			btn.typeID = "77";
			btn.addEventListener(MouseEvent.CLICK, onTypeSearchClick);
			
		}
		
		private function initPageShowButton():void
		{
			var btn:SimpleButton;
			for(var i:int=0;i<10;i++)
			{
				btn = page_btns["page_btn_"+String(i)];
				//trace("btn.name:"+btn.name);
				btn.addEventListener(MouseEvent.CLICK, onPageButtonClick);
			}
		}
		
		private function showPageButton(num:int):void
		{
			var btn:SimpleButton;
			for(var i:int=0;i<10;i++)
			{
				btn = page_btns["page_btn_"+String(i)];
				if(i<num)
				{
					btn.visible = true;
				}
				else
				{
					btn.visible = false;
				}
			}
		}

		private function onPageButtonClick(evt:MouseEvent):void
		{
			isPageButton = true;
			var n:String = evt.currentTarget.name;
			var pageID:String = String(int(n.slice(n.length-1,n.length)) + 1);
			trace("btn.name:"+pageID);
			
			if(searchAction == "typeSearch")
			{
				typeSearchProduct(typeID, pageID);
			}
			else if(searchAction == "blearSearch")
			{
				blearSearchProduct(searchStr, pageID);
			}
		}

		private function onTypeSearchClick(evt:MouseEvent):void
		{
			isPageButton = false;
			searchAction = "typeSearch";
			typeID = evt.currentTarget.typeID;
			var pageID:String = "1";
			trace("typeID:"+typeID);
			typeSearchProduct(typeID, pageID);
		}

		private function onBlearSearchClick(evt:MouseEvent):void
		{
			isPageButton = false;
			searchAction = "blearSearch";
			var pageID:String = "1";
			searchStr = search_mc.search_txt.text;
			blearSearchProduct(searchStr, pageID);
		}
		
		//模糊搜索
		private function blearSearchProduct(searchStr:String, pageID:String, pageSize:String = "6"):void
		{
			//gateway.call("gs.GetProductListByTypeID",new Responder(onResult,onError),typeID,pageID,pageSize);
			//gateway.call("gs.GetDataByKeyword",new Responder(onResult,onError),searchStr,pageID,pageSize);
			gateway.call("gs.GetDataByKeyword",responder,searchStr,pageID,pageSize);
		}
		
		//分类搜索
		private function typeSearchProduct(typeID:String, pageID:String, pageSize:String = "6"):void
		{
			gateway.call("gs.GetProductListByTypeID",responder,typeID,pageID,pageSize);
			//gateway.call("gs.GetDataByKeyword",new Responder(onResult,onError),searchStr,pageID,pageSize);
			//gateway.call("gs.GetDataByKeyword",new Responder(onResult,onError),searchStr,pageID,pageSize);
		}
		
		private function setProductList(names:Array,imageUrls:Array=null,links:Array=null):void
		{
			for (var i:int=1; i<7; i++)
			{
				var target:MovieClip = MovieClip(list_mc.getChildByName("c" + i));
				var targetB:MovieClip = MovieClip(listB_mc.getChildByName("c" + i));
				target.__x = target.x;
				target.__y = target.y;
				var name:String = names[i - 1];
				trace(name);
				target.caption_txt.text = name;
				targetB.caption_txt.text = name;
				//target.link = urls[i - 1];
				if(imageUrls!=null)
				{
					var url:String = imageUrls[i - 1];
					target.loadImage(url);
					targetB.loadImage(url);
				}
			}
		}
		function onError(result:Object):void
		{
			trace("onError");
		}
		function onResult(result:Object):void
		{
			trace("onResult");
			for (var s:String in result)
			{
				trace(s+"::"+result[s]);
				var o:Object = result[s];
				for (var ss:String in o)
				{
					trace(ss+":"+o[ss]);
				}
			}
			var basicURL:String = "http://image.72xuan.com/product";
			var itemArray:Array = DataParser.resultToArray(result,false);
			if (itemArray.length == 0)
			{
				return;
			}

			var urls:Array = [];
			var names:Array = [];
			var url:String;
			var totalNum:int;
			
//65404,77,30753,1103021819124391.jpg,201103/02,爱格测试,
//65153,77,30173,1101200955450548.jpg,/201101/20/,釉艺面田园风格地板YM206,

			for (var i:int=0; i<=5; i++)
			{
				if (i <= itemArray.length)
				{
					//var target:* = list_mc.getChildByName("a" + i);
					o = itemArray[i];
					var n:String = o.product_name;
					totalNum = int(o.totalNumber);
					url = o.url;
					
					if(url.slice(0,1)!="/")
					{
						url = "/"+url;
					}
					
					var len:int = url.length;
					if(url.slice(len-1,len)!="/")
					{
						url += "/";
					}
					
					var newURL:String = basicURL + url + "100_100/" + o.pic_name;
					trace("newURL:"+newURL);
					trace("newName:"+n);
					urls.push(newURL);
					names.push(n);

					//TweenMax.to(MovieClip(target),0.3,{delay:(i+1)*0.2,autoAlpha:1});
					//target.id = o.product_id;
					//target.url = newURL;
					//target.o = o;
					//target.caption_txt.text = o.product_name;
					//AppUtils.makeButton(target, onMouseAction);
				}
			}
			setProductList(names,urls);
			var pageNum:int = totalNum/6+0.9;
			this.showPageButton(pageNum);
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
			if (e.type == MouseEvent.MOUSE_DOWN)
			{
				selectItemURL = target.link;
				target.parent.setChildIndex(target, target.parent.numChildren - 1);
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
				target.startDrag();
			}
			if (e.type == MouseEvent.MOUSE_UP)
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

			try
			{
				var myMousePosition:* = mdm.Input.Mouse.getPosition();
				var ptX = int(myMousePosition[0]);
				var ptY = int(myMousePosition[1]);
				var msgStr:String = "UI_MSG_004#" + ptX + "#" + ptY + "#" + selectItemURL;
				log("generateMouseEvent:"+msgStr);
				sendMsg(msgStr);
				mdm.Input.Mouse.generateEvent("LC", ptX, ptY, true);
				log("LC");
			}
			catch (e:Error)
			{
				log("generate event error!");
			}

		}
		public function onMouseAction(e):void
		{
			if (e.type == MouseEvent.CLICK)
			{
				var targetName:String = e.target.name.toString();
				//mdm.Network.UDP.Socket.send("127.0.0.1", 6000, "messagein@eq@"+targetName);

				switch (targetName)
				{
					case "open_btn" :
						showMe();
						break;

					default :
						break;
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
			var myDLL:* = new mdm.DLL("bridge.dll");
			myDLL.clear();
			var paraIndex:Number = 0;
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
				list_mc.visible = true;
				listB_mc.visible = true;
				search_mc.visible = true;
				type_btns.visible = true;
				page_btns.visible = true;
				drag_mc.gotoAndStop(1);
			}
			else
			{
				bg_mc.small_mc.visible = true;
				bg_mc.big_mc.visible = false;
				list_mc.visible = false;
				listB_mc.visible = false;
				search_mc.visible = false;
				type_btns.visible = false;
				page_btns.visible = false;
				drag_mc.gotoAndStop(2);
			}
		}

		private var _log:String = "";
		private function log(value:String)
		{
			//parentMC.log(value);
			_log = value;
			this.dispatchEvent(new Event("log"));
		}

		public function get logMsg():String
		{
			return _log;
		}
	}
}