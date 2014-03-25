package {
  import flash.display.MovieClip;
  import flash.events.Event;
  dynamic public class BasicLogic extends MovieClip{
    private var lis:Array;//定义一数组保存侦听
    public function BasicLogic(){
      lis = new Array();
      addEventListener(Event.REMOVED,remove);
    }
    
    //重写addEventListener,在增加侦听的时候..把相应的事件保存到数组
    public function addEvent(target:Object,type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
      lis.push([type,listener,useCapture,target])
      target.addEventListener(type,listener,useCapture,priority,useWeakReference)
    }
    
    private function remove(e:Event):void{
      if(e.currentTarget != e.target)
	  {
		return;  
	  }
      stop();
      //删除子对象
      trace("删除前有子对象",numChildren);
      while(numChildren > 0){
        removeChildAt(0);
      }
      trace("删除后有子对象",numChildren);
      
      //删除动态属性
      for(var k:String in this){
        trace("删除属性",k);
        delete this[k];
      }
      
      //删除侦听
      for(var i:uint=0;i<lis.length;i++){
        trace("删除Listener",lis[i][0]);
		var target = lis[i][3];
        target.removeEventListener(lis[i][0],lis[i][1],lis[i][2])
      }
      lis = null;
    }
  }
}
