package app.loader
{
	import flash.display.AVM1Movie;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	public class MyLoader extends EventDispatcher
	{
		public var container:Sprite;
		
		public var level:int = -1;
		
		public var size:Point;
		
		public var gScaling:Boolean = false;//是否等比缩放
		
		public var alpha:Number = 1;
		
		public var cacheAsBitmap:Boolean = true;
		
		public var smoothing:Boolean = true;
		
		private var urlLoader:URLLoader;
		
		private var _loader:Loader;
		
		private var _content:DisplayObject;
		
		private var _context:LoaderContext;
		
		private var _url:String;

		public function get loader():Loader
		{
			return _loader;
		}
		
		public function get content():DisplayObject
		{
			return _content;
		}

		
		public function MyLoader(container:Sprite=null,size:Point=null,alpha:Number=1,level:int=-1,gScaling:Boolean=false)
		{
			super();
			this.container = container;
			this.size = size;
			this.alpha = alpha;
			this.level = level;
			this.gScaling = gScaling;
		}
		
		public function autoSize(w:int,h:int):void
		{
			if(size==null)
			{
				size = new Point(w,h);
			}
			else
			{
				size.x = w;
				size.y = h;
			}
		}
		
		public function close():void
		{
			if(urlLoader!=null)
			{
				try{
					urlLoader.close();
				}catch(e:*){
					if(_loader!=null)
					{
						try{
							_loader.close();
							_loader.unload();
						}catch(e:*){}
					}
				}
			}
		}
		
		public function load(url:String, context:LoaderContext=null):void
		{
			//trace("MyLoader Load:"+url);
			
			_url = url;
			_context = context;
			
			loadURL(url);
		}
		
		private function loadURL(url:String):void
		{
			if(urlLoader==null)
			{
				urlLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE,onLoadURLComplete);
				urlLoader.addEventListener(ProgressEvent.PROGRESS,onLoadProgress);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			
			urlLoader.load(new URLRequest(url));
		}
		
		private function onLoadURLComplete(e:Event):void
		{
			loadBytes(urlLoader.data);
		}
		
		private function loadBytes(bytes:ByteArray):void
		{
			if(_loader==null)
			{
				_loader = new Loader();
				addEvent(_loader.contentLoaderInfo);
			}
			
			if(_context==null)
			{
				var lc:LoaderContext = new LoaderContext();
				lc.allowCodeImport = true;				
				_context = lc;
				
				var os:String = Capabilities.os.toLowerCase();
				if(os.indexOf("iphone")!=-1 || os.indexOf("ipad")!=-1)
				{
					lc.applicationDomain = ApplicationDomain.currentDomain;
				}
			}
			
			_loader.loadBytes(bytes,_context);
		}
		
		private function addEvent(loaderInfo:LoaderInfo):void
		{
			loaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			//loaderInfo.addEventListener(ProgressEvent.PROGRESS,onLoadProgress);
		}
		
		private function removeEvent(loaderInfo:LoaderInfo):void
		{
			loaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			//loaderInfo.removeEventListener(ProgressEvent.PROGRESS,onLoadProgress);
		}
		
		private function onLoadComplete(e:Event):void
		{
			//trace("MyLoader Load Complete:"+_url);
			//trace("MyLoader container:"+container);
			_loader.content.cacheAsBitmap = cacheAsBitmap;
			//_loader.content.cacheAsBitmapMatrix = new Matrix();
			
			if(_loader.content is AVM1Movie)
			{
				trace("__MyLoader is AVM1Movie："+_url);
				if(container!=null)
				{
					_content = _loader;
					addChild(_loader);
					removeEvent(_loader.contentLoaderInfo);
					_loader = null;
				}
			}
			else
			{
				var d:DisplayObject = _loader.content;
				
				if(d is Bitmap)
				{
					var bmp:Bitmap = d as Bitmap;
					bmp.smoothing = smoothing;
				}
				else if(d is MovieClip)
				{
					var mc:MovieClip = d as MovieClip;
					
					if(mc.numChildren==1)
					{
						var d2:DisplayObject = mc.getChildAt(0);
						if(d2 is Bitmap)
						{
							trace("__MyLoader is PngSwf:"+_url);
							Bitmap(d2).smoothing = true;
						}
					}
				}
				
				if(container!=null)
				{
					_content = d;
					addChild(d);
					_loader.unload();
				}
			}
			
			this.dispatchEvent(e);
		}
		
		private function addChild(d:DisplayObject):void
		{
			d.alpha = alpha;
			
			if(level<0 || level>=container.numChildren)
			{
				container.addChild(d);
			}
			else
			{
				container.addChildAt(d,level);
			}
			
			if(size!=null)
			{
				if(size.x<=0)size.x=d.width;
				if(size.y<=0)size.y=d.height;
				
				if(gScaling)
				{
					if(d.width/d.height > size.x/size.y)
					{
						d.width = size.x;
						d.scaleY = d.scaleX;
						d.y = (size.y - d.height)/2;
					}
					else
					{
						d.height = size.y;
						d.scaleX = d.scaleY;
						d.x = (size.x - d.width)/2;
					}
				}
				else
				{
					d.width = size.x;
					d.height = size.y;
				}
				size = null;
			}
		}
		
		private function onLoadError(e:IOErrorEvent):void
		{
			trace("MyLoader Load Error:"+_url);
			this.dispatchEvent(e);
		}
		
		private var numLoaded:Number;
		private function onLoadProgress(e:ProgressEvent):void
		{
			numLoaded = e.bytesLoaded/e.bytesTotal;
			this.dispatchEvent(e);
		}
		
		public function get progress():Number
		{
			return numLoaded;
		}
		
		public function dispose():void
		{
			this.container = null;
			this.size = null;
			
			this._content = null;
			this._context = null;
			
			if(urlLoader!=null)
			{
				urlLoader.removeEventListener(Event.COMPLETE,onLoadURLComplete);
				urlLoader.removeEventListener(ProgressEvent.PROGRESS,onLoadProgress);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onLoadError);
				
				urlLoader = null;
			}
			
			if(_loader!=null)
			{
				removeEvent(_loader.contentLoaderInfo);
				_loader = null;
			}
		}
	}
}





