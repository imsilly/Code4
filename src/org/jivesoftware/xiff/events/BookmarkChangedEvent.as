package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	
	import org.jivesoftware.xiff.bookmark.GroupChatBookmark;
	import org.jivesoftware.xiff.bookmark.UrlBookmark;

	public class BookmarkChangedEvent extends Event
	{
		public static const GROUPCHAT_BOOKMARK_ADDED:String = "groupchat bookmark retrieved";
		public static const GROUPCHAT_BOOKMARK_REMOVED:String = "groupchat bookmark removed";
		//add url types here when needed
		
		public var groupchatBookmark:GroupChatBookmark = null;
		public var urlBookmark:UrlBookmark = null;
		
		public function BookmarkChangedEvent(type:String, bookmark:*) {
			super(type);
			if(bookmark is GroupChatBookmark)
				groupchatBookmark = bookmark as GroupChatBookmark;
			else
				urlBookmark = bookmark as UrlBookmark;
		}
		
		public override function clone():Event
		{
			var bookmark:* = groupchatBookmark ? groupchatBookmark : urlBookmark;
			var bookmarkChangedEvent:BookmarkChangedEvent = new BookmarkChangedEvent( type, bookmark );
			bookmarkChangedEvent.groupchatBookmark = groupchatBookmark;
			bookmarkChangedEvent.urlBookmark = urlBookmark;
			return bookmarkChangedEvent;
		}
		
		public override function toString():String
		{
			return formatToString( "BookmarkChangedEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
	}
}