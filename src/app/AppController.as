package  app
{
	import flash.display.MovieClip;
	import flash.net.*;
	import app.utils.EventBroadcaster;
	import flash.events.EventDispatcher;

	public class AppController
	{
		private static var singleton:AppController;

		public var systemTarget:Object = new Object();
		public var listener:EventDispatcher=new EventDispatcher();
		public static function getInstance():AppController
		{
			if ( singleton == null )
			{
				singleton = new AppController();
			}
			return singleton;
		}

		public function AppController()
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

	}
}