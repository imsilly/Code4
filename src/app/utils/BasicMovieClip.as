package app.utils
{
	import flash.display.MovieClip;
	import flash.events.Event;
	dynamic public class BasicMovieClip extends MovieClip{;
	private var lis:Array;
	public function BasicMovieClip()
	{
		lis = new Array();
		addEventListener(Event.REMOVED,remove);
	}
	override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
	{
		lis.push([type,listener,useCapture]);
		super.addEventListener(type,listener,useCapture,priority,useWeakReference);
	}

	private function remove(e:Event):void
	{
		stop();
		if (e.currentTarget != e.target)
		{
			return;
		}
		while (numChildren > 0)
		{
			removeChildAt(0);
		}
		for (var k:String in this)
		{
			delete this[k];
		}
		for (var i:uint=0; i<lis.length; i++)
		{
			removeEventListener(lis[i][0],lis[i][1],lis[i][2]);
		}
		lis = null;
	}
}
}