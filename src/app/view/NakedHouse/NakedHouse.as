package app.view.NakedHouse{

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import app.RemotingConnection;
	import flash.net.Responder;
	import app.utils.*;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import mdm.DLL;
	import mdm.Forms;

	public class NakedHouse extends MovieClip {
		private var gateway:RemotingConnection;
		private var searchStr:String="1";
		private var pageID:int=1;
		private var pageSize:int = 8;
		//排列属性
		private var sortID:int = 2;

		private var responderN:Responder;
		private var mainArr:Array;
		private var baseURL:String = "http://image.72xuan.com/house";
		private var produceArr:Array;
		private var oldId:String;
		private var oldIsType:Boolean = true;
		private var oldPageNum:int = 1;
		private var newPageNum:int = 1;

		//是否需要清空
		private var needCl:Boolean = false;

		//测试加载10.1并调用
		private var loadertest:Loader = new Loader();
		private var loadMc:MovieClip;
		private var clBtn:closeBtn;
		public var d3BackCor:MovieClip;
		public var serUrl:String="http://192.168.1.6/72xuan/gateway.php";

		public function NakedHouse() {
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		private function addToStage(e) {
			// constructor code
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			//init();
		}
		public function init() {
			setDefaultBox();
			responderN = new Responder(onResult, onError);
			loginIng.visible = false;
			gateway = new RemotingConnection(serUrl);
			gateway.call("house.GetProductListByTypeID", responderN, sortID, pageID, pageSize);
			oldIsType = true;
			oldId = String(sortID);
			loginIng.visible = true;
			this.inputT.addEventListener(FocusEvent.FOCUS_IN, isInit);
			this.a1.addEventListener(MouseEvent.CLICK, gotype1);
			this.a2.addEventListener(MouseEvent.CLICK, gotype2);
			this.a3.addEventListener(MouseEvent.CLICK, gotype3);
			this.a4.addEventListener(MouseEvent.CLICK, gotype4);
			this.a5.addEventListener(MouseEvent.CLICK, gotype5);
			this.maskMain.visible = false;
			this.d3BackCor.visible = false;
			//stage.addEventListener(MouseEvent.CLICK, hellogate);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyIsDown);
		}
		private function keyIsDown(e:KeyboardEvent) {
			if (e.keyCode == 13) {
				var msEvent:MouseEvent = new MouseEvent(MouseEvent.CLICK);
				goSea(msEvent);
			}
		}

		private function remove3d(e:MouseEvent) {
			clBtn.removeEventListener(MouseEvent.CLICK, remove3d);
			clBtn.toEngBtn.removeEventListener(MouseEvent.CLICK, goEng);
			//d3BackCor.x = -600;
			d3BackCor.visible = false;
			nakedAndReturnMouseRemove();
			removeChild(clBtn);
			myBrowser.close();
		}
		private function goEng(e:MouseEvent) {
			clBtn.removeEventListener(MouseEvent.CLICK, remove3d);
			clBtn.toEngBtn.removeEventListener(MouseEvent.CLICK, goEng);
			//d3BackCor.x = -600;
			d3BackCor.visible = false;
			nakedAndReturnMouseRemove();
			removeChild(clBtn);
			myBrowser.close();
			sendMsg("UI_MSG_007#"+itemId);
			mdm.Forms.getFormByName("NakedHouseBox").hide();
		}
		private function hellogate(e:MouseEvent) {
			//gateway.call("house.GetProductListByTypeID",responderN,sortID,pageID,pageSize);
			//gateway.call("house.GetDataByKeyword",responderN,searchStr,pageID,pageSize);
		}
		private function setDefaultBox() {
			produceArr = new Array();
			for (var i:int = 0; i < 8; i++ ) {
				var BoxItem:Chanpin = new Chanpin();
				BoxItem.x = (i % 4)*146+40;
				BoxItem.y = Math.floor(i / 4)*140+120;
				addChildAt(BoxItem,1);
				produceArr.push(BoxItem);
				produceArr[i].ylBtn.btn_1.addEventListener(MouseEvent.CLICK,onClick);
				produceArr[i].btn.addEventListener(MouseEvent.CLICK,onClickPreview);
			}
			this.seaBar.seachBar.seachBtn.addEventListener(MouseEvent.CLICK, goSea);
			this.goPage_btn.addEventListener(MouseEvent.CLICK, goPage);
		}
		private function onResult(result:Object):void {
			loginIng.visible =false;
			try{
				var itemArray:Array = DataParser.resultToArray(result, false);
				mainArr = itemArray;
				setBox();
				if (itemArray.length == 0){
					return;
				}
			}catch(e)
			{
				trace(e.message);
			}
		}
		private function onError(result:Object){
			trace("onError");
		}
		private function setBox() {
			if (mainArr.length > 0) {
				searchStr = oldId;
				oldPageNum = newPageNum;
				if (oldIsType) {
					senKey = false;
				}else {
					senKey = true;
				}
				var timeline:TimelineLite = new TimelineLite();
				for (var j:int = 0; j < 8; j++ ) {
					produceArr[j].visible = false;
					produceArr[j].alpha = 0;
				}
				for (var i:int = 0; i < mainArr.length; i++ ) {
					var obj:Object = mainArr[i];
					produceArr[i].visible = true;
					produceArr[i].alpha = 1;
					produceArr[i].data = obj;
					this.proNum.text = obj.totalNumber;
					timeline.insert(TweenLite.from(produceArr[i], 0.3, { alpha:0, delay:i * 0.2 } ));
				}
				timeline.play();
				needCl = true;
			}else {
				trace("你啥都没搜到");
				page_txt.text = String(oldPageNum);
				this.proNum.text = "0";
			}

		}
		private function onClick(e)
		{
			var id:String = e.currentTarget.parent.parent.data.house_id.toString();
			sendMsg("UI_MSG_007#"+id);
			mdm.Forms.getFormByName("NakedHouseBox").hide();
		}
		var itemId:String;
		var myBrowser:*;
		private function onClickPreview(e) {
			itemId = e.target.parent.data.house_id.toString();
			d3BackCor.visible = true;
			d3BackCor.x = 22;
			d3BackCor.y = 65;
			clBtn = new closeBtn();
			clBtn.x =595;
			clBtn.y = 53;
			addChild(clBtn);
			nakedAndReturnMouse();//http://www.72xuan.org/demo/DreamMaster/Main.swf?foo=1100&server_URL=http://www.72xuan.com/cms/flash_server/server/
			myBrowser = new mdm.Browser(d3BackCor.x-5, d3BackCor.y-5,d3BackCor.width, d3BackCor.height+5, "http://www.72xuan.org/demo/DreamMaster/Main.swf?foo="+itemId+"&server_URL=http://www.72xuan.com/cms/flash_server/server/", false);
			//myBrowser = new mdm.Browser(d3BackCor.x-5, d3BackCor.y-5,d3BackCor.width, d3BackCor.height+5, "http://silly.eblhost.com/72xuan/flash/xuan3d.swf?foo="+itemId+"&server_URL=http://silly.eblho124st.com/72xuan/server/", false);
			myBrowser.onDocumentComplete = function(myObject){
				var message = myObject.url + "加载成功!";
				myBrowser.show();
				clBtn.closeBtnL.addEventListener(MouseEvent.CLICK, remove3d);
				clBtn.toEngBtn.addEventListener(MouseEvent.CLICK, goEng);

			}
		}
		private function nakedAndReturnMouse() {
			trace("set BTn")
			clBtn.toEngBtn.addEventListener(MouseEvent.MOUSE_OVER,engMouseisOver);
			clBtn.toEngBtn.addEventListener(MouseEvent.MOUSE_OUT, engMouseisOut);
			clBtn.closeBtnL.addEventListener(MouseEvent.MOUSE_OVER,clBtnMouseisOver);
			clBtn.closeBtnL.addEventListener(MouseEvent.MOUSE_OUT,clBtnMouseisOut);
		}
		private function engMouseisOver(e:MouseEvent){
			clBtn.toEngBtn.gotoAndPlay("over");
		}
		private function engMouseisOut(e:MouseEvent){
			clBtn.toEngBtn.gotoAndPlay("out");
		}

		private function clBtnMouseisOver(e:MouseEvent){
			clBtn.closeBtnL.gotoAndPlay("over");
		}
		private function clBtnMouseisOut(e:MouseEvent){
			clBtn.closeBtnL.gotoAndPlay("out");
		}
		private function nakedAndReturnMouseRemove() {
			clBtn.toEngBtn.removeEventListener(MouseEvent.MOUSE_OVER,engMouseisOver);
			clBtn.toEngBtn.removeEventListener(MouseEvent.MOUSE_OUT, engMouseisOut);
			clBtn.closeBtnL.removeEventListener(MouseEvent.MOUSE_OVER,clBtnMouseisOver);
			clBtn.closeBtnL.removeEventListener(MouseEvent.MOUSE_OUT,clBtnMouseisOut);
		}

		private function sendMsg(msg:String)
		{
			var myDLL = new mdm.DLL("bridge.dll");
			myDLL.clear();
			var paraIndex:Number=0;
			paraIndex = myDLL.addParameter("string","72xuan3DEngine");
			paraIndex = myDLL.addParameter("string",msg);
			var myReturn:* = myDLL.call("integer","sendData");
		}
		private function cleanBox() {
			loginIng.visible = true;
		}

		private function goSea(e:MouseEvent) {
			if(searchStr!=""&&searchStr!=null){
				cleanBox();
				gateway.call("house.GetDataByKeyword", responderN, searchStr, 1, pageSize);
				newPageNum = 1;
				oldIsType = false;
				oldId = String(searchStr);
				this.inputT.text = "搜索";
				this.page_txt.text = "1";
			}
		}
		private var senKey:Boolean = false;
		private function goPage(e:MouseEvent) {
			pageID = int(this.page_txt.text);
			if(searchStr!=""&&searchStr!=null){
				cleanBox();
				if(senKey){
					gateway.call("house.GetDataByKeyword", responderN, searchStr, pageID, pageSize);
				}else {
					gateway.call("house.GetProductListByTypeID", responderN, searchStr, pageID, pageSize);
				}
				newPageNum = pageID;
				oldId = String(searchStr);
				this.inputT.text = "搜索";
			}
		}
		private function isInit(e:FocusEvent) {
			this.inputT.removeEventListener(FocusEvent.FOCUS_IN, isInit);
			this.inputT.addEventListener(FocusEvent.FOCUS_OUT, isOutit);
			searchStr = this.inputT.text;
			//trace(searchStr)
			if (searchStr == "搜索" ) {
				this.inputT.text = "";
			}
		}
		private function isOutit(e:FocusEvent) {
			searchStr = this.inputT.text;
			if (searchStr == "" || searchStr == null) {
				this.inputT.text = "搜索";
			}
			this.inputT.addEventListener(FocusEvent.FOCUS_IN, isInit);
			this.inputT.removeEventListener(FocusEvent.FOCUS_OUT, isOutit);
		}
		private function gotype1(e:MouseEvent) {
			cleanBox();
			gateway.call("house.GetProductListByTypeID", responderN, 1, 1, pageSize);
			newPageNum = 1;
			oldIsType = true;
			oldId = "1";
			this.inputT.text = "搜索";
		}
		private function gotype2(e:MouseEvent) {
			cleanBox();
			gateway.call("house.GetProductListByTypeID", responderN, 2, 1, pageSize);
			newPageNum = 1;
			oldIsType = true;
			oldId = "2";
			this.inputT.text = "搜索";
		}
		private function gotype3(e:MouseEvent) {
			cleanBox();
			gateway.call("house.GetProductListByTypeID", responderN, 3, 1, pageSize);
			newPageNum = 1;
			oldIsType = true;
			oldId = "3";
			this.inputT.text = "搜索";
		}
		private function gotype4(e:MouseEvent) {
			cleanBox();
			gateway.call("house.GetProductListByTypeID", responderN, 4, 1, pageSize);
			newPageNum = 1;
			oldIsType = true;
			oldId = "4";
			this.inputT.text = "搜索";
		}
		private function gotype5(e:MouseEvent) {
			cleanBox();
			gateway.call("house.GetProductListByTypeID", responderN, 5, 1, pageSize);
			newPageNum = 1;
			oldIsType = true;
			oldId = "5";
			this.inputT.text = "搜索";
		}
	}
}

