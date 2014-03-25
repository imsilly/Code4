package app{
	import app.utils.AppCommand;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.system.Security;
	import app.vo.*;
	public class RemotingConnection extends NetConnection {
		public var configInfo:ConfigInfo = new ConfigInfo();//系统配置
		public function RemotingConnection(gatewayURL:String = null) {
			this.addEventListener(NetStatusEvent.NET_STATUS, netStatusAction);
			//configInfo = Controller.getInstance().configInfo;
			if (null == gatewayURL)
			{
				gatewayURL = configInfo.ServerURL;
			}
			Security.allowDomain(gatewayURL);
			this.objectEncoding=ObjectEncoding.AMF3;
			this.connect(gatewayURL);
		}
		private function netStatusAction(e:NetStatusEvent)
		{
			//Controller.getInstance().addBox(AppCommand.SHOW_ERROR_BOX,"NetConnection error!");
			//trace("netStatusAction:"+e.type);
			switch(e.type) {  
                case AsyncErrorEvent.ASYNC_ERROR:  
                    break;  
                case "NetConnection.Call.Failed":  
					//Controller.getInstance().addBox(AppCommand.SHOW_SYSTEM_TIPS_BOX,"NetConnection.Call.Failed!");
                    break; 					
                default:  
                    dispatchEvent(e);  
            }    
		}		
	}
}