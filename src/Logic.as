package {
  import flash.display.MovieClip;
  import flash.events.*;
  import app.Controller;
  
  dynamic public class Logic extends BasicLogic{
    private var controller:Controller;
	public var version:String = "VERSION 0.1";
	public function Logic(){
		addEventListener(Event.ADDED_TO_STAGE,onInit);

	}
	public function onInit(e:Event):void
	{		
		removeEventListener(Event.ADDED_TO_STAGE,onInit);
		controller = Controller.getInstance();
		controller.registerTarget("Logic",this);
		log("I'm Logic:"+version);
		//initLogic();
	}
	private function initLogic()
	{
		var ui = controller.getTarget("UI");
		if(ui)
		{
			addEvent(ui.test_btn,"click",onClick);
		}
	}
	private function onClick(e)
	{
		var ui = controller.getTarget("UI");
		ui.log("onClick5!");
	}
	public function log(value:String):void
	{
		controller.log(value);
	}
	public function traceMe():void
	{
		log(version);
	}
  }
}
