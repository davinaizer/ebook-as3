package com.unboxds.ebook.view
{
	import com.unboxds.ebook.view.ui.*;
	import assets.NavbarSymbol;

	import com.greensock.TweenMax;
	import com.hybrid.ui.ToolTip;
	import com.unboxds.button.SimpleButton;
	import com.unboxds.button.ToggleButton;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.TweenParser;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;

	/**
	 * ...
	 * @author UNBOX Learning Experience
	 */
	public class NavBarView extends ContentObject
	{
		private var view:NavbarSymbol;
		
		private var navBtns:Vector.<SimpleButton>;
		private var tooltip:ToolTip;
		private var tooltipData:XMLList;
		private var tweenNextBtn:TweenMax;
		private var _isKeyboardAvailable:Boolean;
		
		//-- NAV OBJECTS
		public var helpBtn:ToggleButton;
		public var dashboardBtn:ToggleButton;
		public var bookmarkAddBtn:SimpleButton;
		public var bookmarkRemoveBtn:SimpleButton;
		public var backBtn:SimpleButton;
		public var nextBtn:SimpleButton;
		private var _searchBox:SearchBox;
		
		public function NavBarView(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			Logger.log("NavBar.NavBar");
			
			super(contentXML, stylesheet);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}
		
		public function init():void
		{
			Logger.log("NavBar.init");
			
			view = new NavbarSymbol();
			view.cacheAsBitmap = true;
			view.x = parseFloat(contentXML.@x);
			view.y = parseFloat(contentXML.@y);
			addChild(view);
			
			target = view;
			
			//-- get refs
			helpBtn = view.helpBtn;
			nextBtn = view.nextBtn;
			backBtn = view.backBtn;
			dashboardBtn = view.dashboardBtn;
			bookmarkAddBtn = view.bookmarkAddBtn;
			bookmarkRemoveBtn = view.bookmarkRemoveBtn;
			
			//-- searchBox
			_searchBox = new SearchBox();
			_searchBox.contentXML = XML(XMLList(contentXML.component.(@type == "searchBox")).toXMLString());
			_searchBox.show();
			
			view.addChild(_searchBox);
			
			navBtns = new Vector.<SimpleButton>();
			navBtns.push(helpBtn);
			navBtns.push(dashboardBtn);
			navBtns.push(backBtn);
			navBtns.push(bookmarkAddBtn);
			navBtns.push(_searchBox.searchBtn);
			navBtns.push(nextBtn);
			
			bookmarkRemoveBtn.visible = false;
			
			status("000000"); // disable all buttons
			navBtns.pop(); // remove nextBtn from list
			
			initEvents();
			parseContent();
			show();
		}
		
		private function initEvents():void
		{
		}
		
		public override function parseContent():void
		{
			super.parseContent();
			
			//-- read Tweeen for NextButton
			var tweenData:XMLList = contentXML.tween.tween.(@id == "nextBtn");
			tweenNextBtn = TweenParser.getTweenFromXML(target, tweenData[0]);
			
			isKeyboardAvailable = (contentXML.@isKeyboardAvailable == "true") ? true : false;
			
			Logger.log("NavBar.isKeyboardAvailable: " + isKeyboardAvailable);
		}
		
		private function tooltipHandler(e:MouseEvent):void
		{
			var src:Sprite = e.target as Sprite;
			var index:int = src.tabIndex;
			
			tooltip.show(src, tooltipData.content[index].title.toString(), tooltipData.content[index].body.toString());
		}
		
		public function enableNextButton(value:Boolean = true):void
		{
			tweenNextBtn.currentTime = 0;
			tweenNextBtn.pause();
			
			if (value)
				tweenNextBtn.restart();
			
			nextBtn.setEnabled(value);
		}
		
		public function getNextButtonStatus():Boolean
		{
			return nextBtn.mouseEnabled;
		}
		
		public function getBackButtonStatus():Boolean
		{
			return backBtn.mouseEnabled;
		}
		
		public function status(value:String):void
		{
			for (var i:Number = 0; i < navBtns.length; i++)
			{
				var flag:Boolean = Boolean(int(value.charAt(i)));
				navBtns[i].setEnabled(flag);
			}
		}
		
		public function block(value:String):void
		{
			for (var i:Number = 0; i < navBtns.length; i++)
			{
				var flag:Boolean = Boolean(int(value.charAt(i)));
				navBtns[i].setLocked(flag);
			}
		}
		
		public function toggleDashBoardBtn():void
		{
			dashboardBtn.toggle();
		}
		
		public function toggleHelpBtn():void
		{
			helpBtn.toggle();
		}
		
		public function bookmarkPage(value:Boolean):void
		{
			bookmarkAddBtn.visible = !value;
			bookmarkRemoveBtn.visible = value;
		}
		
		public function get isKeyboardAvailable():Boolean
		{
			return _isKeyboardAvailable;
		}
		
		public function set isKeyboardAvailable(value:Boolean):void
		{
			_isKeyboardAvailable = value;
		}
		
		public function get searchBox():SearchBox
		{
			return _searchBox;
		}

	}

}