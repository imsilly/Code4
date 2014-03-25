package app.vo{	
	public class LuaScriptVO {
		public var id:int;					//应用的ID号
		public var instance:*;				//Lua实例句柄
		public var instanceName:String;		//应用实例句柄名，不能重复
		public var caption:String;			//应用标题
		public var description:String;		//应用描述
		public var appCode:String;			//应用的代码
		public var status:String;			//当前状态	fail/play/pause/stop
		public var activateTime:String;		//应用激活的起始时间
		public var lifeTime:String;			//应用持续时间
		public function LuaScriptVO() {
			
		}
	}
}
