package
{
	import app.Controller;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	public final class XuanJuApp extends Sprite
	{
		private var loader:Loader;
		private var swfURL:String = "XuanJu.swf";
		private var engine:*;
		
		public var start_btn:*;
		public var resize_btn:*;
		public var getMouse3D_btn:*;
		public var infoSwitch_btn:*;
		public var setCamera_btn:*;
		public var moveCarema_btn:*;
		public var getCameraInfo_btn:*;
		public var getObjectInfo_btn:*;
		
		public var size_txt:*;
		public var mouse3D_txt:TextField;
		public var setCamera_txt:TextField;
		public var moveCamera_txt:TextField;
		public var cameraInfo_txt:TextField;
		public var objectInfo_txt:TextField;
		
		public function XuanJuApp()
		{
			super();
			init();
		}
		
		//===============================================================================================
		private function init():void
		{
			Controller.getInstance().autoStart = false;
			
			loader = new Loader();
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onLoadProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
			//loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			loader.load(new URLRequest(swfURL));
			
			start_btn.addEventListener(MouseEvent.CLICK,start);
			resize_btn.addEventListener(MouseEvent.CLICK,resize);
			getMouse3D_btn.addEventListener(MouseEvent.CLICK,getMouse3D);
			infoSwitch_btn.addEventListener(MouseEvent.CLICK,infoSwitch);
			setCamera_btn.addEventListener(MouseEvent.CLICK,setCamera);
			moveCarema_btn.addEventListener(MouseEvent.CLICK,moveCamera);
			getCameraInfo_btn.addEventListener(MouseEvent.CLICK,getCameraInfo);
			getObjectInfo_btn.addEventListener(MouseEvent.CLICK,getObjectInfo);
		}
		
		//===============================================================================================
		private function onLoadComplete(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
			
			var d:DisplayObject = loader.content;
			this.addChildAt(d,0);
			
			engine = Controller.getInstance().engine3d;
			trace(engine);
			engine.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
		}
		//===============================================================================================
		private function onContextCreate(e:Event):void
		{
			engine.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
		}
		//===============================================================================================
		private function start(e:MouseEvent):void
		{
			engine.startLoad();			
		}
		
		private function resize(e:MouseEvent):void
		{
			var s:String = this.size_txt.text;
			var a:Array = s.split(",");
			engine.setViewSize(Number(a[0]),Number(a[1]));
		}
		
		private function getMouse3D(e:MouseEvent):void
		{
			var s:String = engine.getMousePositionInStage3D();
			trace(s);
			this.mouse3D_txt.text = s;
		}
		
		private function infoSwitch(e:MouseEvent):void
		{
			engine.showObjectInfo = !engine.showObjectInfo;
			engine.modelMoveEnable = engine.showObjectInfo;
		}
		
		private function setCamera(e:MouseEvent):void
		{
			var s:String = this.setCamera_txt.text;
			engine.setCameraXYZ2(s);
		}
		
		private function moveCamera(e:MouseEvent):void
		{
			var s:String = this.moveCamera_txt.text;
			engine.moveCamera2(s);			
		}
		
		private function getCameraInfo(e:MouseEvent):void
		{
			var s:String = engine.getCameraInfo();
			trace(s);
			this.cameraInfo_txt.text = s;
		}
		
		private function getObjectInfo(e:MouseEvent):void
		{
			var s:String = engine.getCurrentObjectInfo();
			trace(s);
			this.objectInfo_txt.text = s;
		}
		
		//===============================================================================================
	}
}