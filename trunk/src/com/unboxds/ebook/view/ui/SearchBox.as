package com.unboxds.ebook.view.ui
{
	import assets.SearchBoxSymbol;

	import com.chewtinfoil.utils.StringUtils;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import com.unboxds.button.ToggleButton;
	import com.unboxds.ebook.model.events.SearchEvent;
	import com.unboxds.utils.Logger;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;

	import net.tw.util.StringUtil;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class SearchBox extends UIPanel
	{
		private var view:SearchBoxSymbol;
		
		private var _title:String = "";
		private var _loadTitle:String = "";
		private var _minChars:uint = 3;
		private var _keyword:String;
		private var _hasSearched:Boolean;
		
		public var searchTxt:TextField;
		public var searchBtn:ToggleButton;
		public var loaderIcon:Sprite;
		public var searchBoxBg:Sprite;
		public var searchBoxBgWidth:int;
		
		public function SearchBox(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			super(contentXML, stylesheet);
			
			Logger.log("SearchBox.SearchBox");
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}
		
		public function init():void
		{
			Logger.log("SearchBox.init");
			
			view = new SearchBoxSymbol();
			view.cacheAsBitmap = true;
			view.x = parseFloat(contentXML.@x);
			view.y = parseFloat(contentXML.@y);
			addChild(view);
			
			target = view;
			
			searchBtn = view.searchBtn;
			searchTxt = view.searchTxt;
			loaderIcon = view.loaderIcon;
			searchBoxBg = view.searchBoxBg;
			searchBoxBgWidth = searchBoxBg.width;
			
			_title = contentXML.@title;
			_loadTitle = contentXML.@loadTitle;
			_minChars = parseInt(contentXML.@minChars);
			
			searchTxt.visible = false;
			searchTxt.text = _loadTitle;
			
			searchBtn.setEnabled(false);
			searchBoxBg.alpha = 0;
			
			initEvents();
			parseContent();
		}
		
		private function initEvents():void
		{
			searchBtn.addEventListener(MouseEvent.CLICK, searchHandler, false, 0, true);
			
			searchTxt.addEventListener(KeyboardEvent.KEY_UP, keyboardHandler, false, 0, true);
			searchTxt.addEventListener(FocusEvent.FOCUS_IN, searchFocusHandler, false, 0, true);
			searchTxt.addEventListener(FocusEvent.FOCUS_OUT, searchFocusHandler, false, 0, true);
			
			stage.addEventListener(MouseEvent.CLICK, stageHandler);
		}
		
		private function stageHandler(e:MouseEvent):void
		{
			//-- check for outside click and if user hasnt searched yet
			if (_isOpen && !_hasSearched && !this.contains(DisplayObject(e.target)))
				this.close();
		}
		
		private function keyboardHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				//TODO REFACTOR CODE
				if (_hasSearched)
				{
					if (searchTxt.text != keyword)
						validateSearch();
				}
				else
				{
					validateSearch();
				}

			}
			else if (e.keyCode == Keyboard.ESCAPE)
			{
				this.close();
			}

			if (_hasSearched && searchBtn.isToggled && searchTxt.text != keyword)
				searchBtn.toggle();

			e.stopPropagation();
		}
		
		private function searchHandler(e:MouseEvent):void
		{
			Logger.log("SearchBox.searchHandler > e: " + e.target.name);
			
			if (e.target == searchBtn)
			{
				if (_isOpen)
				{
					//TODO REFACTOR CODE
					if (_hasSearched)
					{
						if (searchTxt.text != keyword)
						{
							validateSearch();
						}
						else if (searchBtn.isToggled)
						{
							close();
						}
					}
					else
					{
						validateSearch();
					}
				}
				else
				{
					this.open();
				}
			}
		}
		
		private function validateSearch():void
		{
			var hasMinLength:Boolean = searchTxt.text.length >= minChars;
			var hasChanged:Boolean = searchTxt.text != keyword;
			
			if (hasMinLength && hasChanged)
			{
				_hasSearched = true;
				
				if (!searchBtn.isToggled)
					searchBtn.toggle();
				
				dispatchKeyword();
				setTimeout(searchTxt.setSelection, 50, 0, searchTxt.text.length);
			}
		}
		
		private function searchFocusHandler(e:FocusEvent):void
		{
			switch (e.type)
			{
				case FocusEvent.FOCUS_IN:
					if (searchTxt.text == _title)
						searchTxt.text = "";
					setTimeout(searchTxt.setSelection, 50, 0, searchTxt.text.length);
					
					break;
				
				case FocusEvent.FOCUS_OUT:
					if (searchTxt.text == "")
					{
						close();
					}
					break;
				
				default:
					break;
			}
			
			e.stopPropagation();
		}
		
		private function dispatchKeyword():void
		{
			Logger.log("SearchBox.dispatchKeyword");
			
			if (searchTxt.text != keyword && searchTxt.text != "")
			{
				keyword = searchTxt.text;
				keyword = StringUtil.cleanSpecialChars(keyword.toLowerCase());
				keyword = StringUtils.removeExtraWhitespace(keyword);
				
				//enable(false);
				
				var evt:SearchEvent = new SearchEvent(SearchEvent.SEARCH, true);
				evt.data = keyword;
				dispatchEvent(evt);
			}
		}
		
		public function enable(value:Boolean):void
		{
			searchBtn.visible = value;
			loaderIcon.visible = !value;
		}
		
		override public function open():void
		{
			Logger.log("SearchBox.open");
			
			if (!_isOpen)
			{
				_isOpen = true;
				
				searchBoxBg.scaleX = 0;
				
				TweenLite.to(searchTxt, .5, {autoAlpha: 1});
				TweenLite.to(searchBoxBg, .5, {autoAlpha: 1, scaleX: 1, ease: Quint.easeOut});
				TweenLite.to(searchBtn, .5, {x: searchBoxBgWidth, ease: Quint.easeOut});
				
				stage.focus = searchTxt;
				
				_onOpen.dispatch();
			}
		}
		
		override public function close():void
		{
			Logger.log("SearchBox.close");
			
			if (_isOpen)
			{
				_isOpen = false;
				_hasSearched = false;
				keyword = "";
				searchTxt.text = "";

				stage.focus = stage;

				if (searchBtn.isToggled)
					searchBtn.toggle();

				TweenLite.to(searchTxt, .5, {autoAlpha: 0});
				TweenLite.to(searchBoxBg, .5, {autoAlpha: 0, scaleX: 0, ease: Quint.easeOut});
				TweenLite.to(searchBtn, .5, {x: 0, ease: Quint.easeOut});
				
				_onClose.dispatch();
				dispatchEvent(new SearchEvent(SearchEvent.SEARCH_END, true));
			}
		}
		
		override public function show():void
		{
			TweenLite.to(target, .25, {autoAlpha: 1});
		}
		
		override public function hide():void
		{
			TweenLite.to(target, .25, {autoAlpha: 0});
		}
		
		public function get keyword():String
		{
			return _keyword;
		}
		
		public function set keyword(value:String):void
		{
			_keyword = value;
		}
		
		public function get minChars():int
		{
			return _minChars;
		}
		
		public function set minChars(value:int):void
		{
			_minChars = value;
		}
		
		public function get loadSubtitle():String
		{
			return _loadTitle;
		}
		
		public function set loadSubtitle(value:String):void
		{
			_loadTitle = value;
		}
		
		public function get subtitle():String
		{
			return _title;
		}
		
		public function set subtitle(value:String):void
		{
			_title = value;
		}
		
		public function get hasSearched():Boolean
		{
			return _hasSearched;
		}

	}

}