/*
	脚本引擎管理器
*/
package app.utils
{
	import flash.events.*;
	import app.vo.LuaScriptVO;
	import app.event.LuaEngineEvent;
	import luaAlchemy.LuaAlchemy;
	import flash.display.MovieClip;
	import app.Controller;
	public class LuaScriptEngine extends EventDispatcher
	{
		public var appList:Array = new Array();
		public var luaScript:LuaScriptVO = new LuaScriptVO();
		public var luaEngineEvent:LuaEngineEvent;
		public var lua:LuaAlchemy;
		public var host:*;
		public var controller:*;
		public function LuaScriptEngine(hostName=null)
		{
			controller = Controller.getInstance();
			if (null == hostName)
			{
				host = this;
			}
			else
			{
				host = hostName;
			}
		}
		/*
		启动应用
		1、查找线程表中是否存在本应用
		2、没有则创建新的应用，创建新的lua进程，执行此应用，并将此进程信息更新到应用列表中
		2、存在此应用，判断是否需要关闭原进程，然后执行此应用，更新进程信息
		*/
		public function executeApp(instanceName:String="",code:String="",killOldInstance:Boolean=true):Boolean
		{
			trace("LuaScriptEngine.executeApp");
			if ((instanceName=="")||(code==""))
			{
				return false;
			}
			var stack:Array = new Array();
			/*for (var i=0; i<appList.length; i++)
			{
				if (instanceName == appList[i].instanceName)
				{
					if (! killOldInstance)
					{
						//在原有进程上运行
						lua = appList[i].instance as LuaAlchemy;
						lua.setGlobal("LuaEngine", host);
						stack = lua.doString(code);	
						luaEngineEvent = new LuaEngineEvent(LuaEngineEvent.EXEC_RESULT);
						controller.listener.dispatchEvent(luaEngineEvent);
						luaEngineEvent.data = stack.toString();
						dispatchEvent(luaEngineEvent);
						return true;
					}else
					{
						//appList[i].instance.close();
						//appList[i].instance = null;
						//appList.splice(i,1);
						break;
					}
				}
			}*/

			lua = new LuaAlchemy();
			lua.setGlobal("LuaEngine", host);
			stack = lua.doString(code);
			var luaScript:LuaScriptVO = new LuaScriptVO();
			luaScript.instanceName = instanceName;
			luaScript.instance = lua;
			luaScript.appCode = code;
			luaScript.activateTime = getCurrentTime();
			appList.push(luaScript);
			//luaScript.caption = ;
			luaEngineEvent = new LuaEngineEvent(LuaEngineEvent.EXEC_RESULT);
			luaEngineEvent.data = stack.toString();
			dispatchEvent(luaEngineEvent);
			controller.listener.dispatchEvent(luaEngineEvent);
			return true;
		}
		public function killProcess(instanceName:String)
		{
			for (var i=0; i<appList.length; i++)
			{
				if (instanceName == appList[i].instanceName)
				{
					trace("kill instance:",instanceName);
					trace("---:",appList[i].instance);
					appList[i].instance.close();
					appList[i].instance = null;
					appList.splice(i,1);
					return;
				}
			}
		}
		public function listProcess():void
		{
			for (var i=0; i<appList.length; i++)
			{
				trace("process[",i,"]:",appList[i].instanceName);
				//trace("instance:",appList[i].instanceName);
				//trace("name:",appList[i].instance);
			}
		}
		public function getProcessList():Array
		{
			return appList;
		}
		private function getCurrentTime():String
		{
			var nowdate:Date = new Date();
			var hour:Number = nowdate.getHours();
			var minute:Number = nowdate.getMinutes();
			var second:Number = nowdate.getSeconds();
			return hour+":"+minute+":"+second;
		}
	}
}