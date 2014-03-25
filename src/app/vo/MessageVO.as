package  app.vo{
	
	public class MessageVO {
		public var msgID:String;
		public var receiverID:String;
		public var receiverName:String;
		public var senderID:String;
		public var senderName:String;
		public var content:String;
		public var memo:String;
		public var updateDate:String;
		public var createDate:String;
		public function MessageVO() {
			// constructor code
		}
		public function init(value:Object = null)
		{	
			if (value != null)
			{
				for (var parm in value)
				{
					this[parm] = value[parm];
				}
			}
			return this;
		}
	}
	
}
