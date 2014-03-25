package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class BookmarkRetrievedEvent extends Event
	{
		public static var BOOKMARK_RETRIEVED:String = "bookmark retrieved";
		
		public function BookmarkRetrievedEvent() {
			super(BOOKMARK_RETRIEVED);
		}
		
		public override function clone():Event
		{
			var bookmarkRetrievedEvent:BookmarkRetrievedEvent = new BookmarkRetrievedEvent();
			return bookmarkRetrievedEvent;
		}
		
		public override function toString():String
		{
			return formatToString( "BookmarkRetrievedEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
	}
}