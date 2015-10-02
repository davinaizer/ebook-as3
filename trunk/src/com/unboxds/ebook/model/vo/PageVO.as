package com.unboxds.ebook.model.vo
{
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015
	 */
	public class PageVO
	{
		private var _index:int;
		private var _moduleIndex:int;
		private var _localIndex:int;
		private var _counter:Array;
		private var _branch:String;
		private var _title:String;
		private var _modTitle:String;
		private var _src:String;
		private var _contentURL:String;
		private var _pageTransitionIn:String;
		private var _pageTransitionOut:String;
		private var _contentTransitionIn:String;
		private var _contentTransitionOut:String;
		private var _navbarStatus:String;
		private var _showProgress:Boolean;
		
		public function PageVO()
		{
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		public function get moduleIndex():int
		{
			return _moduleIndex;
		}
		
		public function set moduleIndex(value:int):void
		{
			_moduleIndex = value;
		}
		
		public function get branch():String
		{
			return _branch;
		}
		
		public function set branch(value:String):void
		{
			_branch = value;
		}
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = value;
		}
		
		public function get navbarStatus():String
		{
			return _navbarStatus;
		}
		
		public function set navbarStatus(value:String):void
		{
			_navbarStatus = value;
		}
		
		public function get src():String
		{
			return _src;
		}
		
		public function set src(value:String):void
		{
			_src = value;
		}
		
		public function get contentURL():String
		{
			return _contentURL;
		}
		
		public function set contentURL(value:String):void
		{
			_contentURL = value;
		}
		
		public function get localIndex():int
		{
			return _localIndex;
		}
		
		public function set localIndex(value:int):void
		{
			_localIndex = value;
		}
		
		public function get pageTransitionIn():String
		{
			return _pageTransitionIn;
		}
		
		public function set pageTransitionIn(value:String):void
		{
			_pageTransitionIn = value;
		}
		
		public function get pageTransitionOut():String
		{
			return _pageTransitionOut;
		}
		
		public function set pageTransitionOut(value:String):void
		{
			_pageTransitionOut = value;
		}
		
		public function get showProgress():Boolean
		{
			return _showProgress;
		}
		
		public function set showProgress(value:Boolean):void
		{
			_showProgress = value;
		}
		
		public function get contentTransitionIn():String
		{
			return _contentTransitionIn;
		}
		
		public function set contentTransitionIn(value:String):void
		{
			_contentTransitionIn = value;
		}
		
		public function get contentTransitionOut():String
		{
			return _contentTransitionOut;
		}
		
		public function set contentTransitionOut(value:String):void
		{
			_contentTransitionOut = value;
		}
		
		public function get counter():Array
		{
			return _counter;
		}
		
		public function set counter(value:Array):void
		{
			_counter = value;
		}
		
		public function get modTitle():String 
		{
			return _modTitle;
		}
		
		public function set modTitle(value:String):void 
		{
			_modTitle = value;
		}
		
		public function toString():String
		{
			var ret:String = ">>>> Page Data <<<<";
			ret += "\n	• index: " + _index;
			ret += "\n	• moduleIndex: " + _moduleIndex;
			ret += "\n	• localIndex: " + _localIndex;
			ret += "\n	• counter: " + _counter;
			ret += "\n	• branch: " + _branch;
			ret += "\n	• src: " + _src;
			ret += "\n	• title: " + _title;
			ret += "\n	• contentURL: " + _contentURL;
			ret += "\n	• navbarStatus: " + _navbarStatus;
			ret += "\n	• showProgress: " + _showProgress;
			ret += "\n	• pageTransitionIn: " + _pageTransitionIn;
			ret += "\n	• pageTransitionOut: " + _pageTransitionOut;
			ret += "\n	• contentTransitionIn: " + _contentTransitionIn;
			ret += "\n	• contentTransitionOut: " + _contentTransitionOut;
			ret += "\n-------------------";
			
			return ret;
		}
	
	}

}