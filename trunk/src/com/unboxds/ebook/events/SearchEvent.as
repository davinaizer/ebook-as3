package com.unboxds.ebook.events
{
	import flash.events.DataEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	
	//TODO Create Signals from this Event Class
	public class SearchEvent extends DataEvent
	{
		public static const SEARCH:String = "search";
		public static const SEARCH_END:String = "searchEnd";
		public static const SEARCH_COMPLETE:String = "searchComplete";
		public static const INDEX_COMPLETE:String = "indexComplete";
		
		public function SearchEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:String = "")
		{
			super(type, bubbles, cancelable, data);
		}
		
		public override function clone():Event
		{
			return new SearchEvent(type, bubbles, cancelable, data);
		}
		
		public override function toString():String
		{
			return formatToString("SearchEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	
	}

}