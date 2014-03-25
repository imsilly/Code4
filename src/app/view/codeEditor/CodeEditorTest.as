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
	
	public class CodeEditorTest extends MovieClip
	{
		public var luaEngine:LuaScriptEngine;
		private var lua:LuaAlchemy;
		public var controller:*;
		private var gateway:RemotingConnection;
		private var timer:Timer = new Timer(2000,10000);		
		public var currentCode:String = "";
		public var codeContent:String="";
		public function CodeEditorTest()
		{
			controller = Controller.getInstance();
			luaEngine = new LuaScriptEngine(this);
			var tFormat:TextFormat = new TextFormat();
			tFormat.color = 0x460000;
			tFormat.size = 12;
			tFormat.leading = 4;//行高
			code1_txt.setStyle("textFormat",tFormat);
			code2_txt.setStyle("textFormat",tFormat);
			code3_txt.setStyle("textFormat",tFormat);
			bg_mc.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownCallback);
			bg_mc.addEventListener(MouseEvent.MOUSE_UP,onMouseUpCallback);
			hide_btn.addEventListener(MouseEvent.MOUSE_UP,onHideMe);
			run1_btn.addEventListener(MouseEvent.CLICK, onRunCode1Action);
			run2_btn.addEventListener(MouseEvent.CLICK, onRunCode2Action);
			run3_btn.addEventListener(MouseEvent.CLICK, onRunCode3Action);
			listProcess_btn.addEventListener(MouseEvent.CLICK, onListProcessAction);
			
			save_btn.addEventListener(MouseEvent.CLICK, onSaveAction);
			codeList_cb.addEventListener(Event.CHANGE,onCodeListChanged);
			gateway = new RemotingConnection(controller.config.ServerURL);
			getCodeByName("config.lua");			
		}
		private function onListProcessAction(e:MouseEvent)
		{
			luaEngine.listProcess();
		}				
		private function onRunCode1Action(e:MouseEvent)
		{
			luaEngine.addEventListener(LuaEngineEvent.EXEC_RESULT,onExecResult);
			luaEngine.executeApp(pName1_txt.text,code1_txt.text,getBoolean(pKill1_txt.text));
		}
		private function onRunCode2Action(e:MouseEvent)
		{
			luaEngine.addEventListener(LuaEngineEvent.EXEC_RESULT,onExecResult);
			luaEngine.executeApp(pName2_txt.text,code2_txt.text,getBoolean(pKill2_txt.text));
		}
		private function onRunCode3Action(e:MouseEvent)
		{
			luaEngine.addEventListener(LuaEngineEvent.EXEC_RESULT,onExecResult);
			luaEngine.executeApp(pName3_txt.text,code3_txt.text,getBoolean(pKill3_txt.text));
		}
		private function getBoolean(value:String):Boolean
		{
			if(value=="false")
			{
				return false;
			}
			return true;
		}		
		private function onExecResult(e)
		{
			trace("onExecResult:"+e.data);
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
			var encode:String = Base64.encode(code1_txt.text);
			//gateway.call("system.saveCodeByName",new Responder(onSaveCodeResult,onError),fileName,encode);
		}
		public function saveCodeContentByName(fileName:String,content:String)
		{
			var encode:String = Base64.encode(content);
			//gateway.call("system.saveCodeByName",new Responder(onSaveCodeResult,onError),fileName,encode);
		}		
		public function getCodeByNameList(fileName:String)
		{
			//fileName="core.lua,config.lua";
			gateway.call("system.getCodeByNameList",new Responder(onGetCodeResult,onError),fileName);
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
		
		private function onGetCodeResult(result:Object):void
		{
			if (result)
			{
				code1_txt.text = Base64.decode(result.toString());
				codeContent=Base64.decode(result.toString());
				controller.listener.dispatchEvent(new Event("on_get_code_result"));
				//currentCode = Base64.decode(result.toString());
				//code1_txt.htmlText = getHtmlCode();
			}
			else
			{
				debugOutput("Get Code Error！");
			}
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
			if (controller.main_mc)
			{
				controller.main_mc.codeEditor_mc.visible = false;
			}
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