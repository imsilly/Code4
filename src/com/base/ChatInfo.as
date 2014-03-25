package com.Silly.vo
{
	import com.LightMVC.vo.ValueObject;
	import mx.containers.Panel;
	import mx.collections.ArrayCollection;
	public class ChatInfo extends ValueObject
	{
		[Bindable]public var data:XMLList;
		[Bindable]public var userID:String;
		[Bindable]public var userName:String;
		[Bindable]public var userStatus:String;
		[Bindable]public var chatText:String;
		[Bindable]public var chatRecord:String;
		[Bindable]public var peopleList:ArrayCollection;
		 		
		public const USER_STATUS:String ="Online";
 		
		public function ChatInfo()
		{
 			//this.userStatus = USER_STATUS;
			this.description = "ChatInfo";
		}
	}
}