package app.view
{
	import app.*;
	import app.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.Timer;
	import mdm.*;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	dynamic public class LoginBox extends MovieClip
	{
		//ui部分
		public var exit_btn:SimpleButton;
		public var state_text:TextField;//标题
		public var errBox:MovieClip;//登录失败提示
		public var option_btn:SimpleButton;//option_btn(附加回调功能，暂无)
		public var loginBtn:MovieClip;
		public var userMail_txt:TextField;
		public var userPwd_txt:TextField;
		public var drag_mc:MovieClip;
		public var reEmail:MovieClip;//记住邮箱

		private var saveMailB:Boolean = false;
		public var lc:LocalConnection;
		public var lc_name:String;
		public var userName:String;
		public var gateway:RemotingConnection;
		public var responderN:Responder;
		public var mainObj:Object;
		private var mySo:SharedObject;
		private var timer:Timer = new Timer(1000, 0);

		public function LoginBox(){
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		private function addToStage(e) {
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			reEmail.addEventListener(MouseEvent.CLICK, saveMail);
			lc = new LocalConnection();
			lc_name = "_LoginBoxConnection";
			lc.addEventListener(StatusEvent.STATUS, onStatus);
			connect();
			Application.init(this, onInit);
			exit_btn.addEventListener(MouseEvent.CLICK, onExit);
			userName = "";
			mySo = SharedObject.getLocal("application-name");
			if (mySo.data.savedValue!= undefined) {
				userMail_txt.text = mySo.data.savedValue;
			}else {
				userMail_txt.text = "<请输入邮箱>";
			}
			//startThis("http://192.168.1.6/72xuan/gateway.php");
			//trace("1122")
		}
		public function startThis(param1:String) {
			
			gateway = new RemotingConnection(param1);
			responderN = new Responder(onResult, onError);
			loginBtn.addEventListener(MouseEvent.CLICK, loginToURL);
			this.userMail_txt.addEventListener(FocusEvent.FOCUS_IN, isInit);
			this.userPwd_txt.addEventListener(FocusEvent.FOCUS_IN, isInitPwd);
			this.userMail_txt.addEventListener(FocusEvent.FOCUS_OUT, isOutit);
			this.userPwd_txt.addEventListener(FocusEvent.FOCUS_OUT, isOutitPwd);
			timer.addEventListener(TimerEvent.TIMER, hideLoadMc);
			//option_btn.addEventListener(MouseEvent.CLICK,openOptionBox);
			
			getSaveState();
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyIsDown);
		}
		private function openOptionBox(e){
			Forms.getFormByName("OptionBox").show();
		}
		private function keyIsDown(e:KeyboardEvent) {
			if (e.keyCode == 13) {
			var msEvent:MouseEvent = new MouseEvent(MouseEvent.CLICK);
			loginToURL(msEvent);
			}
		}
		private function cleanEmail(e:MouseEvent) {
			delete mySo.data.savedValue;
		}
		public function onStatus(event:StatusEvent){
			lc.removeEventListener(StatusEvent.STATUS, onStatus);
		}
		private function getSaveState() {
			if (mySo.data.saveMailS == "true") {
				reEmail.gotoAndStop(2);
				saveMailB = true;
			}else if (mySo.data.saveMailS == "false") {
				reEmail.gotoAndStop(1);
				saveMailB = false;
			}
		}
		private function saveMail(e:MouseEvent) {
			if (reEmail.currentFrame == 1) {
				reEmail.gotoAndStop(2);
				saveMailB = true;
				mySo.data.saveMailS = "true";
			}else if (reEmail.currentFrame == 2) {
				reEmail.gotoAndStop(1);
				saveMailB = false;
				mySo.data.saveMailS = "false";
			}
		}

		public function connect(){
			try{
				lc.connect(lc_name);
				lc.client = this;
			}catch (e){
			}
		}

		public function callMe(param1){
			if (param1 == "showBrowser"){
			}
		}

		public function onInit(){
			try {
				drag_mc.addEventListener(MouseEvent.MOUSE_OVER, hitterdownHandle);
				drag_mc.addEventListener(MouseEvent.MOUSE_OUT, hitterupHandle);
				//state_text.text=String(Forms.getFormByName("MainForm").isCreated);
			}catch (e){
				//state_text.text = "is error";
				trace(1);
			}
		}

		public function hitterupHandle(event:MouseEvent) : void{
			Forms.getFormByName("LoginBox").startDrag();
		}

		public function hitterdownHandle(event:MouseEvent) : void{
			Forms.getFormByName("LoginBox").startDrag();
		}

		public function callMainForm(){
			try {
				if(!saveMailB){
					delete mySo.data.savedValue;
					userMail_txt.text = "<请输入邮箱>";
				}else {
					mySo.data.savedValue = userMail_txt.text;
					var flushStatus:String = null;
					try {
						flushStatus = mySo.flush(10000);
					} catch (error:Error) {
					}
					if (flushStatus != null) {
						switch (flushStatus) {
							case SharedObjectFlushStatus.PENDING:
								mySo.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
							break;
							case SharedObjectFlushStatus.FLUSHED:
							break;
						}
					}
				}
				lc.send("_MainFormConnection", "loginSuc", mainObj);
				lc.addEventListener(StatusEvent.STATUS, OnMainEngineConnectionStatus);
			}catch (e){
				trace(1);
			}
		}

		public function OnMainEngineConnectionStatus(param1){
			trace("OnMainEngineConnectionStatus");
			//state_text.text = "is Err";
			lc.removeEventListener(StatusEvent.STATUS, OnMainEngineConnectionStatus);
		}

		public function onExit(param1){
			lc.send("_MainFormConnection", "hideLoginBox");
			lc.addEventListener(StatusEvent.STATUS, OnMainEngineConnectionStatus);
		}

		public function loginToURL(event:MouseEvent) {
			if (userMail_txt.text == "111") {
				lc.send("_MainFormConnection", "loginSuc", mainObj);
			}else{

				gateway.call("user.login", responderN, userMail_txt.text, userPwd_txt.text);
			}
			loginBtn.login_txt.gotoAndStop(2);
		}
		private function onFlushStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "SharedObject.Flush.Success":
				break;
				case "SharedObject.Flush.Failed":
				break;
			}
			mySo.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
		}
        private var timerErr:Boolean = true;
		public function onResult(result:Object) : void {
			
			var itemArray:Array;
			try {
				
				mainObj = result;
				itemArray = DataParser.resultToArray(result, false);
				if (itemArray.length == 0) {
					timerErr = false;
					errBox.gotoAndPlay(1);
					stTimer();
					return;
				}
				timerErr = true;
				userName = itemArray[0].user_name;
				stTimer();
			}catch (e) {
				
				timerErr = false;
				errBox.gotoAndPlay(1);
				stTimer();
			}
			
		}

		public function onError(param1:Object) {
			timerErr = false;
			stTimer();
			errBox.gotoAndPlay(1);
			
		}
		
		private function stTimer() {
			
			//timer.stop();
			timer.reset();
			timer.start();
		}
		private function hideLoadMc(e:TimerEvent) {
			trace(timerErr)
			loginBtn.login_txt.gotoAndStop(1);
			if(timerErr){
			  callMainForm();
			}
			timer.stop();
		}

		public function isInit(event:FocusEvent){
			if (errBox.currentFrame != 1){
				errBox.gotoAndPlay(11);
			}if (userMail_txt.text == "<请输入邮箱>"){
				userMail_txt.text = "";
			}
		}

		public function isInitPwd(event:FocusEvent){
			if (errBox.currentFrame != 1){
				errBox.gotoAndPlay(11);
			}if (userPwd_txt.text == "<请输入密码>"){
				userPwd_txt.text = "";
			}
		}

		public function isOutit(event:FocusEvent){
			if (errBox.currentFrame != 1){
				errBox.gotoAndPlay(11);
			}if (userMail_txt.text == ""){
				userMail_txt.text = "<请输入邮箱>";
			}
		}

		public function isOutitPwd(event:FocusEvent){
			if (errBox.currentFrame != 1){
				errBox.gotoAndPlay(11);
			}if (userPwd_txt.text == ""){
				userPwd_txt.text = "<请输入密码>";
			}
		}

	}
}

