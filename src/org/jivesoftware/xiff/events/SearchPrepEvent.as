package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	
	public class SearchPrepEvent extends Event
	{
		public static const SEARCH_PREP_COMPLETE:String = "searchPrepComplete";
		
		private var _server:String;
		
		public function SearchPrepEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get server():String
		{
			return _server;
		}
		public function set server(s:String):void
		{
			_server = s;
		}
		
		public override function clone():Event
		{
			var searchPrepEvent:SearchPrepEvent = new SearchPrepEvent( type, bubbles, cancelable );
			searchPrepEvent.server = server;
			return searchPrepEvent;
		}
		
		public override function toString():String
		{
			return formatToString( "SearchPrepEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
	}
}