/*		
 * 		<Version>1.01</Version>
		<ServerURL>http://localhost/zombies/gateway.php</ServerURL>
		<DefaultUserID>2373</DefaultUserID>
		<Frequency>60</Frequency>
		<ShowLog>true</ShowLog>
		<MotionCoursor>false</MotionCoursor>
		<Status>1</Status>
		<SCREEN_MIN_X>300</SCREEN_MIN_X>
		<SCREEN_MAX_X>1000</SCREEN_MAX_X>
		<MAX_MIN_X>100</MAX_MIN_X>
		<MAX_MAX_X>1300</MAX_MAX_X>
		<MIN_DIS>400</MIN_DIS>
		<MAX_DIS>600</MAX_DIS>
		<RoleActionFrequency>5</RoleActionFrequency>
		<DefaultLanguag>zh</DefaultLanguag>
		<Language>
*/
package app.vo{
	import app.Controller;
	import flash.events.Event;
	dynamic public class ConfigInfo extends Object{
		public var Version:String="0.9";
		public var ServerURL:String="http://192.168.1.6/72xuan/gateway.php";//"http://silly.eblhost.com/gateway.php"
		public var DefaultUserID:String="2373";
		public var Frequency:String = "";
		public var ShowLog:String = "";		
		public var MotionCoursor:String = "";		
		public var Status:String = "";		
		public var SCREEN_MIN_X:String = "";		
		public var SCREEN_MAX_X:String = "";		
		public var MAX_MIN_X:String = "";		
		public var MAX_MAX_X:String = "";		
		public var MIN_DIS:String = "";		
		public var MAX_DIS:String = "";		
		public var RoleActionFrequency:String = "";		
		public var DefaultLanguag:String = "English";		
				
		public var propertyList:Array = new Array();//记录属性值
		
		public function ConfigInfo() {
			
		}
		public function init(value:Object = null)
		{	
			try{
				if (value != null)
				{
					for (var parm in value)
					{		
						if (propertyList.indexOf(parm) == -1)
						{
							propertyList.push(parm);
						}
						this[parm] = value[parm];					
					}
				}
			}catch (e:Error)
			{
				trace("UserInfo.init error:"+e.message);
			}
		}
		public function traceMe():Array
		{
			trace("ConfigInfo.traceMe..................");
			for (var i = 0; i < propertyList.length; i++)
			{
				trace(propertyList[i] + ":" + this[propertyList[i]]);
			}
			//Controller.getInstance().dispatchEvent(new Event("trace"));
			return propertyList;
		}		
		
		/*
		 * 记录系统怪物的基本信息，从后台读取怪物的基本属性
		 * 在resMemo内，以逗号分隔:工作体力消耗, 冷却时间,工作获银币,工作获经验,召唤时间
		 * */
		public var resBasicInfoList:Array = new Array();		
		/*
		 * 通过resID，从resBasicInfoList中取得内容。resBasicInfoList的初始化在viewport.as中。
		 * */
		public function getResBasicInfo(resID:String):Object
		{
			for (var i = 0; i < this.resBasicInfoList.length; i++)
			{
				if (this.resBasicInfoList[i].resID == resID)
				{
					return this.resBasicInfoList[i];
				}
			}
			return null;
		}
	}	
}
