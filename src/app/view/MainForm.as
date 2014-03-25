package app.view
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.Timer;
	import mdm.*;
	import app.utils.*;
	import flash.external.ExternalInterface;
	

	//调整脚本分为3部分，顺次启动部分、窗体间通信部分、MainForm与3d引擎通信部分
	dynamic public class MainForm extends MovieClip{
		public var exit_btn:SimpleButton;
		public var caption_txt:TextField;
		public var option_btn:SimpleButton;
		public var log_txt:TextField;
		public var drag_mc:MovieClip;
		public var inputT:TextField;
		public var sendBar:MovieClip;
		private var retryInt:int;//重试次数
		private var isFirstLogin:Boolean = true;//是否第一次登陆
		private var hasXuan:Boolean = false;//是否已经有炫文件
		public var mainForm_lc:LocalConnection= new LocalConnection();
		public var mainEngine_lc:LocalConnection= new LocalConnection();
		public var formArray:Array= new Array("TopPanel", "ProductBox", "HelpBox", "StoreHouseBox", "DecorateBox", "NakedHouseBox", "ToolsBox", "GuideBox","LoginBox","OptionBox");
		public var visibleForm:Array= new Array("TopPanel", "ProductBox", "GuideBox", "ToolsBox");
		public var totalMsgCount:int=1;
		public var callFunc:String = "callMe";
		private var configXml:XML;
		private var serURL:String;

		public function MainForm(){
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		private function addToStage(e){
			stage.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			stage.align = "TL";
			stage.scaleMode = "noScale";
			mainForm_lc.addEventListener(StatusEvent.STATUS, onMainFormConnectionStatus);
			exit_btn.addEventListener(MouseEvent.CLICK, onExit);
			option_btn.addEventListener(MouseEvent.CLICK, openOptionBox);
			Application.init(this, onInit);
			sendBar.sendBtn.addEventListener(MouseEvent.CLICK, sendMsgMainForm);
			flash.external.ExternalInterface.addCallback("testCallBack", testFunctionForCallback);
		}
		
		private  function loadConfig() {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, configIsLoad);
			try {
				urlLoader.load(new URLRequest(Application.path+"config.xml"));
			}catch (err:Error) {
				log_txt.appendText("xml loaderr");
			}
		}
		private function configIsLoad(e:Event) {
			configXml = new XML(e.target.data);
			serURL = configXml.data.ServerURL;
			setSerForAll(serURL);
			showLoginBox();
		}
		function openOptionBox(e){
			Forms.getFormByName("OptionBox").show();
		}
		private function testFunctionForCallback(value:String) {
			logMsg(value);
		}

		private function onInit(){
			try
			{
				Application.bringToFront();
				Application.onAppRestore = this.onAppRestore;
				Menu.Tray.insertItem("显示百宝箱");
				Menu.Tray.insertDivider();
				Menu.Tray.menuType = "function";
				Menu.Tray.insertItem("访问72炫网站");
				Menu.Tray.insertItem("启动72炫4D软件");
				Menu.Tray.itemEnabled("启动72炫4D软件", false);
				Menu.Tray.insertDivider();
				Menu.Tray.insertItem("退出");
				Menu.Tray.menuType = "function";
				Menu.Tray.onTrayMenuClick_退出 = closeApplication;
				Menu.Tray.onTrayMenuClick_访问72炫网站 = visitWebsite;
				Menu.Tray.onTrayMenuClick_启动72炫4D软件 = run3DEngine;
				logMsg(String(Application.getFormNames()));
				connectComponents();
				initEngineConnect();
				var splashPath:String = Application.path + "Splash.swf";
				Application.createForm("SplashBox", "transparent", splashPath, 200, 300, 700, 400);
				Forms.getFormByName("SplashBox").x = (System.screenWidth - 600) / 2;
				Forms.getFormByName("SplashBox").y = (System.screenHeight - 400) / 2;
				Forms.getFormByName("MainForm").dndEnable();
				drag_mc.addEventListener(MouseEvent.MOUSE_OVER, hitterdownHandle);
				drag_mc.addEventListener(MouseEvent.MOUSE_OUT, hitterupHandle);
			}
			catch (e)
			{
				logMsg("init error!");
			}
		}
		//接收Splash.swf播放完成
		public function showMainFrom(param1:String){
			logMsg("showMainFrom");
			//Forms.getFormByName("MainForm").show();
			Forms.getFormByName("MainForm").width=380;
			Forms.getFormByName("MainForm").height=430;
			Forms.getFormByName("MainForm").x=-1000;
			Forms.getFormByName("MainForm").y=-1000;
			Forms.getFormByName("SplashBox").close();
			firstLogin();

			//mdm.Forms.getFormByName("MainForm").show();
			//var processID:Number = mdm.Process.create("3DEngine",0,0,500,600,"","72Xuan.exe","\\",3,4);
			//logMsg("Run 72Xuan4D now,please wait...");
		}
		//启动登录框
		private function firstLogin() {
			loadConfig();
			
			
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//窗体间的交互
		public function onMainFormConnectionStatus(event:StatusEvent){
			mainForm_lc.removeEventListener(StatusEvent.STATUS, onMainFormConnectionStatus);
		}
		public function connectComponents(){
			try
			{
				mainForm_lc.connect("_MainFormConnection");
				mainForm_lc.client = this;
			}
			catch (e)
			{
				logMsg("Main application connect error,try again!");
				mainForm_lc.addEventListener(StatusEvent.STATUS, OnSplashStatus);
				mainForm_lc.send("_MainFormConnection", "a");
			}
			logMsg("Main application connect success!");
		}
		//通用通信函数 发送函数
		public function locConnection(nameCon:String,nameFun:String,value:String){
			mainForm_lc.send(nameCon,nameFun,value);
		}
		//mainForm_lc.addEventListener(StatusEvent.STATUS,OnSplashStatus);

		public function OnSplashStatus(param1){
			mainForm_lc.removeEventListener(StatusEvent.STATUS, OnSplashStatus);
			connectComponents();
		}
		public function getFormOrder(message:String) {
			switch(message) {
				case "NewXuan": {
					Forms.getFormByName("GuideBox").show();
					logMsg("NewXuan");
					break;
				}
				case "OpenXuan": {
					logMsg("OpenXuan");
					sendMsg("UI_MSG_102");
				}
			}
		}
		public function sendSerStr(nameCon:String, nameFun:String) {
			logMsg(nameCon);
			mainForm_lc.send(nameCon,nameFun,serURL);
		}

		//////////////////////////////////////////////////////////////////////////////
		//以下是与LoginBox相关功能部分
		var loginBoxShow:Boolean=false;
		public function showLoginBox() {
			if (!loginBoxShow) {
				//logMsg("firstLogin"+Forms.getFormByName("LoginBox").isCreated);
				//var loginBoxPath:String="LoginBox.swf";
				//Application.createForm("LoginBox", "transparent", loginBoxPath, 200, 300, 268, 396);
				Forms.getFormByName("LoginBox").x = (System.screenWidth - 268) / 2;
				Forms.getFormByName("LoginBox").y = (System.screenHeight - 406) / 2;
				Forms.getFormByName("LoginBox").show();
				
				loginBoxShow=true;
			}
		}
		public function hideLoginBox() {
			if (loginBoxShow) {
				Forms.getFormByName("LoginBox").hide();
				loginBoxShow=false;
			}
			if (isFirstLogin) {
				Application.exit();
			}
		}
		//返回用户信息并存储进MainForm;
		var useObject:Object;
		var timer:Timer = new Timer(5000, 0);
		public function loginSuc(useObj:Object) {
			logMsg("Run 72Xuan4D now,please wait...");
			if (isFirstLogin) {
				var processID:Number = mdm.Process.create("3DEngine", 0, 0, 500, 600, "", "72Xuan.exe", "\\", 3, 4);
				isFirstLogin = false;
			}
			var itemArray:Array=DataParser.resultToArray(useObj,false);
			useObject=itemArray[0];
			mdm.Forms.getFormByName("LoginBox").hide();
			loginBoxShow=false;
			loginTopPanel(useObject.user_name);
			timer.addEventListener(TimerEvent.TIMER, timerShow);
			timer.start();
		}
		private function timerShow(e:TimerEvent) {
			timer.removeEventListener(TimerEvent.TIMER, timerShow);
			logMsg("timer:Over");
			showUI();
			timer.stop();
		}
		public function loginBoxDrag(){
			Forms.getFormByName("LoginBox").startDrag();
			//logMsg("LoginBox startDrag");
		}
		public function loginBoxStopDrag(){
			Forms.getFormByName("LoginBox").stopDrag();
			//logMsg("LoginBox stopDrag");
		}
		public function setSerForAll(val:String) {
			logMsg("login:"+val);
			locConnection("_LoginBoxConnection", "startThis", val);
			locConnection("_NakedHouseBoxConnection","startNake",val);
		}

		//////////////////////////////////
		////以下是与TopPanel相关功能部分
		//显示登录用户
		public function loginTopPanel(val:String) {
			logMsg("login:"+val);
			locConnection("TopPanelConnection","login",val);
		}
		//清除登录用户并且显示登录按钮
		public function cleanLoginTopPanel(val:String=null) {
			logMsg("unlogin"+val);
			locConnection("TopPanelConnection","unLogin",val);
		}
		public function hideUIlc(val:String=null){
			hideUI();
			sendMsg("UI_MSG_001#0");
		}

		/////////////////////////////////独立功能部分
		//

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//以下为与3d引擎交互
		private function sendMsgMainForm(e:MouseEvent) {
			var msg:String = inputT.text;
			sendMsg(msg);
			logMsg("send to Engin: " + msg);
		}
		public function sendMsg(msg:String){
			var myDLL = new mdm.DLL("bridge.dll");
			myDLL.clear();
			var paraIndex:Number=0;
			paraIndex = myDLL.addParameter("string","72xuan3DEngine");
			paraIndex = myDLL.addParameter("string",msg);
			var myReturn:* = myDLL.call("integer","sendData");
			logMsg("RUN DLL:"+myReturn);
		}

		public function exeSays(param1:String){
			logMsg("exeSays:" + param1);
			
			switch(param1){
				case "ENGINE_MSG#INIT_OK":{
					//showUI();
					//sendMsg("UI_MSG_001#1");
					break;
				}
				/*case "ENGINE_MSG#WM_SHOW_HELPUDLG":{
					Forms.getFormByName("HelpBox").show();
					//mainForm_lc.send("_HelpBoxConnection", "showBrowser");
					Forms.getFormByName("StoreHouseBox").hide();
					Forms.getFormByName("DecorateBox").hide();
					Forms.getFormByName("NakedHouseBox").hide();
					break;
				}
				case "ENGINE_MSG#SHOW_KUFANG":{
					Forms.getFormByName("HelpBox").hide();
					Forms.getFormByName("StoreHouseBox").show();
					//mainForm_lc.send("_StoreHouseBoxConnection", "showBrowser");
					Forms.getFormByName("DecorateBox").hide();
					Forms.getFormByName("NakedHouseBox").hide();
					break;
				}
				case "ENGINE_MSG#WM_SHOW_DECORATEDHOUSEDLG":{
					Forms.getFormByName("HelpBox").hide();
					Forms.getFormByName("StoreHouseBox").hide();
					Forms.getFormByName("DecorateBox").show();
					//mainForm_lc.send("_DecorateBoxConnection", "showBrowser");
					Forms.getFormByName("NakedHouseBox").hide();
					break;
				}
				case "ENGINE_MSG#WM_SHOW_NAKEDHOUSEDLG":{
					Forms.getFormByName("HelpBox").hide();
					Forms.getFormByName("StoreHouseBox").hide();
					Forms.getFormByName("DecorateBox").hide();
					Forms.getFormByName("NakedHouseBox").show();
					//mainForm_lc.send("_NakedHouseBoxConnection", "showBrowser");
					break;
				}
				case "ENGINE_MSG#SIZE_RESTORED":{
					//showUI();
					break;
				}
				case "ENGINE_MSG#SIZE_MINIMIZED":{
					hideUI();
					break;
				}
				case "ENGINE_MSG#SIZE_MAXIMIZED":{
					showUI();
					break;
				}
				case "ENGINE_MSG#SIZE_MAXSHOW":{
					showUI();
					break;
				}
				case "ENGINE_MSG#SIZE_MAXHIDE":{
					hideUI();
					break;
				}*/
				case "ENGINE_MSG_010":{
					closeApplication();
					break;
				}
				case"UI_MSG_011#0/0": {
					hideUI();
					break;
				}
				default:{
					break;
				}
			}
			var str :String = param1.slice(0, 14);
			if (str == "ENGINE_MSG_009") {
				showUI();
			}
		}
		public function minApp(){

		}

		public function callHelpBox(param1){
			/*mainForm_lc.send("HelpBoxConnection", "callMe", param1);
			mainForm_lc.send("ProductBoxConnection", "callMe", param1);
			mainForm_lc.send("StoreHouseBoxConnection", "callMe", param1);
			mainForm_lc.send("NakedHouseBoxConnection", "callMe", param1);*/
		}

		public function showBox(formName:String){
			Forms.getFormByName(formName).show();

		}

		public function splashIsOver(value:String = null){
			logMsg("splashIsOver");
			Forms.getFormByName("SplashBox").close();
		}

		public function showSystemOptionBox(){

		}

		public function onStatus(event:StatusEvent){
			mainEngine_lc.removeEventListener(StatusEvent.STATUS, onStatus);

		}

		public function initEngineConnect(){
			try{
				logMsg("Try to connect main engine!");
				mainEngine_lc.connect("fromExe");
				mainEngine_lc.client = this;
			}
			catch (e){
				logMsg("Connect error,try again!");
				mainEngine_lc.addEventListener(StatusEvent.STATUS, OnMainEngineConnectionStatus);
				mainEngine_lc.send("fromExe", "a");
			}
			logMsg("MainEngine connnection success！");
		}

		public function OnMainEngineConnectionStatus(event:StatusEvent){
			mainEngine_lc.removeEventListener(StatusEvent.STATUS, OnMainEngineConnectionStatus);
			initEngineConnect();
		}
		var UIVisible:Boolean = false;
		public function hideUI() {
			if(UIVisible){
			visibleForm=new Array();
			for(var i=0;i<formArray.length;i++){
				var formName:String = formArray[i];
				if(mdm.Forms.getFormByName(formName).visible)
				{
					visibleForm.push(formName);
					mdm.Forms.getFormByName(formName).hide();
				}
			}
			//Forms.getFormByName("MainForm").width=0;
			Forms.getFormByName("MainForm").x = -1000;
			Forms.getFormByName("MainForm").y = -1000;
			UIVisible = false;
			}
		}

		public function showUI() {
			if(!UIVisible){
			//mainForm_lc.send("_ProductBoxConnection","showBrowser");
			Application.bringToFront();
			for(var i=0;i<visibleForm.length;i++){
				var formName:String = visibleForm[i];
				logMsg("ShowUI:"+formName);
				mdm.Forms.getFormByName(formName).show();
			}
			//Forms.getFormByName("MainForm").show();
			//Forms.getFormByName("MainForm").hide();
			UIVisible = true;
			}
		}

		public function closeApplication() : void{
			try{
				mainForm_lc.close();
				Application.exit();
			}
			catch (e){
				Application.exit();
			}
		}

		public function onAppExit() : void{
			mainForm_lc.close();
		}
		var firstRestore:Boolean = true;

		public function onAppRestore() : void{
			if (isFirstLogin) {
			}else{
				if (!firstRestore) {
					showUI();
					//logMsg("Application has been restored");
					sendMsg("UI_MSG_001#1");

				}
				firstRestore = false;
				//Forms.getFormByName("MainForm").show();
			}
		}

		public function run3DEngine() : void{

		}

		public function visitWebsite() : void{
			var url:String= "http://www.72xuan.com";
			var urlRequest:URLRequest=new URLRequest(url);
			var mode:String="_blank";
			navigateToURL(urlRequest,mode);
		}

		public function onOption(param1){
			try{
				//mdm.Forms.getFormByName("HelpBox").callFunction("showImage", "param1|param2", "|");
				//callHelpBox("abcd");
				//var splashPath:String = mdm.Application.path+"OptionBox2.swf";
				//logMsg(splashPath);
				//mdm.Application.createForm("OptionBox-2", "noborder", splashPath, 200, 300, 700, 400);
				//mdm.Forms.getFormByName("OptionBox-2").x = (mdm.System.screenWidth-600)/2;
				//logMsg("2");
				//mdm.Forms.getFormByName("OptionBox-2").y = (mdm.System.screenHeight-400)/2;
				//logMsg("3");
			}catch(e){
				logMsg("onOption error!");
			}
		}

		public function onExit(param1){
			Forms.getFormByName("MainForm").hide();

		}

		public function hitterupHandle(event:MouseEvent) : void{
			try{
				mdm.Forms.getFormByName("MainForm").stopDrag();
			}catch(e){
				trace(e.message);
			}
		}

		public function hitterdownHandle(event:MouseEvent) : void{
			try{
				mdm.Forms.getFormByName("MainForm").stopDrag();
			}catch(e){
				trace(e.message);
			}
		}

		public function callMe(value){
			logMsg("callMe:" + value);
		}

		public function logMsg(value:String){
			log_txt.text = String(totalMsgCount++) + ":" + value + "\n" + log_txt.text;
		}
	}
}

