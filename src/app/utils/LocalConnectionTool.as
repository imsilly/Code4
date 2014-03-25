package utils 
{
	import flash.net.LocalConnection;
	import flash.events.StatusEvent;
	/**
	 * ...通过localconnection在两个swf中传递消息的工具
	 * @author No21sec_dead
	 */
	public class LocalConnectionTool 
	{
		private var lc:LocalConnection;
		private var lc_current:String;
		private var lc_target:String;
		private var lc_obj:Object;
		
		public function LocalConnectionTool(current:String,target:String,obj:Object) 
		{
			lc_current = current;
			lc_target = target;
			lc_obj = obj;
			lc = new LocalConnection();
			lc.addEventListener(StatusEvent.STATUS, onStatus);
			connect();
		}
		private function connect() {
			try {
				lc.connect(lc_current);
				lc.client=
			}
		}
		
	}

}