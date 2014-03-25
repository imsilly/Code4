/*
	SQLAdmin通用检索类，使用本类可以使用SQL语句直接对SQLServer2000数据库内容进行检索
	server		服务端IP	如"192.168.3.206"
	database	数据库名 如"Sunshine100"
	uid			数据库用户名 如"sa"
	pwd			数据库密码
	SQL			SQL查询语句	如"select * from view_test"
	MaxPerPage	返回每页的最大项数
	CurrentPage	请求第几页的数据
 * */
package com.Silly.WebService
{
	import flash.net.*;
	import flash.events.*;
	import mx.events.*;
	import mx.controls.Alert;
	import flash.system.*;
	import mx.managers.CursorManager;
	import com.Silly.Model.ModelLocator;

	public class SQLAdmin extends EventDispatcher
	{		
		[Bindable]public var _xmlList:XMLList;
		[Bindable]public var _status:String;		
		private var _old_xmlList:XMLList;
							
		private var ListLoader:URLLoader;
		public var serverURL:String;

		private var RequestURL:String="SQLAdmin.asp";
		private var loader:URLLoader = new URLLoader();
		
		public var server:String;
		public var database:String;
		public var uid:String;
		public var pwd:String;
		
		public var SQL:String;
		public var MaxPerPage:int;
		public var CurrentPage:int;

		public function SQLAdmin()
		{		
			serverURL=ModelLocator.getInstance().ServerURL;
			server = "";
			database="";
			uid="sa";
			pwd="";
			SQL = "";
			MaxPerPage = 50;
			CurrentPage = 1;
		}
																					
		public function Request():void
		{
			CursorManager.setBusyCursor();
			
			var variables:URLVariables = new URLVariables();
			variables.SQL = this.SQL;
			variables.serverName=this.server;
			variables.uid=this.uid;
			variables.pwd=this.pwd;
			variables.database=this.database;
			variables.MaxPerPage=this.MaxPerPage;
			variables.Page = this.CurrentPage;

			var tempURL:String=serverURL+RequestURL;
			var request:URLRequest = new URLRequest(tempURL);
			request.data = variables;
			request.method = URLRequestMethod.POST;												
			 
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, loader_complete);
			loader.addEventListener(Event.OPEN, loader_open);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, loader_httpStatus);
			loader.addEventListener(ProgressEvent.PROGRESS, loader_progress);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_security);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError);
			
			try{
				loader.load(request);
			}catch(err:Error)
			{
				Alert.show(err.message);
				CursorManager.removeBusyCursor();
			}			
		}
			
		private function loader_complete (e:Event):void 
		{
			trace(e.target.data);			
			this._status="数据接收完毕";
			try{				
				var tempXML:XML = new XML(e.target.data);
				_xmlList = tempXML.data;			
				_old_xmlList=_xmlList;
				dispatchEvent(new Event("RequestCallback"));	
			}	catch(err:Error){
				mx.controls.Alert.show("数据请求出错，请重新检索!","网络错误");		
				if(_old_xmlList)
				{
					_old_xmlList=_xmlList;
				}
			}	
			CursorManager.removeBusyCursor();
		}
		private function loader_open (e:Event):void {
			this._status="数据请求中，数据量["+loader.bytesLoaded+"]";
		}
		private function loader_httpStatus (e:HTTPStatusEvent):void {
			 //trace("HTTPStatusEvent.HTTP_STATUS");
			//trace("HTTP 状态代码 : " + e.status);
		}
		private function loader_progress (e:ProgressEvent):void {
			 this._status=loader.bytesLoaded+"/"+loader.bytesTotal;
		}
		private function loader_security (e:SecurityErrorEvent):void {
			 CursorManager.removeBusyCursor();
			 this._status = "SecurityErrorEvent.SECURITY_ERROR";
		}
		private function loader_ioError (e:IOErrorEvent):void {
			this._status = "数据请求出错，请检查网络设置是否正确!";
		 	CursorManager.removeBusyCursor();
		 	dispatchEvent(new Event("IOError"));
		}																			
	}
}
