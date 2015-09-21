package com.unboxds.ebook.view.ui
{
	import assets.BookmarkPanelSymbol;
	import assets.buttons.btBookmarkItem;
	import com.unboxds.button.SimpleButton;
	import com.unboxds.ebook.Ebook;
	import com.unboxds.ebook.model.ContentParser;
	import com.unboxds.ebook.model.vo.PageData;
	import com.unboxds.ebook.view.components.List;
	import com.unboxds.ebook.view.components.ListBuilder;
	import com.unboxds.ebook.view.components.StepperBar;
	import com.unboxds.ebook.view.ui.ContentObject;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.StringUtils;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author UNBOX
	 */
	public class BookmarkPanel extends ContentObject
	{
		private var design:BookmarkPanelSymbol;
		private var list:List;
		private var btnNext:SimpleButton;
		private var btnBack:SimpleButton;
		private var scrollBar:StepperBar;
		private var statusTxt:TextField;
		
		private var hasInit:Boolean;
		private var statusStr:String;
		private var itemLabel:String;
		
		public var pageTitle:String;
		public var pageModuleIndex:int;
		public var pageLocalIndex:int;
		public var firstItem:uint;
		public var lastItem:uint;
		public var totalItems:uint;
		
		public function BookmarkPanel(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			Logger.log("BookmarkPanel.BookmarkPanel");
			
			super(contentXML, stylesheet);
			
			hasInit = false;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
			initEvents();
		}
		
		public function init():void
		{
			Logger.log("BookmarkPanel.init");
			
			this.x = parseFloat(contentXML.@x);
			this.y = parseFloat(contentXML.@y);
			
			design = new BookmarkPanelSymbol();
			design.cacheAsBitmap = true;
			design.baseBox_Placeholder.alpha = 0;
			addChild(design);
			
			statusTxt = design.statusTxt;
			btnNext = design.btnNext as SimpleButton;
			btnBack = design.btnBack as SimpleButton;
			
			var listData:XMLList = contentXML.object.(@type == "List");
			list = new ListBuilder().fromXML(listData[0]).build();
			list.buttonClass = btBookmarkItem;
			list.buttonPrefix = "btBookmarkItem";
			list.stylesheet = stylesheet;
			list.onChange.add(onListChange);
			
			var scrollbarData:XMLList = contentXML.object.(@type == "Scrollbar");
			scrollBar = new StepperBar();
			scrollBar.x = parseFloat(scrollbarData[0].@x);
			scrollBar.y = parseFloat(scrollbarData[0].@y);
			scrollBar.barWidth = parseInt(scrollbarData[0].@width);
			scrollBar.barHeight = parseInt(scrollbarData[0].@height);
			scrollBar.barColor = parseInt(scrollbarData[0].@scrollbarColor);
			scrollBar.barColorAlpha = parseFloat(scrollbarData[0].@scrollbarColorAlpha);
			scrollBar.thumbColor = parseInt(scrollbarData[0].@thumbColor);
			scrollBar.thumbColorAlpha = parseFloat(scrollbarData[0].@thumbColorAlpha);
			scrollBar.autoHideThumb = scrollbarData[0].@autoHideThumb == "true" ? true : false;
			
			addChild(list);
			addChild(scrollBar);
			
			new ContentParser(design, contentXML, stylesheet).parse();
			
			statusTxt.text = "";
			statusStr = contentXML.content.(@type == "text").content.(@instanceName == "statusTxt").title.toString();
			itemLabel = contentXML.content.(@type == "text").content.(@instanceName == "itemLabel").title.toString();
		}
		
		private function initEvents():void
		{
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			design.addEventListener(MouseEvent.CLICK, navHandler, false, 0, true);
		}
		
		private function onMouseWheel(e:MouseEvent):void
		{
			e.delta > 0 ? list.backPage() : list.nextPage();
		}
		
		private function navHandler(e:MouseEvent):void
		{
			var src:DisplayObject = e.target as DisplayObject;
			if (src == design.btnNext)
			{
				list.nextPage();
			}
			else if (src == design.btnBack)
			{
				list.backPage();
			}
		}
		
		private function onListChange(listP:List):void
		{
			var isNextEnabled:Boolean = listP.totalItems > 0 && !(listP.currentPage == listP.totalPages - 1);
			var isBackEnabled:Boolean = listP.totalItems > 0 && listP.currentPage != 0;
			
			btnNext.setEnabled(isNextEnabled);
			btnBack.setEnabled(isBackEnabled);
			
			if (scrollBar)
			{
				scrollBar.steps = listP.totalPages;
				scrollBar.current = listP.currentPage + 1;
			}
			
			//-- RESULT REPORT
			if (list.totalItems > 0)
			{
				firstItem = list.maxItensPerPage * list.currentPage + 1;
				lastItem = (list.maxItensPerPage * (list.currentPage + 1));
				lastItem = lastItem > list.totalItems ? list.totalItems : lastItem;
				totalItems = list.totalItems;
				
				statusTxt.htmlText = StringUtils.parseTextVars(statusStr, this);
			}
			else
			{
				statusTxt.text = "";
			}
		}
		
		override public function show():void
		{
			if (!hasInit)
			{
				var bookmarks:Array = Ebook.getInstance().getStatus().lessonStatus.bookmarks;
				var len:int = bookmarks.length;
				for (var i:int = 0; i < len; i++)
				{
					var page:PageData = Ebook.getInstance().getNav().getPageByIndex(bookmarks[i]);
					insert(page);
				}
				
				hasInit = true;
			}
			
			super.show();
		}
		
		public function insert(page:PageData):void
		{
			pageTitle = page.title;
			pageModuleIndex = page.moduleIndex + 1;
			pageLocalIndex = page.localIndex + 1;
			
			list.insert(page.index, StringUtils.parseTextVars(itemLabel, this));
			list.update(page.index);
		}
		
		public function remove(page:PageData):void
		{
			if (hasInit)
			{
				list.remove(page.index);
				list.update(page.index);
			}
		}
		
		public function update(index:int = -1):void
		{
			if (hasInit)
				list.update(index);
		}
	
	}

}