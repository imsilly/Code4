package app.loader
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	//图像加载器
	public class ImageLoader extends EventDispatcher
	{
		private var _loader:Loader;
		private var _image:DisplayObject;

		//private var _containerObject:DisplayObjectContainer;
		//-------------------------------------------------------------
		public function ImageLoader(target:IEventDispatcher = null)
		{
			super(target);
			init();
		}

		//-------------------------------------------------------------
		public function get image():DisplayObject
		{
			return _image;
		}
		//-------------------------------------------------------------
		public function load(imgaeURL:String):void
		{
			//_containerObject = containerObject;
			_loader.load(new URLRequest(imgaeURL));
		}

		//-------------------------------------------------------------
		public function dispose():void
		{
			removeListeners(_loader.contentLoaderInfo);
			_loader = null;
		}

		//-------------------------------------------------------------
		private function init():void
		{
			_loader = new Loader();
			addListeners(_loader.contentLoaderInfo);
		}

		//-------------------------------------------------------------
		private function addListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			//dispatcher.addEventListener(Event.UNLOAD,unLoadHandler);
		}

		//-------------------------------------------------------------
		private function removeListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.removeEventListener(Event.OPEN, openHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			//dispatcher.removeEventListener(Event.UNLOAD,unLoadHandler);
		}

		//-------------------------------------------------------------
		private function openHandler(event:Event):void
		{
			this.dispatchEvent(event);
		}

		//-------------------------------------------------------------
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			this.dispatchEvent(event);
		}

		//-------------------------------------------------------------
		private function progressHandler(event:ProgressEvent):void
		{
			this.dispatchEvent(event);
		}

		//-------------------------------------------------------------
		private function completeHandler(event:Event):void
		{
			_image = _loader.content;
			_loader.unload();

			//if(_containerObject) _containerObject.addChild(d);

			this.dispatchEvent(event);
			_image = null;
		}
		//-------------------------------------------------------------
		//private function unLoadHandler(event:Event):void{this.dispatchEvent(event);}
		//-------------------------------------------------------------
	}
}