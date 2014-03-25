package app.loader
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="item_complete", type="flash.events.Event")]
	[Event(name="item_error", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	public class MyQueueLoader extends EventDispatcher
	{
		private var _loader:MyLoader;
		
		private var list:Array;
		private var index:int;
		
		public function MyQueueLoader()
		{
			super();
			init();
		}
		
		public function get loader():MyLoader
		{
			return _loader;
		}
		
		private function init():void
		{
			index = 0;
			list = [];
			
			_loader = new MyLoader();
			_loader.addEventListener(Event.COMPLETE,onLoadComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			_loader.addEventListener(ProgressEvent.PROGRESS,onLoadProgress);
		}
		
		private function onLoadComplete(e:Event):void
		{
			this.dispatchEvent(new Event("item_complete"));
			
			index++;
			loadNext();
		}
		
		private function onLoadError(e:Event):void
		{
			this.dispatchEvent(new Event("item_error"));
			
			index++;
			loadNext();
		}
		
		private function onLoadProgress(e:Event):void
		{
			this.dispatchEvent(e);
		}
		
		//===============================================================================
		public function append(url:String,container:Sprite,size:Point=null,alpha:Number=1,level:int=-1,gScaling:Boolean=false):void
		{
			var o:Object = {url:url,container:container,size:size,alpha:alpha,level:level,gScaling:gScaling};
			list.push(o);
		}
		
		public function start():void
		{
			loadNext();
		}
		
		private function loadNext():void
		{
			if(index < list.length)
			{
				var o:Object = list[index];
				//if(o.size!=null)loader.autoSize(o.size.x,o.size.y);
				_loader.container = o.container;
				_loader.size = o.size;
				_loader.alpha = o.alpha;
				_loader.level = o.level;
				_loader.gScaling = o.gScaling;
				_loader.load(o.url);
			}
			else
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
				empty();
			}
		}
		
		public function cancel():void
		{
			_loader.close();
		}
		
		public function empty():void
		{
			list.length = 0;
			index = 0;
		}
		
		public function get progress():Number
		{
			var len:int = list.length;
			var n1:Number = index/len;
			var n2:Number = _loader.progress/len;
			return n1 + n2;
		}
	}
}