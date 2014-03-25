package app.view
{
	/**
	 * ...
	 * @author No21sec_dead
	 */
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import mdm.*;
	import com.greensock.TweenLite;

	dynamic public class TopPanel extends MovieClip
	{
		public var menu_mc:MovieClip;
		public var bg_mc:MovieClip;
		public var lc:LocalConnection;
		public var lc_name:String;

		public var exit_btn:SimpleButton;
		public var min_btn:SimpleButton;
		public var option_btn:SimpleButton;
		public var tips_txt:TextField;
		public var parentMC:MovieClip;

		public var btn_mc:MovieClip;
		private var file:FileReference;

		public function TopPanel(){
			this.addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}
		private function addToStage(e){
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			lc = new LocalConnection();
			lc.addEventListener(StatusEvent.STATUS, onStatus);
			lc_name = "TopPanelConnection";
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = "TL";
			menu_mc.tips_txt.addEventListener(TextEvent.LINK, linkHandler);
			menu_mc.exit_btn.addEventListener(MouseEvent.CLICK, onExit);
			menu_mc.min_btn.addEventListener(MouseEvent.CLICK, onMin);
			menu_mc.option_btn.addEventListener(MouseEvent.CLICK, openOptionBox);
			parentMC = MovieClip(this.parent);
			setAllBtn();
			Application.init(this, onInit);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, theKeyDown);
			file = new FileReference();
		}

		function openOptionBox(e){
			//Forms.getFormByName("OptionBox").show();
			if (isShowMainForm) {
				//menu_mc.tips_txt.htmlText = String(Forms.getFormByName("MainForm").visible);
				Forms.getFormByName("MainForm").x = -1000;
				Forms.getFormByName("MainForm").y = -1000;
				//Forms.getFormByName("MainForm").hide();
				isShowMainForm = false;
			}else {
				//Forms.getFormByName("MainForm").show();
				//Forms.getFormByName("MainForm").width=380;
				//Forms.getFormByName("MainForm").height=430;
				Forms.getFormByName("MainForm").x=mdm.System.screenWidth-mdm.Forms.getFormByName("MainForm").width;
				Forms.getFormByName("MainForm").y=mdm.Forms.getFormByName("TopPanel").height;
				isShowMainForm = true;
			}
		}
		public function callMainForm(param1 = null){
			lc.send("_MainFormConnection", "showSystemOptionBox");
		}

		public function callMainUseF(param1 = null){
			lc.send("_MainFormConnection", "showSystemOptionBox");
		}

		public function callMainLoginForm(param1 = null){
			lc.send("_MainFormConnection", "showLoginBox");
		}

		public function callMainCleanLogin(param1 = null){
			lc.send("_MainFormConnection", "cleanLoginTopPanel");
		}

		public function onStatus(event:StatusEvent){
			lc.removeEventListener(StatusEvent.STATUS, onStatus);
		}

		public function connect(){
			try{
				lc.connect(lc_name);
				lc.client = this;
			}catch (e){
				log("Connect " + lc_name + " error!");
			}log("Connect success!");
		}

		public function onInit(){
			var appPath:String;
			try{
				Application.bringToFront();
				appPath = Application.path;
				Forms.getFormByName("TopPanel").width = System.screenWidth;
				Forms.getFormByName("TopPanel").height = 78;
				menu_mc.x = System.screenWidth - menu_mc.width - 10;

				//var functionName:String = "testCallBack";
				//mdm.Forms.getFormByName("MainForm").callFunction(functionName, "callbackokcy","");
				connect();
			}catch (e){
				connect();
				trace("init error！");
			}
		}
		var isShowMainForm:Boolean = true;

		private function theKeyDown(e:KeyboardEvent) {
			if (e.ctrlKey) {
				if (e.altKey) {
					if (e.charCode == 71) {
						if (isShowMainForm) {
							//menu_mc.tips_txt.htmlText = String(Forms.getFormByName("MainForm").visible);
							Forms.getFormByName("MainForm").x = -1000;
							Forms.getFormByName("MainForm").y = -1000;
							//Forms.getFormByName("MainForm").hide();
							isShowMainForm = false;
						}else {
							//Forms.getFormByName("MainForm").show();
							//Forms.getFormByName("MainForm").width=380;
							//Forms.getFormByName("MainForm").height=430;
							Forms.getFormByName("MainForm").x=mdm.System.screenWidth-mdm.Forms.getFormByName("MainForm").width;
							Forms.getFormByName("MainForm").y=mdm.Forms.getFormByName("TopPanel").height;
							isShowMainForm = true;
						}
					}
				}
			}
		}

		public function sendMsg(param1:String){
			var _loc_2:* = new DLL("bridge.dll");
			_loc_2.clear();
			var _loc_3:Number = 0;
			_loc_3 = _loc_2.addParameter("string", "72xuan3DEngine");
			_loc_3 = _loc_2.addParameter("string", param1);
			var _loc_4:* = _loc_2.call("integer", "sendData");
		}

		public function login(param1:String){
			menu_mc.tips_txt.htmlText = "<font color=\'#FF9900\'><b><a href=\"event:os\">" + param1 + "</a></b></font>" + ",欢迎您使用72Xuan测试版软件    " + "<font color=\'#FF9900\'><b><a href=\"event:cl\">注销</a></b></font>";
		}

		public function unLogin(param1:String){
			trace("get unlogin");
			menu_mc.tips_txt.htmlText = "您好,欢迎您使用72Xuan测试版软件    " + "<font color=\'#FF9900\'><b><a href=\"event:log\">登录</a></b></font>";
		}

		public function linkHandler(event:TextEvent){
			if (event.text == "log"){
				callMainLoginForm("");
			}else if (event.text == "cl"){
				callMainCleanLogin();
			}
		}
		public function log(param1:String){
			trace(param1);
		}

		public function onExit(param1){
			Application.exit();
		}

		public function onMin(param1){
			//lc.send("_MainFormConnection", "hideUIlc");
			sendMsg("UI_MSG_001#0");
		}

		public function onOption(param1){
			//Forms.getFormByName("OptionBox").show();
		}

		///////设置并显示按钮
		private var btnTypeNew:int = 1;

		private function setAllBtn() {
			var btnNum:int = 0;
			for (var i = 1; i <=6; i++) {
				if (i==1) {
					btnNum = 9;
				}else if(i ==2) {
					btnNum = 6;
				}else if(i ==3) {
					btnNum = 8;
				}else if(i ==4) {
					btnNum = 4;
				}else if(i == 5) {
					btnNum = 3;
				}else if(i == 6) {
					btnNum = 4;
				}

				for (var j = 1; j <= btnNum; j++ ) {
					var target:MovieClip = btn_mc.getChildByName("btn" + i+"_"+j) as MovieClip;
					target.addEventListener(MouseEvent.CLICK, setFunction);
				}

			}
			btn_mc.btn1.addEventListener(MouseEvent.CLICK, btnInNum);
			btn_mc.btn2.addEventListener(MouseEvent.CLICK, btnInNum);
			btn_mc.btn3.addEventListener(MouseEvent.CLICK, btnInNum);
			btn_mc.btn4.addEventListener(MouseEvent.CLICK, btnInNum);
			btn_mc.btn5.addEventListener(MouseEvent.CLICK, btnInNum);
			btn_mc.btn6.addEventListener(MouseEvent.CLICK, btnInNum);

		}
		var currentModeID:int = 1;
		var messageForMain:String;
		function setFunction(e:MouseEvent) {
			//trace(e.currentTarget.name)
			switch(e.currentTarget.name) {
				case "btn1_1": {
					Forms.getFormByName("GuideBox").show();
					break;
				}
				case "btn1_3": {
					break;
				}
				case "btn1_5": {
					file.browse();
					file.addEventListener(Event.SELECT, isSel);
					break;
				}
				case "btn1_6": {
					//Application.exit();
					break;
				}
				case "btn1_8": {
					sendMsg("UI_MSG_108");
					break;
				}
				case "btn1_9": {
					Application.exit();
					break;
				}
				case "btn2_1": {
					sendMsg("UI_MSG_201");
					break;
				}
				case "btn2_2": {
					sendMsg("UI_MSG_202");
					break;
				}
				case "btn3_2": {
					sendMsg("UI_MSG_302");
					break;
				}
				case "btn3_3": {
					sendMsg("UI_MSG_303");
					break;
				}
				case "btn3_4": {
					sendMsg("UI_MSG_304");
					break;
				}
				case "btn3_5": {
					sendMsg("UI_MSG_305");
					break;
				}case "btn4_1": {
					//视角切换
					sendMsg("UI_MSG_401#"+currentModeID);
					currentModeID++;
					if(currentModeID>3)
					{
						currentModeID=1;
					}
					break;
				}case "btn4_2": {
					sendMsg("UI_MSG_401#1");
					break;
				}case "btn4_3": {
					sendMsg("UI_MSG_401#2");
					break;
				}case "btn4_4": {
					sendMsg("UI_MSG_401#3");
					break;
				}case "btn6_1": {
					Forms.getFormByName("HelpBox").show();
					break;
				}case "btn6_4": {
					//sendMsg("UI_MSG_401#3");
					break;
				}
			}
		}
		private function isSel(e:Event) {
			trace(e.target.name);
		}

		private function btnInNum(e:MouseEvent) {
			if (e.target.name == "btn1") {
				btnIn(1);
			}else if (e.target.name == "btn2") {
				btnIn(2);
			}else if (e.target.name == "btn3") {
				btnIn(3);
			}else if (e.target.name == "btn4") {
				btnIn(4);
			}else if (e.target.name == "btn5") {
				btnIn(5);
			}else if (e.target.name == "btn6") {
				btnIn(6);
			}
		}
		private function btnIn(num:int) {
			if (num != btnTypeNew) {
				btnOut(num);
			}else {
				if (num == 1) {
					TweenLite.to(btn_mc.btn1_1, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn1_3, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn1_5, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn1_6, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn1_8, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn1_9, .3, { y: 19 } );
				}else if (num == 2) {
					TweenLite.to(btn_mc.btn2_1, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn2_2, .3, { y: 19 } );
				}else if (num == 3) {
					TweenLite.to(btn_mc.btn3_2, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn3_3, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn3_4, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn3_5, .3, { y: 19 } );
				}else if (num == 4) {
					TweenLite.to(btn_mc.btn4_1, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn4_2, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn4_3, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn4_4, .3, { y: 19 } );
				}else if (num == 6) {
					TweenLite.to(btn_mc.btn6_1, .3, { y: 19 } );
					TweenLite.to(btn_mc.btn6_4, .3, { y: 19 } );
				}
			}
		}
		private var overId:int;
		private function btnOut(num:int) {
			if (btnTypeNew == 1) {
				TweenLite.to(btn_mc.btn1_1, .3, { y: 58,onComplete:overBtn } );
				TweenLite.to(btn_mc.btn1_3, .3, { y: 58 } );
				TweenLite.to(btn_mc.btn1_8, .3, { y: 58 } );
				TweenLite.to(btn_mc.btn1_5, .3, { y: 58 } );
				TweenLite.to(btn_mc.btn1_6, .3, { y: 58 } );
				TweenLite.to(btn_mc.btn1_9, .3, { y: 58 } );
			}else if (btnTypeNew == 2) {
				TweenLite.to(btn_mc.btn2_1, .3, { y: 58,onComplete:overBtn } );
				TweenLite.to(btn_mc.btn2_2, .3, { y: 58 } );
			}else if (btnTypeNew == 3) {
				TweenLite.to(btn_mc.btn3_2, .3, { y: 58,onComplete:overBtn } );
				TweenLite.to(btn_mc.btn3_3, .3, { y: 58 } );
				TweenLite.to(btn_mc.btn3_4, .3, { y: 58 } );
				TweenLite.to(btn_mc.btn3_5, .3, { y: 58 } );
			}else if (btnTypeNew == 4) {
				TweenLite.to(btn_mc.btn4_1, .3, { y: 58,onComplete:overBtn } );
				TweenLite.to(btn_mc.btn4_2, .3, { y: 58 } );
				TweenLite.to(btn_mc.btn4_3, .3, { y: 58 } );
				TweenLite.to(btn_mc.btn4_4, .3, { y: 58 } );
			}else if (btnTypeNew == 6) {
				TweenLite.to(btn_mc.btn6_1, .3, { y: 58,onComplete:overBtn } );
				TweenLite.to(btn_mc.btn6_4, .3, { y: 58 } );
			}
			overId = num;
			btnTypeNew = num;
		}
		private function overBtn() {
			btnIn(overId);

		}
		
		
		

	}
}

