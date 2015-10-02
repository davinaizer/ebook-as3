package com.unboxds.ebook.view.ui
{
	import assets.IndexPanelSymbol;
	import assets.TickerSymbol;
	import assets.buttons.btMenuItem;
	import assets.buttons.btSubmenuItem;

	import com.unboxds.button.IButton;
	import com.unboxds.button.SimpleButton;
	import com.unboxds.ebook.EbookApi;
	import com.unboxds.ebook.events.NavEvent;
	import com.unboxds.ebook.model.vo.PageData;
	import com.unboxds.ebook.view.components.List;
	import com.unboxds.ebook.view.components.ListBuilder;
	import com.unboxds.ebook.view.components.StepperBar;
	import com.unboxds.ebook.view.parser.ContentParser;
	import com.unboxds.utils.Logger;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class IndexPanel extends ContentObject
	{
		private var design:IndexPanelSymbol;

		private var list:List;
		private var subList:List;
		private var menuList:XMLList;
		private var scrollBar:StepperBar;
		private var scrollBar2:StepperBar;
		private var selectedBtn:IButton;

		public function IndexPanel(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			super(contentXML, stylesheet);

			Logger.log("IndexPanel.IndexPanel");
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
			initEvents();
		}

		//TODO Function is too long. Refactor
		public function init():void
		{
			Logger.log("IndexPanel.init");

			this.x = parseFloat(contentXML.@x);
			this.y = parseFloat(contentXML.@y);

			design = new IndexPanelSymbol();
			design.cacheAsBitmap = true;
			design.baseBox_Placeholder.alpha = 0;
			addChild(design);

			var listData:XMLList = contentXML.component.(@type == "List");

			//-- list panel 
			list = new ListBuilder().fromXML(listData[0]).build();
			list.buttonClass = btMenuItem;
			list.buttonPrefix = "btMenuItem";
			list.stylesheet = stylesheet;
			list.onClick.add(onListClick);
			list.onChange.add(onListChange);

			//-- sublist panel
			subList = new ListBuilder().fromXML(listData[1]).build();
			subList.buttonClass = btSubmenuItem;
			subList.buttonPrefix = "btSubmenuItem";
			subList.stylesheet = stylesheet;
			subList.onClick.add(onListClick);
			subList.onChange.add(onListChange);

			//-- create SCROLLBARS
			var scrollbarData:XMLList = contentXML.component.(@type == "Scrollbar");
			scrollBar = new StepperBar();
			scrollBar.x = parseFloat(scrollbarData[0].@x);
			scrollBar.y = parseFloat(scrollbarData[0].@y);
			scrollBar.barWidth = parseInt(scrollbarData[0].@width);
			scrollBar.barHeight = parseInt(scrollbarData[0].@height);
			scrollBar.barColor = parseInt(scrollbarData[0].@scrollbarColor);
			scrollBar.barColorAlpha = parseFloat(scrollbarData[0].@scrollbarColorAlpha);
			scrollBar.thumbColor = parseInt(scrollbarData[0].@thumbColor);
			scrollBar.thumbColorAlpha = parseFloat(scrollbarData[0].@thumbColorAlpha);
			scrollBar.autoHideThumb = scrollbarData[0].@autoHideThumb == "true";

			scrollBar2 = new StepperBar();
			scrollBar2.x = parseFloat(scrollbarData[1].@x);
			scrollBar2.y = parseFloat(scrollbarData[1].@y);
			scrollBar2.barWidth = parseInt(scrollbarData[1].@width);
			scrollBar2.barHeight = parseInt(scrollbarData[1].@height);
			scrollBar2.barColor = parseInt(scrollbarData[1].@scrollbarColor);
			scrollBar2.barColorAlpha = parseFloat(scrollbarData[1].@scrollbarColorAlpha);
			scrollBar2.thumbColor = parseInt(scrollbarData[1].@thumbColor);
			scrollBar2.thumbColorAlpha = parseFloat(scrollbarData[1].@thumbColorAlpha);
			scrollBar2.autoHideThumb = scrollbarData[1].@autoHideThumb == "true";

			addChild(subList);
			addChild(list);

			addChild(scrollBar2);
			addChild(scrollBar);

			menuList = contentXML.component.(@type == "menu");
			populateList(XML(menuList.toXMLString()), list);

			new ContentParser(design, contentXML, stylesheet).parse();
		}

		private function initEvents():void
		{
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			design.addEventListener(MouseEvent.CLICK, navHandler, false, 0, true);
		}

		private function onMouseWheel(e:MouseEvent):void
		{
			var listP:List = e.stageX > stage.stageWidth / 2 ? subList : list;
			e.delta > 0 ? listP.backPage() : listP.nextPage();
		}

		private function navHandler(e:MouseEvent):void
		{
			var src:DisplayObject = e.target as DisplayObject;
			if (src == design.btnNext)
			{
				list.nextPage();
			}
			else if (src == design.btnNext2)
			{
				subList.nextPage();
			}
			else if (src == design.btnBack)
			{
				list.backPage();
			}
			else if (src == design.btnBack2)
			{
				subList.backPage();
			}
		}

		//TODO Refactor this function
		private function onListChange(listP:List):void
		{
			var isNextEnabled:Boolean = listP.totalItems > 0 && !(listP.currentPage == listP.totalPages - 1);
			var isBackEnabled:Boolean = listP.totalItems > 0 && listP.currentPage != 0;

			if (listP == list && scrollBar)
			{
				scrollBar.steps = listP.totalPages;
				scrollBar.current = listP.currentPage + 1;
				design.btnNext.setEnabled(isNextEnabled);
				design.btnBack.setEnabled(isBackEnabled);

			}
			else if (listP == subList && scrollBar2)
			{
				scrollBar2.steps = listP.totalPages;
				scrollBar2.current = listP.currentPage + 1;
				design.btnNext2.setEnabled(isNextEnabled);
				design.btnBack2.setEnabled(isBackEnabled);
			}
		}

		private function onListClick(e:MouseEvent):void
		{
			if (e.target is SimpleButton)
			{
				var btn:SimpleButton = e.target as SimpleButton;
				var srcName:String = btn.name;
				var evt:NavEvent = new NavEvent(NavEvent.GOTO_PAGE, true);

				if (srcName.indexOf("btMenuItem") > -1)
				{
					if (selectedBtn)
						selectedBtn.setSelected(false);
					selectedBtn = btn;

					var submenuList:XML = XML(XMLList(menuList.content[btn.index]).toXMLString());
					if (submenuList.content.length() > 0)
					{
						btn.setSelected(true);
						design.listPanel2_Bg.alpha = 1;

						populateList(submenuList, subList);
						invalidateList(submenuList, subList);
					}
					else
					{
						evt.pageID = menuList.content[btn.index].@pageID;
						subList.destroy();
						design.listPanel2_Bg.alpha = 0;
						dispatchEvent(evt);
					}
				}
				else if (srcName.indexOf("btSubmenuItem") > -1)
				{
					evt.pageID = menuList.content[selectedBtn.index].content[btn.index].@pageID;
					dispatchEvent(evt);
				}
			}
		}

		private function populateList(data:XML, list:List):void
		{
			if (list != null)
			{
				list.destroy();

				if (data.content.length() > 0)
				{
					for (var i:int = 0; i < data.content.length(); i++)
						list.insert(i, data.content[i].title.toString());
					list.update();
				}
			}
		}

		override public function show():void
		{
			super.show();

			invalidateList(XML(menuList.toXMLString()), list);
			subList.destroy();
			design.listPanel2_Bg.alpha = 0;

			if (selectedBtn)
				selectedBtn.setSelected(false);
		}

		private function invalidateList(data:XML, listP:List):void
		{
			if (EbookApi.getInstance().getEbookModel().isConsultMode == false)
			{
				var lastUserPage:PageData = EbookApi.getInstance().getNavModel().getUserLastPage();
				var isLastModPage:Boolean = lastUserPage.counter[0] == lastUserPage.counter[1];
				var isButtonEnabled:Boolean = false;
				var isModuleCompleted:Boolean = false;
				var hasTicker:Boolean = false;
				var firstPage:PageData;
				var lastPage:PageData;
				var btn:SimpleButton;
				var i:uint = 0;

				for (i = 0; i < listP.totalItems; i++)
				{
					firstPage = EbookApi.getInstance().getNavModel().getPageByName(data.content[i].@pageID);
					lastPage = "@lastPageID" in data.content[i] ? EbookApi.getInstance().getNavModel().getPageByName(data.content[i].@lastPageID) : firstPage;

					btn = listP.getButtonByIndex(i);

					isButtonEnabled = lastUserPage.index >= firstPage.index;
					if (!btn.isSelected)
						btn.setEnabled(isButtonEnabled);

					isModuleCompleted = lastUserPage.index > lastPage.index;
					hasTicker = btn.getChildByName("tickerIcon") != null;

					if (!hasTicker && isModuleCompleted)
					{
						var ticker:Sprite = new TickerSymbol();
						ticker.name = "tickerIcon";
						ticker.y = (btn.height - ticker.height) / 2;
						btn.addChild(ticker);
					}
				}
			}
		}

	}

}
