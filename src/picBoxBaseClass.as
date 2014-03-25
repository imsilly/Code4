package  {
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.net.URLLoader;
	
	public class picBoxBaseClass extends MovieClip {
		public var publicPath:String;
		public var picPath:String;
		private var picName:String;
		private var loader:Loader;
		private var urlloader:URLLoader;
		public var mainXml:XML;
		
		public function picBoxBaseClass() {
			buttonTx.totText.text = "";
		}
		
		public function loadPic(url:String) {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LoaderOver);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErr);
			picBoxBase.addChild(loader);
			try{
				loader.load(new URLRequest(picPath + "/" + url + ".jpg"));
			}catch (e:Error) {
				
			}
			loader.alpha = 0;
		}
		
		private function ioErr(e:IOErrorEvent):void 
		{
			
		}
		public function loadPicUrl(url:String) {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LoaderOver);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErr);
			picBoxBase.addChild(loader);
			try{
				loader.load(new URLRequest(url));
			}catch (e:Error) {
			}
			loader.alpha = 0;
		}
		
		public function loadF3D(url:String) {
			urlloader = new URLLoader();
			urlloader.addEventListener(Event.COMPLETE, xmlLoaded);
			try{
				urlloader.load(new URLRequest(publicPath + "/" + url + ".f3d"));
			}catch (e:Error) {
			}
			picName = url;
		}
		
		private function xmlLoaded(e:Event):void 
		{
			mainXml = new XML(e.target.data);
			if (mainXml.Object.Info.SmallPic == "") {
				loadPic(picName);
			}else {
				loadPic(mainXml.Object.Info.SmallPic);
			}
			//trace(buttonTx.totText.text = mainXml.Object.Info.ProductName);
			if(buttonTx.totText.text ==""){
				buttonTx.totText.text = mainXml.Object.Info.ProductName;
			}
		}
		public function setText(Str:String = "") {
			buttonTx.totText.text = Str;
		}
		
		
		private function LoaderOver(e:Event):void 
		{
			TweenMax.to(smallL, 0.5, { autoAlpha:0 } );
			TweenLite.to(loader, 0.5, { alpha:1 } );
		}
	}
}
