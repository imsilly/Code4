package  {
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	public class MainLoader extends MovieClip {
		private var loader:Loader;
		private var mainUI:MovieClip;
		public function MainLoader() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.addEventListener(Event.ADDED_TO_STAGE, inStage);
			
		}
		private function inStage(e:Event):void 
		{
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			mainLogo.x = stage.stageWidth / 2;
			mainLogo.y = stage.stageHeight / 2-65;
			loadBar.x = 0;
			loadBar.y = int(stage.stageHeight / 2);
			loadBar.width = stage.stageWidth;
			backMask.width = stage.stageWidth;
			backMask.height = stage.stageHeight;
			removeEventListener(Event.ADDED_TO_STAGE, inStage);
			stage.addEventListener(Event.RESIZE, onResize);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, mainLoaded);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, getProgress);
			loader.load(new URLRequest("XuanJu.swf"));
		}
		private function getProgress(e:ProgressEvent):void 
		{
			loadBar.lineMc.scaleX = e.bytesLoaded / e.bytesTotal*0.3;
		}
		
		private function onResize(e:Event):void 
		{
			mainLogo.x = stage.stageWidth / 2;
			mainLogo.y = stage.stageHeight / 2-65;
			loadBar.x = 0;
			loadBar.y = int(stage.stageHeight / 2);
			loadBar.width = stage.stageWidth;
			backMask.width = stage.stageWidth;
			backMask.height = stage.stageHeight;
			
		}
		private function mainLoaded(e:Event):void 
		{
			logset("swf over")
			mainUI = loader.content as MovieClip;
			addChildAt(mainUI, 0); 
			mainUI.addEventListener(ProgressEvent.PROGRESS, getMainUIPro);
			mainUI.addEventListener(Event.COMPLETE, compNew);
			//test2();
		}
		private var loader2:Loader;
		private function test2() {
			loader2 = new Loader();
			loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, mainLoaded2);
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, getProgress);
			loader2.load(new URLRequest("viewer.swf"));
		}
		private var mainUI2:MovieClip;
		private function mainLoaded2(e:Event):void 
		{
			logset("swf over")
			mainUI2 = loader2.content as MovieClip;
			mainUI2.x = 400;
			addChildAt(mainUI2, 0); 
			mainUI2.addEventListener(Event.COMPLETE, compNew2);
		}
		
		private function compNew2(e:Event):void 
		{
			mainUI2.loadOver();
		}
		
		
		private function compNew(e:Event):void 
		{
			logset("mod over");
			loadBar.lineMc.scaleX = 1;
			mainUI.removeEventListener(ProgressEvent.PROGRESS, getMainUIPro);
			mainUI.removeEventListener(Event.COMPLETE, compNew);
			TweenMax.to(backMask, 1, { autoAlpha:0,onComplete:showUI } );
			TweenMax.to(mainLogo, 1, { autoAlpha:0 } );
			TweenMax.to(loadBar, 1, { autoAlpha:0 } );
		}
		
		private function getMainUIPro(e:ProgressEvent):void 
		{
			logset("progress start:" + e.bytesLoaded);
			loadBar.lineMc.scaleX = Number(e.bytesLoaded / e.bytesTotal*0.7+0.3);
		}
		
		private function showUI():void 
		{
			mainUI.loadOver();
		}
		private function logset(str:String) {
			log.text = str;
		}
	}
}
