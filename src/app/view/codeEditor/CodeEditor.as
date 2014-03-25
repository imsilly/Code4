package app.view.codeEditor
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.Responder;
	import app.RemotingConnection;
	import luaAlchemy.LuaAlchemy;
	import app.utils.Base64;
	import flash.text.TextFormat;
	import app.vo.*;
	import flash.events.*;
	import flash.utils.*;
	import app.utils.LuaScriptEngine;
	import app.event.LuaEngineEvent;
	import app.Controller;
	
	public class CodeEditor extends MovieClip
	{
		public var luaEngine:LuaScriptEngine;
		private var lua:LuaAlchemy;
		public var controller:* = Controller.getInstance();
		private var gateway:RemotingConnection;
		private var timer:Timer = new Timer(2000,10000);		
		public var currentCode:String = "";
		public var codeContent:String="";
		public function CodeEditor()
		{
			//controller = Controller.getInstance();
			luaEngine = new LuaScriptEngine(this);
			controller.registerTarget("luaEngine",this);
			var tFormat:TextFormat = new TextFormat();
			tFormat.color = 0x460000;
			tFormat.size = 12;
			tFormat.leading = 4;//行高
			code_txt.setStyle("textFormat",tFormat);
			bg_mc.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownCallback);
			bg_mc.addEventListener(MouseEvent.MOUSE_UP,onMouseUpCallback);
			hide_btn.addEventListener(MouseEvent.MOUSE_UP,onHideMe);
			run_btn.addEventListener(MouseEvent.CLICK, onRunCodeAction);
			save_btn.addEventListener(MouseEvent.CLICK, onSaveAction);
			codeList_cb.addEventListener(Event.CHANGE,onCodeListChanged);
			//code_txt.addEventListener(Event.CHANGE,onCodeTextChanged);
			timer.addEventListener(TimerEvent.TIMER,timerAction);
			controller.listener.addEventListener(LuaEngineEvent.EXEC_RESULT,onExecResult);
			gateway = new RemotingConnection(controller.config.ServerURL);
			getCodeByName("core.lua");
			timer.start();
			
		}
		private function onExecResult(e)
		{
			debugOutput("onExecResult:"+e.data);
		}
		public function execApp(instanceName:String,code:String)
		{
			luaEngine.executeApp(instanceName,code);
		}
		private function onRunCodeAction(e:MouseEvent)
		{
			luaEngine.executeApp(codeList_cb.selectedItem.label,code_txt.text);
			/*if (code_txt.text != "")
			{
				if (lua)
				{
					lua.close();
					lua = null;
				}
				debugOutput("Run code:"+codeList_cb.selectedItem.label);
				lua = new LuaAlchemy();
				lua.setGlobal("LuaEngine", this);
				var stack:Array = lua.doString(code_txt.text);
				debugOutput(stack.toString());
			}
			else
			{
				debugOutput("No code existed!");
			}*/
		}
		private function onSaveAction(e:MouseEvent)
		{
			saveCodeByName();
		}
		private function onCodeListChanged(e)
		{
			getCodeByName(codeList_cb.selectedItem.data.toString());
		}
		public function saveCodeByName()
		{
			var fileName:String = codeList_cb.selectedItem.data;
			var encode:String = Base64.encode(code_txt.text);
			gateway.call("system.saveCodeByName",new Responder(onSaveCodeResult,onError),fileName,encode);
		}
		public function saveCodeContentByName(fileName:String,content:String)
		{
			var encode:String = Base64.encode(content);
			gateway.call("system.saveCodeByName",new Responder(onSaveCodeResult,onError),fileName,encode);
		}
		public function getCodeByNameList(fileName:String)
		{
			//fileName="core.lua,config.lua";
			gateway.call("system.getCodeByNameList",new Responder(onGetCodeByNameListResult,onError),fileName);
		}
		public function getCodeByName(fileName:String)
		{
			gateway.call("system.getCodeByName",new Responder(onGetCodeResult,onError),fileName);
		}
		private function onSaveCodeResult(result:Object):void
		{			
			if (result.toString() == "true")
			{
				//controller.listener.dispatchEvent();
				debugOutput("Save code success");
			}
			else
			{
				debugOutput("Save code error!");
			}
		}
		//for inside
		private function onGetCodeResult(result:Object):void
		{
			if (result)
			{
				code_txt.text = Base64.decode(result.toString());
				codeContent=Base64.decode(result.toString());
				//controller.listener.dispatchEvent(new Event("on_get_code_result"));
				//currentCode = Base64.decode(result.toString());
				//code_txt.htmlText = getHtmlCode();
			}
			else
			{
				debugOutput("Get Code Error！");
			}
		}
		//for lua
		private function onGetCodeByNameListResult(result:Object):void
		{
			if (result)
			{
				currentCode = Base64.decode(result.toString());
				controller.listener.dispatchEvent(new Event("on_get_code_result"));	
			}
			else
			{
				debugOutput("Get Code Error！");
			}
		}		
		private function onCodeTextChanged(e=null)
		{
			//code_txt.htmlText = getHtmlCode();
		}
		private function timerAction(e)
		{
			//var str = replaceTxt(/function+/g,"<b><font color='#FF0000'>function</font></b>",code_txt.text);
			//code_txt.htmlText = str;
		}
		private function getHtmlCode():String
		{
			var str = replaceTxt(/function+/g,"<b><font color='#FF0000'>function</font></b>",currentCode);
			return str;
		}
		function replaceTxt(reg:RegExp,str2:String,txt:String):String
		{
			var regex:RegExp = reg;
			var str:String = txt;
			return str.replace(regex,str2);
		}
		private function onError(result:Object):void
		{
			debugOutput(result.toString());
		}
		private function onHideMe(e)
		{
			/*if (controller.main_mc)
			{
				//controller.main_mc.codeEditor_mc.visible = false;
			}*/
		}
		public function log(str:String)
		{
			output_txt.appendText(str + "\n");
			output_txt.verticalScrollPosition = output_txt.maxVerticalScrollPosition;
		}
		public function debugOutput(str:String)
		{
			debug_txt.appendText(str+"\n");
			debug_txt.verticalScrollPosition = debug_txt.maxVerticalScrollPosition;
		}
		public function clear():void
		{
			output_txt.text = "";
		}
		private function onMouseDownCallback(e)
		{
			this.startDrag();
		}
		private function onMouseUpCallback(e)
		{
			this.stopDrag();
		}
	}
}