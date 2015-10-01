package com.unboxds.ebook.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class NavEvent extends Event
	{
		public static const GOTO_PAGE:String = "NavEvent.gotoPage";
		public static const NEXT_PAGE:String = "NavEvent.nextPage";
		public static const BACK_PAGE:String = "NavEvent.backPage";
		
		private var _pageID:String;
		private var _pageIndex:uint;
		
		public function NavEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new NavEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("NavEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
		public function get pageID():String
		{
			return _pageID;
		}
		
		public function set pageID(value:String):void
		{
			_pageID = value;
		}
		
		public function get pageIndex():uint
		{
			return _pageIndex;
		}
		
		public function set pageIndex(value:uint):void
		{
			_pageIndex = value;
		}
	}

}