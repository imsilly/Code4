package  {
	import alternativa.engine3d.core.events.MouseEvent3D;
	import app.RemotingConnection;
	import app.utils.DataParser;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	import flash.utils.Dictionary;
	import xuanju.core.Engine3D;
	import xuanju.utils.Log;
	
	public class MainUI extends MovieClip {
		public var gateway:RemotingConnection;
		public var responderN:Responder;
		private var serverURL:String = "http://192.168.1.133/72xuan/gateway.php";
		private var mainXml:XML;
		private var isFirst:Boolean = true;//是否是第一次打开
		private var CPwinListArr:Array = new Array();
		private var smallPath:String;
		private var f3dPath:String;
		private var engine3D:Engine3D;
		private var modelReplaceList:Array;
		/////////////////////////UI部分初始////////////////////////
		public var changeBtnF:MovieClip;
		public var mainMune:MovieClip;
		public var roomListBtn:MovieClip;
		public var productListBtn:MovieClip; 
		public var mainMuneMask:Sprite;
		
		private var cpWinShowX:Number = 143;
		private var cpWinHideX:Number = -15;
		public var changeListMain:MovieClip;
		public var changeListMask:Sprite;
		private var CPwinListBtnList:Array = new Array();
		
		private var engDefaultX:Number = 143;
		private var roomWinShowX:Number = 143;
		private var roomWinHideX:Number = -130;
		public var roomListMain:MovieClip;
		public var roomListMask:MovieClip;
		private var  roomwinListBtnList:Array = new Array();
		
		private var cursorData:MouseCursorData;//自定义鼠标
		private var urlloaderF3d:URLLoader;
		private var roomIDNew:int = 0;
		
		private var mainState:String = "normal";//"cpWin" "roomListWin" "proListWin" 四种状态 普通、产品对比、房间列表、产品列表
		private var infoState:Boolean = false;//是否开启产品详情
		public function MainUI() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			addEventListener(Event.ADDED_TO_STAGE, inStage);
		}
		private function inStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, inStage);
			setBaseMc();
			loadBase();
		}
		//初始化mc
		private function setBaseMc():void 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);//调试窗口
			Log.isLog = false;//关闭调试信息
			log_mc.visible = false;
			mainCon.visible = false;
			roomListBtn = mainMune.roomListBtn as MovieClip;
			productListBtn = mainMune.productListBtn as MovieClip;
			//鼠标设置
			cursorData = new MouseCursorData();
			cursorData.hotSpot = new Point(20,25);
			var bitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>(1, true);
			var myBitmapData:BitmapData = new BitmapData(32, 32,true,0);
			myBitmapData.draw(mouseUI);
			bitmapDatas[0] = myBitmapData;
			cursorData.data = bitmapDatas;
			Mouse.registerCursor("myCursor", cursorData);
		}
		
		//载入基本数据
		private function loadBase():void {
			gateway = new RemotingConnection(serverURL);
			responderN = new Responder(onResult, onError);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
			urlLoader.load(new URLRequest("HouseData.xml"));
		}
		private function xmlLoaded(e:Event):void {
			mainXml = new XML(e.target.data);
			smallPath = mainXml.HouseInfo.SmallImagesPath;
			f3dPath = mainXml.HouseInfo.F3DPath;
			
			engine3D = new Engine3D(eng3dBoxforEng, stage.stageWidth, stage.stageHeight, 0, false);
			engine3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			engine3D.dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
		}
		
		private function onContextCreate(e:Event):void {
			engine3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			engine3D.startRendering();
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
			engine3D.addEventListener("XMLParseCompleted", xmlParseCompleted);
			engine3D.addEventListener(ProgressEvent.PROGRESS, houseProgress);
			engine3D.addEventListener("houseLoaded", houLoaded);
			
			
			engine3D.start(mainXml);
			roomIDNew = int(mainXml.HouseInfo.DefaultRoomID);
			engine3D.initRoom( roomIDNew);
			engine3D.showObjectInfo = false;
			engine3D.addEventListener("rollOverModel", overProMouse);
			engine3D.addEventListener("rollOutModel", outProMouse);
		}
		
		private var totByteNum:Number = 1000;
		private var newByteNum:Number=0;
		private function houLoaded(e:Event):void 
		{
			this.dispatchEvent(new ProgressEvent("progress", false, false, 400, totByteNum));
			engine3D.removeEventListener("progress", houseProgress);
			engine3D.removeEventListener("houseLoaded", houLoaded);
			engine3D.addEventListener("texturesLoaded", getMeshNum);
		}
		private function houseProgress(e:ProgressEvent):void 
		{
			var byteNum:Number = e.bytesLoaded / e.bytesTotal * 200;
			this.dispatchEvent(new ProgressEvent("progress", false, false, byteNum, totByteNum));
		}
		private function getMeshNum(e:Event):void 
		{
			var byteNum:Number = engine3D.numLoadedModel / 10 * 600+400;
			if ( engine3D.numLoadedModel == 10) {
				engine3D.removeEventListener("texturesLoaded", getMeshNum);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}else {
				this.dispatchEvent(new ProgressEvent("progress", false, false, byteNum, totByteNum));
			}
		}
		private function xmlParseCompleted(e:Event):void {
			setBaseBtn();
			mainMune.mask = mainMuneMask;
			changeListMain.mask = changeListMask;
			proInfoWinMain.mask = changeListMask2;
			loadOver();
		}
		private function onEngineModelDown(e:MouseEvent3D):void{
			modelReplaceList = engine3D.modelReplaceList;
		}
		private function xmlLoadError(e:IOErrorEvent):void{
			trace(e);
		}
		private function setBaseBtn() {
			engine3D.addEventListener("ChangeProduct", setChangeProduct);
			engine3D.addEventListener("unSelectProduct", removeChangeProduct);
			roomListBtn.addEventListener(MouseEvent.CLICK, setRoom);
			productListBtn.addEventListener(MouseEvent.CLICK, setProduct);
			changeListMain.addEventListener(MouseEvent.ROLL_OVER, outCPBar);
			changeListMain.addEventListener(MouseEvent.ROLL_OUT, backCPBar);
			changeListMain.CPwinBar.barBtn.addEventListener(MouseEvent.MOUSE_DOWN, stCPBarDrag);
			changeListMain.cpCloseBtn.addEventListener(MouseEvent.CLICK, closeCpwin_M);
			proInfoWinMain.cpCloseBtn.addEventListener(MouseEvent.CLICK, closeCpProwin_M);
			proInfoWinMain.changeInfoBtn.addEventListener(MouseEvent.CLICK, changeProductinInfo);
			
			//roomListMain
			roomListMain.addEventListener(MouseEvent.ROLL_OVER, outCPBar);
			roomListMain.addEventListener(MouseEvent.ROLL_OUT, backCPBar);
			roomListMain.CPwinBar.barBtn.addEventListener(MouseEvent.MOUSE_DOWN, stroomBarDrag);
			roomListMain.cpCloseBtn.addEventListener(MouseEvent.CLICK, closeroomwin_M);
		}
		private var stMouseY:Number;
		private var barStY:Number;
		private var autobackBar:Boolean=true;
		private function stCPBarDrag(e:MouseEvent):void 
		{
			barStY = changeListMain.CPwinBar.barBtn.y;
			autobackBar = false;
			stMouseY = e.stageY;
			changeListMain.CPwinBar.barBtn.removeEventListener(MouseEvent.MOUSE_DOWN, stCPBarDrag);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveCPBar);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopCPBarDrag);
		}
		
		private function stopCPBarDrag(e:MouseEvent):void 
		{
			autobackBar = true;
			changeListMain.CPwinBar.barBtn.addEventListener(MouseEvent.MOUSE_DOWN, stCPBarDrag);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveCPBar);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopCPBarDrag);
		}
		private function moveCPBar(e:MouseEvent) {
			var mc_Y:Number = barStY + (e.stageY - stMouseY);
			if (mc_Y < 0) {
				mc_Y = 0;
			}else if(mc_Y>(stage.stageHeight-changeListMain.CPwinBar.barBtn.height)) {
				mc_Y = stage.stageHeight - changeListMain.CPwinBar.barBtn.height;
			}
			TweenLite.to(changeListMain.CPwinBar.barBtn, 0.5, { y:mc_Y } );
			TweenLite.to(changeListMain.btnBox, 0.5, { y:-mc_Y / (stage.stageHeight - changeListMain.CPwinBar.barBtn.height) * (changeListMain.btnBox.height - stage.stageHeight) } );
		}
		private function backCPBar(e:MouseEvent):void 
		{
			if(autobackBar){
				TweenLite.to(targetMC.CPwinBar, 0.5, { x:targetMC.btnBox.width-20 } );
			}
		}
		private var targetMC:MovieClip;
		private function outCPBar(e:MouseEvent):void 
		{
			
			targetMC = e.currentTarget as MovieClip;
			if (targetMC.btnBox.height < stage.stageHeight) {
				targetMC.CPwinBar.visible = false;
			}else {
				targetMC.CPwinBar.visible = true;
			}
			TweenLite.to(targetMC.CPwinBar, 0.5, { x:targetMC.btnBox.width-4 } );
		}
		
		private function closeCpwin_M(e:MouseEvent):void {
			closedCPwin();
		}
		private function simpChangeProduct(e:MouseEvent):void {
			engine3D.dispatchEvent(new Event("ChangeProduct"));
		}
		private function closeWinAndActive():void 
		{
			if (mainState == "cpWin") {
				TweenLite.to(changeListMain, 0.3, { x:cpWinHideX, onComplete:closeActive } );
				TweenLite.to(eng3dBoxforEng, 0.3, { x: engDefaultX } );
				TweenLite.to(proInfoWinMain, 0.3, { x: cpWinHideX-105, onComplete:closeActive } );
			}else if (mainState == "roomWin") {
				
				TweenLite.to(roomListMain, 0.3, { x:roomWinHideX, onComplete:closeActive } );
				TweenLite.to(eng3dBoxforEng, 0.3, { x:engDefaultX } );
			}else if (mainState == "cpProWin") {
				TweenLite.to(proInfoWinMain, 0.3, { x: cpWinHideX-105, onComplete:closeActive } );
			}
		}
		private function closeActive():void {
			if (mainState == "cpWin") {
				 openCPwin();
			}else if (mainState == "roomWin") {
				 openRoomwin();
			}else if (mainState == "cpProWin") {
				openCPProwin();
			}
		}
		private function removeChangeProduct(e:Event):void 
		{
			if (mainState == "cpWin") {
				TweenLite.to(changeListMain, 0.3, { x:cpWinHideX } );
				TweenLite.to(eng3dBoxforEng, 0.3, { x: engDefaultX } );
				contralBarF(true);
				TweenLite.to(proInfoWinMain, 0.3, { x: cpWinHideX-105} );
			}else if (mainState == "cpProWin") {
				TweenLite.to(changeListMain, 0.3, { x:cpWinHideX } );
				TweenLite.to(eng3dBoxforEng, 0.3, { x: engDefaultX } );
				contralBarF(true);
				TweenLite.to(proInfoWinMain, 0.3, { x: cpWinHideX-105} );
			}
		}
		//更换产品模块
		private function setChangeProduct(e:Event):void {
			TweenLite.to(changeBtnF, 0.5, { alpha:0 } );
			if (mainState == "normal") {
				openCPwin();
			}else {
				closeWinAndActive();
			}
			mainState = "cpWin";
		}
		private function openCPwin():void {
			makeCPwin();
			contralBarF(false);
			TweenLite.to(changeListMain, 0.3, { x: cpWinShowX } );
			TweenLite.to(eng3dBoxforEng, 0.3, { x:cpWinShowX / 2 + engDefaultX } );
		}
		private function makeCPwin():void 
		{
			changeListMain.CPwinBar.barBtn.y = 0;
			changeListMain.btnBox.y = 0;
			var removeLen:int = CPwinListBtnList.length;
			for (var j:int = 0; j < removeLen; j++ ) {
				changeListMain.btnBox.removeChild(CPwinListBtnList[j])
			}
			CPwinListBtnList = new Array();
			CPwinListArr = engine3D.modelReplaceList;
			var len:int = CPwinListArr.length;
			for (var i:int = 0; i < len; i++ ) {
				var picCPBtn:picBox = new picBox();
				picCPBtn.publicPath = f3dPath;
				picCPBtn.picPath = smallPath;
				picCPBtn.name = CPwinListArr[i];
				picCPBtn.y = 22 + 150 * i;
				picCPBtn.xqBtn.addEventListener(MouseEvent.CLICK, showProInfo);
				changeListMain.btnBox.addChildAt(picCPBtn, 1);
				picCPBtn.loadF3D(CPwinListArr[i]);
				picCPBtn.buttonTx.addEventListener(MouseEvent.CLICK, changeProductNew);
				CPwinListBtnList.push(picCPBtn);
			}
		}
		private var f3dName:String;
		private function showProInfo(e:MouseEvent):void 
		{
			f3dName = e.currentTarget.parent.name;
			if (mainState == "cpWin") {
				openCPProwin();
			}else if(mainState == "cpProWin") {
				closeWinAndActive();
			}
			mainState = "cpProWin";
		}
		//105
		private function openCPProwin():void {
			makeCPProwin();
			TweenLite.to(proInfoWinMain, 0.3, { x: cpWinShowX+151 } );
		}
		
		private function makeCPProwin():void 
		{
			proInfoWinMain.proName.text = "载入中";
			proInfoWinMain.ppName.text = "品牌：载入中" ;
			proInfoWinMain.ccName.text = "尺寸：载入中" ;
			proInfoWinMain.czName.text = "类型：载入中";
			proInfoWinMain.ysName.text = "颜色：载入中" ;
			proInfoWinMain.priceName.text = "载入中"  ;
			loadF3D(f3dName);
		}
		private function closeCpProwin_M(e:MouseEvent):void 
		{
			TweenLite.to(proInfoWinMain, 0.3, { x: changeListMain.x-105 } );
		}
		
		public function loadF3D(url:String) {
			urlloaderF3d = new URLLoader();
			urlloaderF3d.addEventListener(Event.COMPLETE, xmlLoadedF3dC);
			try {
				urlloaderF3d.load(new URLRequest(mainXml.HouseInfo.F3DPath + "/" + url + ".F3D"));
			}catch (e:Error) {
			}
		}
		private var mainF3d:XML;
		private var proId:int;
		private var proInfoLoader:Loader;
		private function xmlLoadedF3dC(e:Event):void 
		{
			mainF3d = new XML(e.target.data);
			if(mainF3d.Object.Info.ProductName!=""){
				proInfoWinMain.proName.text = mainF3d.Object.Info.ProductName;
			}else {
					proInfoWinMain.proName.text = "无";
			}
			proId = int(mainF3d.Object.Info.ProductID);
			gateway.call("product.GetProductInfo", responderN, proId);
			if (proInfoLoader != null) {
				if (proInfoWinMain.contains(proInfoLoader)) {
					proInfoWinMain.removeChild(proInfoLoader);
				}
			}
			proInfoLoader = new Loader();
			proInfoWinMain.addChild(proInfoLoader);
			if (mainF3d.Object.Info.Memo != "") {
				try{
					proInfoLoader.load(new URLRequest(mainXml.House.HouseInfo.ProductImagePath + "/" + mainF3d.Object.Info.Memo));
					proInfoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, iserr);
				}catch (e:Error) {
					trace(e)
				}
			}
			proInfoLoader.x = 0;
			proInfoLoader.y = 170;
		}
		
		private function iserr(e:IOErrorEvent):void 
		{
			
		}
		private function changeProductinInfo(e:MouseEvent):void 
		{
			engine3D.replaceModel(f3dName);
		}
		
		
		
		private function closedCPwin():void {
			TweenLite.to(changeListMain, 0.3, { x: cpWinHideX } );
			TweenLite.to(eng3dBoxforEng, 0.3, { x: engDefaultX } );
			TweenLite.to(proInfoWinMain, 0.3, { x:cpWinHideX - 105 } );
			contralBarF(true);
		}
		private function changeProductNew(e:MouseEvent):void 
		{
			trace(e.currentTarget.parent.name)
			engine3D.replaceModel(e.currentTarget.parent.name);
			engine3D.addEventListener(ProgressEvent.PROGRESS, setProBarCp);
			engine3D.addEventListener("texturesLoaded", loadCPOver);
			trace(e.currentTarget.parent.y);
			changeListMain.btnBox.loadBarForCp.y = e.currentTarget.parent.y;
			changeListMain.btnBox.loadBarForCp.gotoAndPlay(2);
		}
		
		private function loadCPOver(e:Event):void 
		{
			engine3D.removeEventListener(ProgressEvent.PROGRESS, setProBarCp);
			engine3D.removeEventListener("texturesLoaded", loadCPOver);
			changeListMain.btnBox.loadBarForCp.gotoAndPlay(63);
			
		}
		
		private function setProBarCp(e:ProgressEvent):void 
		{
			if (changeListMain.btnBox.loadBarForCp.currentFrame > 5) {
				changeListMain.btnBox.loadBarForCp.gotoAndStop(int(e.bytesLoaded / e.bytesTotal*41)+20);
			}
		}
		
		private function setRoom(e:MouseEvent):void {
			engine3D.unSelectProduct();
			if (mainState == "normal") {
				roomListBtn.typeMode = false;
				roomListBtn.gotoAndStop("out");
				openRoomwin();
				mainState = "roomWin";
				return;
			}else if (mainState != "roomWin") {
				roomListBtn.typeMode = false;
				roomListBtn.gotoAndStop("out");
				closeWinAndActive();
				mainState = "roomWin";
			}else if(mainState == "roomWin"){
				roomListBtn.typeMode = true;
				roomListBtn.gotoAndStop("over");
				closedroomwin();
				mainState = "normal"
			}
		}
		private function openRoomwin():void {
			makeroomwin();
			contralBarF(false);
			TweenLite.to(roomListMain, 0.3, { x: roomWinShowX } );
			TweenLite.to(eng3dBoxforEng, 0.3, { x:roomWinShowX / 2 + engDefaultX } );
		}
		
		private function makeroomwin():void {
			roomListMain.CPwinBar.barBtn.y = 0;
			roomListMain.btnBox.y = 0;
			var removeLen:int = roomwinListBtnList.length;
			for (var j:int = 0; j < removeLen; j++ ) {
				roomListMain.btnBox.removeChild(roomwinListBtnList[j].btn)
			}
			roomwinListBtnList = new Array();
			//trace(mainXml.House.CameraList.Camera.length());
			var len:int = mainXml.HouseInfo.CameraList.Camera.length();
			for (var i:int = 0; i < len; i++ ) {
				var roomBtn:roomBox = new roomBox();
				roomBtn.y = 23 + 185*i;
				roomListMain.btnBox.addChild(roomBtn);
				roomBtn.loadPicUrl("Images/" + (i + 1) + ".jpg");
				var obj:Object = { };
				obj.roomId=mainXml.HouseInfo.CameraList.Camera[i].RoomID;
				obj.cx = mainXml.HouseInfo.CameraList.Camera[i].X;
				obj.cy = mainXml.HouseInfo.CameraList.Camera[i].Y;
				obj.cz = mainXml.HouseInfo.CameraList.Camera[i].Z;
				obj.tx=mainXml.HouseInfo.CameraList.Camera[i].RX;
				obj.ty=mainXml.HouseInfo.CameraList.Camera[i].RY;
				obj.tz=mainXml.HouseInfo.CameraList.Camera[i].RZ;
				objDic[roomBtn]=obj;
				roomBtn.addEventListener(MouseEvent.CLICK, goCamera);
			}
		}
		private var objDic:Dictionary = new Dictionary();
		
		private function goCamera(e:MouseEvent):void 
		{
			//roomIDNew
			var obj:Object = objDic[e.currentTarget];
			roomIDNew = obj.roomId;
			engine3D.initRoom(roomIDNew);
			engine3D.setCamera(new Vector3D(obj.cx,obj.cy,obj.cz), new Vector3D(obj.tx,obj.ty,obj.tz));
		}
		private function closeroomwin_M(e:MouseEvent):void 
		{
			roomListBtn.typeMode = true;
			closedroomwin();
		}
		private function closedroomwin():void {
			contralBarF(true);
			roomListBtn.gotoAndStop("over");
			TweenLite.to(roomListMain, 0.3, { x: roomWinHideX } );
			TweenLite.to(eng3dBoxforEng, 0.3, { x: engDefaultX } );
			
		}
		
		
		private function stroomBarDrag(e:MouseEvent):void 
		{
			barStY = roomListMain.CPwinBar.barBtn.y;
			autobackBar = false;
			stMouseY = e.stageY;
			roomListMain.CPwinBar.barBtn.removeEventListener(MouseEvent.MOUSE_DOWN, stroomBarDrag);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveroomBar);
			stage.addEventListener(MouseEvent.MOUSE_UP, stoproomBarDrag);
		}
		
		private function stoproomBarDrag(e:MouseEvent):void 
		{
			autobackBar = true;
			roomListMain.CPwinBar.barBtn.addEventListener(MouseEvent.MOUSE_DOWN, stroomBarDrag);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveroomBar);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stoproomBarDrag);
		}
		private function moveroomBar(e:MouseEvent) {
			var mc_Y:Number = barStY + (e.stageY - stMouseY);
			if (mc_Y < 0) {
				mc_Y = 0;
			}else if(mc_Y>(stage.stageHeight-roomListMain.CPwinBar.barBtn.height)) {
				mc_Y = stage.stageHeight - roomListMain.CPwinBar.barBtn.height;
			}
			TweenLite.to(roomListMain.CPwinBar.barBtn, 0.5, { y:mc_Y } );
			TweenLite.to(roomListMain.btnBox, 0.5, { y:-mc_Y / (stage.stageHeight - roomListMain.CPwinBar.barBtn.height) * (roomListMain.btnBox.height - stage.stageHeight) } );
		}
		private function setProduct(e:Event):void 
		{
			/*engine3D.unSelectProduct();
			if (mainState == "normal") {
				roomListBtn.typeMode = false;
				roomListBtn.gotoAndStop("out");
				//openRoomwin();
				mainState = "roomWin";
				return;
			}else if (mainState != "roomWin") {
				roomListBtn.typeMode = false;
				roomListBtn.gotoAndStop("out");
				closeWinAndActive();
				//mainState = "roomWin";
			}else if(mainState == "roomWin"){
				roomListBtn.typeMode = true;
				roomListBtn.gotoAndStop("over");
				closedroomwin();
				//mainState = "normal"
			}*/
		}
		
		private function onResize(e:Event=null):void 
		{
			eng3dBox.height = stage.stageHeight;
			eng3dBox.width = stage.stageWidth ;
			mainMune.unMc.y = stage.stageHeight - 42;
			mainMune.contralBar.y = stage.stageHeight - 57;
			engine3D.setViewSize(eng3dBox.width, eng3dBox.height);
			roomListMain.btnBox.y = 0;
			changeListMain.btnBox.y = 0;
			roomListMain.CPwinBar.y = 0;
			changeListMain.CPwinBar.y = 0;
		}
		
		private function contralBarF(bol:Boolean = false) {
			mainMune.contralBar.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			if (bol == true) {
				TweenLite.to(mainMune.contralBar, 0.4, { x:140 } );
			}else {
				TweenLite.to(mainMune.contralBar, 0.4, { x:-10 } );
			}
		}
		public function loadOver() {
			TweenLite.to(mainMune, 0.4, { x:0, delay:4 } );
			TweenMax.to(eng3dMask, 0.4, { autoAlpha:0,delay:3 } );
			TweenLite.to(eng3dBoxforEng, 0.4, { x:engDefaultX, delay:4 } );
			TweenLite.to(mainMune.contralBar, 0.3, { x:140, delay:4 } );
		}
		public function log_Mc(s:String):void
		{
			log_mc.log(s);
		}
		private function clearLog():void
		{
			log_mc.clearLog();
		}
		public function onResult(result:Object) : void {
			var itemArray:Array = DataParser.resultToArray(result, false);
			var o:Object = itemArray[0];
			if(o.brand_name!=""){
				proInfoWinMain.ppName.text = "品牌：" + o.brand_name;
			}else {
				proInfoWinMain.ppName.text = "品牌：无";
			}
			if(o.standard!=""){
				proInfoWinMain.ccName.text = "尺寸：" +o.standard;
			}else {
				proInfoWinMain.ccName.text = "尺寸：无" ;
			}
			if(o.sort_name!=""){
				proInfoWinMain.czName.text = "类型：" +o.sort_name;
			}else {
				proInfoWinMain.czName.text = "类型：无" ;
			}
			if(o.color_name!=""){
				proInfoWinMain.ysName.text = "颜色：" +o.color_name ;
			}else {
				proInfoWinMain.ysName.text = "颜色：无"  ;
			}
			if(o.price!=""){
				proInfoWinMain.priceName.text = "￥" +o.price ;
			}else {
				proInfoWinMain.priceName.text = "暂无" ;
			}
		}
		public function onError(param1:Object) {
		}
		
		
		//键盘及鼠标
		private function keyDown(e:KeyboardEvent):void 
		{
			if ((e.charCode == 121)) {
				if (log_mc.visible == false) {
					log_mc.visible = true;
				}else {
					log_mc.visible = false;
				}
			}
			if(e.ctrlKey == false || e.altKey == false){
				return;
			}
			if(e.keyCode==53)//ctrl + alt + 5:切换调试窗口显示
			{
				log_mc.visible = !log_mc.visible;
			}
			else if(e.keyCode==54)//ctrl + alt + 6：清除调试窗口内容
			{
				clearLog();
			}
			else if(e.keyCode==55)//ctrl + alt + 7：切换物体信息窗口显示
			{
				engine3D.showObjectInfo = !engine3D.showObjectInfo;
				engine3D.modelMoveEnable = engine3D.showObjectInfo;
			}
		}
		private function outProMouse(e:Event):void 
		{
			Mouse.cursor = "auto"
		}
		private function overProMouse(e:Event):void 
		{
			Mouse.cursor = "myCursor"
		}
	}
}
