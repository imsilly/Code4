package  app
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	import app.utils.EventBroadcaster;
	import app.vo.ConfigInfo;
  
	public class Controller
	{
		private static var singleton:Controller;
		
		public var serverURL:String = "http://solarwind.watcher3d.com/";
		//public var serverURL:String = "http://192.168.1.101/solarwind/";
		public var playerURL:String;
		public var sceneDataURL:String;
		
		public var engine3d:*;
		public var engine:*;
		public var autoStart:Boolean;
		public var systemTarget:Object = new Object();
		public var config:ConfigInfo = new ConfigInfo();
		public var listener:EventDispatcher=new EventDispatcher();
		public static function getInstance():Controller
		{
			if ( singleton == null )
			{
				singleton = new Controller();
			}
			return singleton;
		}

		public function Controller()
		{

		}
		public function registerTarget(targetName:String,targetInstance:*):void
		{
			systemTarget[targetName] = targetInstance;
		}
		public function getTarget(targetName:String):*
		{
			var target:* = systemTarget[targetName];
			if (target)
			{
				return target;
			}
			return null;
		}
		public function log(value):void
		{
			trace(value);
		}
	}
}